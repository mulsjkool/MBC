//
//  ContentPageInteractor.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 2/3/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

protocol ContentPageInteractor {
    func getContentPage(pageUrl: String, contentPageType: ContentPageType) -> Observable<(Feed?, PageDetail?, String?)>
    func getContentPage(pageId: String) -> Observable<Feed?>
    func getTaggedPagesFor(media: Media) -> Observable<Media>
    func getCommentsFrom(data: CommentSocial) -> Observable<[Comment]>
    func getCurrentUser() -> UserProfile?
    func getRelatedContent(pageUrl: String, pageId: String, type: String?, subtype: String?) -> Observable<[Feed]?>
}
