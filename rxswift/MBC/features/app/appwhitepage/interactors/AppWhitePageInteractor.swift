//
//  AppWhitePageInteractor.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 2/6/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

protocol AppWhitePageInteractor {
    func getContentPage(pageId: String) -> Observable<Feed?>
    func getContentPage(pageUrl: String) -> Observable<(Feed?, PageDetail?, String?)>
	func getCommentsFrom(data: CommentSocial) -> Observable<[Comment]>
	func getCurrentUser() -> UserProfile?
}
