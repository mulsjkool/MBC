//
//  VideoPlaylistInteractor.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/30/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol VideoPlaylistInteractor {
    var onFinishLoadItems: Observable<Void> { get }
    var onErrorLoadItems: Observable<Error> { get }
    
    func getTaggedPagesFor(media: Media) -> Observable<Media>
    func setIndex(index: Int)
    func getIndex() -> Int
    func getDetailOfPlayListFrom(pageId: String?, contentId: String?, playlistId: String?) -> Observable<ItemList>
}
