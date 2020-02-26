//
//  CommentViewController.swift
//  MBC
//
//  Created by Tri Vo on 1/30/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

private enum CommentSection: Int {
    case headerComment = 0
    case comments = 1
}

class CommentViewController: BaseViewController {
    
    @IBOutlet weak private var commentTableView: UITableView!
    @IBOutlet weak private var sendMessageView: SendMessageView!
    @IBOutlet weak private var messageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private var messageViewTopConstraint: NSLayoutConstraint!
    
    private var commentModel: CommentViewModel = CommentViewModel(interactor: Components.commentInteractor())
    private let tapTableViewGesture = UITapGestureRecognizer()
	private var isMoreComment: Bool = false
    
    var pageId: String?
    var contentId: String?
    var contentType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) { } else {
            messageViewTopConstraint.constant += Constants.DeviceMetric.statusBarHeight
        }
        setupTableView()
        setupData()
        bindEvents()
        getComments()
        
        self.sendMessageView.forceEditing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().isEnabled = true
    }
    
    private func setupTableView() {
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.rowHeight = UITableViewAutomaticDimension
        commentTableView.estimatedRowHeight = Constants.DefaultValue.estimatedTableRowHeight
        commentTableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        commentTableView.showsVerticalScrollIndicator = false
        commentTableView.showsHorizontalScrollIndicator = false
        commentTableView.allowsSelection = true
        commentTableView.backgroundColor = Colors.white.color()
        commentTableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        commentTableView.separatorStyle = .none
        
        commentTableView.register(R.nib.headerCommentViewCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.headerCommentViewCellId.identifier)
        commentTableView.register(R.nib.commentViewCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.commentViewCellId.identifier)
        
        tapTableViewGesture.delegate = self
        commentTableView.addGestureRecognizer(tapTableViewGesture)
        tapTableViewGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime).asObservable()
            .subscribe(onNext: { [unowned self] _ in
                self.view.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
    
    private func getComments() {
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.commentModel.getComments()
        })
    }
    
    private func bindEvents() {
        disposeBag.addDisposables([
            commentModel.onDidGetComments.subscribe(onNext: { [weak self] isLoadMore in
				self?.isMoreComment = isLoadMore
                self?.commentTableView.reloadData()
            }),
			commentModel.onWillErrorComments.subscribe(onNext: { [weak self] _ in
				self?.isMoreComment = false
			}),
            sendMessageView.successSendComments.subscribe(onNext: { [weak self] comment in
                self?.reloadComments(comment: comment)
            }),
			sendMessageView.onDidErrorSendComments.subscribe(onNext: { [weak self] in
				self?.showMessage(message: R.string.localizable.errorSendComment())
			})
        ])
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let `self` = self else { return }
                self.messageViewBottomConstraint.constant = keyboardVisibleHeight
                self.view.setNeedsLayout()
                UIView.animate(withDuration: 0) { self.view.layoutIfNeeded() }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupData() {
        self.commentModel.setContentId(contentId)
        self.sendMessageView.bindData(authorId: pageId, contentId: contentId, contentType: contentType)
    }
    
    private func reloadComments(comment: Comment) {
        self.commentModel.addComment(comment: comment)
        let indexPath = IndexPath(item: 0, section: CommentSection.comments.rawValue)
        self.commentTableView.insertRows(at: [indexPath], with: .fade)
        self.commentTableView.reloadSections(IndexSet(integer: CommentSection.comments.rawValue), with: .fade)
        self.commentTableView.reloadSections(IndexSet(integer: CommentSection.headerComment.rawValue), with: .fade)
        self.commentTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func bindData(pageId: String?, contentId: String?, contentType: String) {
        self.pageId = pageId
        self.contentId = contentId
        self.contentType = contentType
    }
    
    @IBAction func goBackTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension CommentViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == CommentSection.headerComment.rawValue {
            return 1
        }
        if section == CommentSection.comments.rawValue {
			let amountOfCell = commentModel.comments.count
			return isMoreComment ? amountOfCell + 1 : amountOfCell
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == CommentSection.headerComment.rawValue {
            return headerCommentCell(comments: commentModel.comments)
        }
        if indexPath.section == CommentSection.comments.rawValue {
			if let cell = createLoadMoreCell(indexPath) { return cell }
            return commentCell(comment: commentModel.comments[indexPath.row])
        }
        return createDummyCellWith(title: "Cell for comment type: invalid")
    }
    
    private func headerCommentCell(comments: [Comment]?) -> UITableViewCell {
        if let cell = commentTableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.headerCommentViewCellId.identifier) as? HeaderCommentViewCell {
            cell.bindData(comments: comments)
            return cell
        }
        return createDummyCellWith(title: "Cell for header comment")
    }
    
    private func commentCell(comment: Comment) -> UITableViewCell {
        if let cell = commentTableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.commentViewCellId.identifier) as? CommentViewCell {
            cell.bindData(comment: comment)
            cell.disposeBag.addDisposables([
                cell.expandedText.subscribe(onNext: { [unowned self] _ in
                    self.reloadCell()
                }),
                cell.authorAvatarTapped.subscribe(onNext: { _ in
                    
                }),
                cell.authorNameTapped.subscribe(onNext: { _ in
                    
                }),
                cell.successRemoveComment.subscribe(onNext: { [unowned self] comment in
                    self.remove(comment: comment)
                })
            ])
            return cell
        }
        return createDummyCellWith(title: "Cell for comments")
    }
    
    private func remove(comment: Comment) {
        if let index = commentModel.index(comment: comment) {
            let indexPath = IndexPath(row: index, section: CommentSection.comments.rawValue)
            commentModel.removeComment(at: index)
            commentTableView.beginUpdates()
            commentTableView.deleteRows(at: [indexPath], with: .fade)
            commentTableView.endUpdates()
            commentTableView.reloadSections(IndexSet(integer: CommentSection.headerComment.rawValue), with: .fade)
        }
    }
    
    private func reloadCell() {
        commentTableView.beginUpdates()
        commentTableView.endUpdates()
    }
	
	private func createLoadMoreCell(_ indexPath: IndexPath) -> UITableViewCell? {
		if commentModel.comments.isEmpty || indexPath.row < commentModel.comments.count || !isMoreComment { return nil }
		commentModel.requestMoreComment()
		return Common.createLoadMoreCell()
	}
}

// MARK: - UITableViewDelegate
extension CommentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == CommentSection.headerComment.rawValue {
            return Constants.DefaultValue.headerCommentHeight }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == CommentSection.headerComment.rawValue {
            return Constants.DefaultValue.headerCommentHeight }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension CommentViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == tapTableViewGesture {
            let location = gestureRecognizer.location(in: self.commentTableView)
            let path = self.commentTableView.indexPathForRow(at: location)
            return (path == nil)
        }
        return true
    }
}
