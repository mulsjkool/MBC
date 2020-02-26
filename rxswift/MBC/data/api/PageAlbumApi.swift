//
//  PageAlbumApi.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/11/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol PageAlbumApi {
    func loadAlbumOf(pageId: String, albumId: String?,
                           fromIndex: Int, numberOfItems: Int) -> Observable<AlbumEntity>
    func loadAlbums(pageId: String) -> Observable<[AlbumEntity]>
	func loadNextAlbum(pageId: String, currentAlbumContentId: String,
					   publishDate: String, isNextAlbum: Bool) -> Observable<AlbumEntity>
	func loadDescriptionOfPost(pageId: String, postId: String,
							   page: Int, pageSize: Int, damId: String) -> Observable<AlbumEntity>
}
