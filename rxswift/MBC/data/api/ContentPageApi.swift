//
//  ContentPageApi.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/30/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

protocol ContentPageApi {
    func getContentPage(pageUrl: String) -> Observable<ContentPageEntity>
    func getContentPageById(pageId: String) -> Observable<FeedEntity>
    func getPageDetailById(pageId: String) -> Observable<ContentPageEntity>
}
