//
//  EpisodeApi.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/20/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

protocol EpisodeApi {
    func getListEpisode(pageId: String, page: Int, pageSize: Int) -> Observable<[FeedEntity]>
}
