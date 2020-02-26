//
//  CommentModel.swift
//  MBC
//
//  Created by Tri Vo on 1/30/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class CommentViewModel: BaseViewModel {
    // MARK: variables and properties
    private var interactor: CommentInteractor
    private let startLoadCommentsOnDemand = PublishSubject<CommentSocial>()
    private var data: CommentSocial?
    
    // MARK: - Public properties
    var comments = [Comment]()
    
    // Rx
    var onWillStartGetComments = PublishSubject<Void>()
	var onWillErrorComments = PublishSubject<Void>()
    var onDidGetComments = PublishSubject<Bool>()
	
	private var didSendGetCommentsRequest = false
	private var pageSize = 0
    
    init(interactor: CommentInteractor) {
        self.interactor = interactor
        super.init()
        setUpRx()
    }
    
    // MARK: - Public functions
    func getComments() {
        guard var data = self.data, !didSendGetCommentsRequest else { return }
		data.setFromIndex(getTimeLastComment())
		didSendGetCommentsRequest = true
        startLoadCommentsOnDemand.onNext(data)
    }
	
	func requestMoreComment() {
		didSendGetCommentsRequest = false
		getComments()
	}
    
    func setContentId(_ data: String?) {
        guard let contentId = data, let user = interactor.getCurrentUser(), !contentId.isEmpty else { return }
		self.data = CommentSocial(userId: user.uid, contentId: contentId, siteName: Constants.DefaultValue.SiteName,
								  fromIndex: 0, size: Constants.DefaultValue.commentPanelPageSize)
    }
    
    func addComment(comment: Comment) {
        self.comments.insert(comment, at: 0)
    }
    
    func removeComment(at index: Int) {
        self.comments.remove(at: index)
    }
    
    func index(comment: Comment) -> Int? {
        return self.comments.index(where: { $0.commentId == comment.commentId })
    }
	
	func getTimeLastComment() -> Double {
		if self.comments.isEmpty { return 0 }
		return self.comments.last?.publishedDate?.milliseconds ?? 0
	}
    
    // MARK: - Private functions
    private func setUpRx() {
        setUpRxGetComments()
    }
    
    private func setUpRxGetComments() {
        startLoadCommentsOnDemand
            .do(onNext: { [unowned self] _ in
                self.onWillStartGetComments.onNext(())
            })
            .flatMap { [unowned self] data -> Observable<[Comment]> in
                return self.interactor.getComments(data: data)
                    .catchError { error -> Observable<[Comment]> in
                        self.onWillErrorComments.onNext(())
                        self.showError(error: error)
                        return Observable.empty()
                    }
            }
            .do(onNext: { [unowned self] item in
                item.forEach { self.comments.append($0) }
            })
            .do(onNext: { [unowned self] item in
				self.onDidGetComments.onNext((!(item.count < Constants.DefaultValue.commentPanelPageSize)))
            })
			.map { _ in Void() }
			.subscribe().disposed(by: disposeBag)
    }
}
