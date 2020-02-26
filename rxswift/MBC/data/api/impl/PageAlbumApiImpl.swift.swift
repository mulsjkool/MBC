//
//  PageAlbumApiImpl.swift.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/11/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

enum Direction: String {
	case next
	case prev
}

class PageAlbumApiImpl: BaseApiClient<AlbumEntity>, PageAlbumApi {
    let transformer: (JSON) -> AlbumEntity
    let listTransformer: (JSON) -> [AlbumEntity]
    
    init(apiClient: ApiClient, transformer: @escaping (JSON) -> AlbumEntity) {
        self.transformer = transformer
        self.listTransformer = { json in
            var items = [AlbumEntity]()
            if let itemJsons = json.array {
                for json in itemJsons {
                    items.append(transformer(json))
                }
            }
            
            return items
        }
        super.init(apiClient: apiClient, jsonTransformer: transformer)
    }
    
    func loadAlbumOf(pageId: String, albumId: String?,
                     fromIndex: Int, numberOfItems: Int) -> Observable<AlbumEntity> {
        if let albumId = albumId {
            return loadTitledAlbumOf(pageId: pageId, albumId: albumId)
        }
        
        return loadDefaultAlbumOf(pageId: pageId, fromIndex: fromIndex, numberOfItems: numberOfItems)
    }
    
    private static let getTitledPageAlbumsPath = "/content-presentations/pages/%@/albums"
    
    func loadAlbums(pageId: String) -> Observable<[AlbumEntity]> {
        return apiClient.get(String(format: PageAlbumApiImpl.getTitledPageAlbumsPath, pageId),
                             parameters: nil,
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: listTransformer)
    }
    
    // MARK: Private functions
    
    private static let getPageAlbumPath = "/content-presentations/pages/%@/%@?page=%d&size=%d"
    
    private func loadAlbumBy(pageId: String, albumName: String,
                             fromIndex: Int, numberOfItems: Int) -> Observable<AlbumEntity> {
        return apiClient.get(String(format: PageAlbumApiImpl.getPageAlbumPath, pageId,
                                    albumName, fromIndex, numberOfItems),
                             parameters: nil,
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: transformer)
    }
    
    private func loadDefaultAlbumOf(pageId: String, fromIndex: Int, numberOfItems: Int) -> Observable<AlbumEntity> {
        return loadAlbumBy(pageId: pageId, albumName: Constants.DefaultValue.DefaultAlbumName,
                           fromIndex: fromIndex, numberOfItems: numberOfItems)
    }
    
    //note: /post/ or /article/ will return the same data if the album id is valid
    private static let getPageTitledAlbumPath = "/content-presentations/pages/%@/post/%@/albums"
    
    private func loadTitledAlbumOf(pageId: String, albumId: String) -> Observable<AlbumEntity> {
        return apiClient.get(String(format: PageAlbumApiImpl.getPageTitledAlbumPath, pageId, albumId),
                             parameters: nil,
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: transformer)
    }
	
	private static let getNextAlbum = "/content-presentations/pages/%@/%@/next-albums?publishedDate=%@&direction=%@"
	
	func loadNextAlbum(pageId: String, currentAlbumContentId: String,
					   publishDate: String, isNextAlbum: Bool) -> Observable<AlbumEntity> {
		let direction = isNextAlbum ? Direction.prev.rawValue : Direction.next.rawValue
		return apiClient.get(String(format: PageAlbumApiImpl.getNextAlbum, pageId, currentAlbumContentId, publishDate,
									direction),
							 parameters: nil,
							 errorHandler: { _, error -> Error in
								return error
		}, parse: transformer)
	}
	
	private static let getDescriptionOfPost = "/content-presentations/pages/%@/post/%@/albums?page=%i&size=%i&damId=%@"
	
	func loadDescriptionOfPost(pageId: String, postId: String,
							   page: Int, pageSize: Int, damId: String) -> Observable<AlbumEntity> {
		return apiClient.get(String(format: PageAlbumApiImpl.getDescriptionOfPost, pageId,
									postId, page, pageSize, damId), parameters: nil,
		errorHandler: { _, error -> Error in
			return error
		}, parse: transformer)
	}
	
}
