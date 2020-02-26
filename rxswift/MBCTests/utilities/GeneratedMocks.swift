// MARK: - Mocks generated from file: MBC/models/utility/PageMenuEnum.swift at 2018-03-17 12:42:56 +0000

//
//  PageMenuEnum.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/5/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Cuckoo
@testable import MBC

import Foundation
import UIKit


// MARK: - Mocks generated from file: MBC/features/pagedetail/interactors/PageDetailInteractor.swift at 2018-03-17 12:42:56 +0000

//
//  PageDetailInteractor.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 11/30/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Cuckoo
@testable import MBC

import RxSwift
import UIKit

class MockPageDetailInteractor: PageDetailInteractor, Cuckoo.Mock {
    typealias MocksType = PageDetailInteractor
    typealias Stubbing = __StubbingProxy_PageDetailInteractor
    typealias Verification = __VerificationProxy_PageDetailInteractor
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: PageDetailInteractor?

    func spy(on victim: PageDetailInteractor) -> Self {
        observed = victim
        return self
    }

    
    // ["name": "onFinishLoadItems", "accesibility": "", "@type": "InstanceVariable", "type": "Observable<Void>", "isReadOnly": true]
     var onFinishLoadItems: Observable<Void> {
        get {
            return cuckoo_manager.getter("onFinishLoadItems", original: observed.map { o in return { () -> Observable<Void> in o.onFinishLoadItems }})
        }
        
    }
    
    // ["name": "onErrorLoadItems", "accesibility": "", "@type": "InstanceVariable", "type": "Observable<Error>", "isReadOnly": true]
     var onErrorLoadItems: Observable<Error> {
        get {
            return cuckoo_manager.getter("onErrorLoadItems", original: observed.map { o in return { () -> Observable<Error> in o.onErrorLoadItems }})
        }
        
    }
    
    // ["name": "onErrorLoadAlbums", "accesibility": "", "@type": "InstanceVariable", "type": "Observable<Error>", "isReadOnly": true]
     var onErrorLoadAlbums: Observable<Error> {
        get {
            return cuckoo_manager.getter("onErrorLoadAlbums", original: observed.map { o in return { () -> Observable<Error> in o.onErrorLoadAlbums }})
        }
        
    }
    
    // ["name": "onErrorLoadCustomVideoPlaylist", "accesibility": "", "@type": "InstanceVariable", "type": "Observable<Error>", "isReadOnly": true]
     var onErrorLoadCustomVideoPlaylist: Observable<Error> {
        get {
            return cuckoo_manager.getter("onErrorLoadCustomVideoPlaylist", original: observed.map { o in return { () -> Observable<Error> in o.onErrorLoadCustomVideoPlaylist }})
        }
        
    }
    
    // ["name": "onErrorGetPageDetail", "accesibility": "", "@type": "InstanceVariable", "type": "Observable<Error>", "isReadOnly": true]
     var onErrorGetPageDetail: Observable<Error> {
        get {
            return cuckoo_manager.getter("onErrorGetPageDetail", original: observed.map { o in return { () -> Observable<Error> in o.onErrorGetPageDetail }})
        }
        
    }
    
    // ["name": "onGetRedirectUrl", "accesibility": "", "@type": "InstanceVariable", "type": "Observable<String>", "isReadOnly": true]
     var onGetRedirectUrl: Observable<String> {
        get {
            return cuckoo_manager.getter("onGetRedirectUrl", original: observed.map { o in return { () -> Observable<String> in o.onGetRedirectUrl }})
        }
        
    }
    
    // ["name": "selectedAlbumId", "accesibility": "", "@type": "InstanceVariable", "type": "String?", "isReadOnly": false]
     var selectedAlbumId: String? {
        get {
            return cuckoo_manager.getter("selectedAlbumId", original: observed.map { o in return { () -> String? in o.selectedAlbumId }})
        }
        
        set {
            cuckoo_manager.setter("selectedAlbumId", value: newValue, original: observed != nil ? { self.observed?.selectedAlbumId = $0 } : nil)
        }
        
    }
    

    

    
    // ["name": "getPageDetailUrl", "returnSignature": " -> Observable<PageDetail>", "fullyQualifiedName": "getPageDetailUrl(pageUrl: String) -> Observable<PageDetail>", "parameterSignature": "pageUrl: String", "parameterSignatureWithoutNames": "pageUrl: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageUrl", "call": "pageUrl: pageUrl", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageUrl"), name: "pageUrl", type: "String", range: CountableRange(230..<245), nameRange: CountableRange(230..<237))], "returnType": "Observable<PageDetail>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func getPageDetailUrl(pageUrl: String)  -> Observable<PageDetail> {
        
            return cuckoo_manager.call("getPageDetailUrl(pageUrl: String) -> Observable<PageDetail>",
                parameters: (pageUrl),
                original: observed.map { o in
                    return { (args) -> Observable<PageDetail> in
                        let (pageUrl) = args
                        return o.getPageDetailUrl(pageUrl: pageUrl)
                    }
                })
        
    }
    
    // ["name": "getPageDetailBy", "returnSignature": " -> Observable<PageDetail>", "fullyQualifiedName": "getPageDetailBy(pageId: String) -> Observable<PageDetail>", "parameterSignature": "pageId: String", "parameterSignatureWithoutNames": "pageId: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageId", "call": "pageId: pageId", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageId"), name: "pageId", type: "String", range: CountableRange(298..<312), nameRange: CountableRange(298..<304))], "returnType": "Observable<PageDetail>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func getPageDetailBy(pageId: String)  -> Observable<PageDetail> {
        
            return cuckoo_manager.call("getPageDetailBy(pageId: String) -> Observable<PageDetail>",
                parameters: (pageId),
                original: observed.map { o in
                    return { (args) -> Observable<PageDetail> in
                        let (pageId) = args
                        return o.getPageDetailBy(pageId: pageId)
                    }
                })
        
    }
    
    // ["name": "shouldStartLoadItems", "returnSignature": "", "fullyQualifiedName": "shouldStartLoadItems()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func shouldStartLoadItems()  {
        
            return cuckoo_manager.call("shouldStartLoadItems()",
                parameters: (),
                original: observed.map { o in
                    return { (args) in
                        let () = args
                         o.shouldStartLoadItems()
                    }
                })
        
    }
    
    // ["name": "getPageIndex", "returnSignature": " -> Int", "fullyQualifiedName": "getPageIndex() -> Int", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Int", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func getPageIndex()  -> Int {
        
            return cuckoo_manager.call("getPageIndex() -> Int",
                parameters: (),
                original: observed.map { o in
                    return { (args) -> Int in
                        let () = args
                        return o.getPageIndex()
                    }
                })
        
    }
    
    // ["name": "getNextItems", "returnSignature": " -> Observable<ItemList>", "fullyQualifiedName": "getNextItems(pageId: String, ofPageMenu: PageMenuEnum, shouldUseCache: Bool) -> Observable<ItemList>", "parameterSignature": "pageId: String, ofPageMenu: PageMenuEnum, shouldUseCache: Bool", "parameterSignatureWithoutNames": "pageId: String, ofPageMenu: PageMenuEnum, shouldUseCache: Bool", "inputTypes": "String, PageMenuEnum, Bool", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageId, ofPageMenu, shouldUseCache", "call": "pageId: pageId, ofPageMenu: ofPageMenu, shouldUseCache: shouldUseCache", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageId"), name: "pageId", type: "String", range: CountableRange(817..<831), nameRange: CountableRange(817..<823)), CuckooGeneratorFramework.MethodParameter(label: Optional("ofPageMenu"), name: "ofPageMenu", type: "PageMenuEnum", range: CountableRange(833..<857), nameRange: CountableRange(833..<843)), CuckooGeneratorFramework.MethodParameter(label: Optional("shouldUseCache"), name: "shouldUseCache", type: "Bool", range: CountableRange(859..<879), nameRange: CountableRange(859..<873))], "returnType": "Observable<ItemList>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func getNextItems(pageId: String, ofPageMenu: PageMenuEnum, shouldUseCache: Bool)  -> Observable<ItemList> {
        
            return cuckoo_manager.call("getNextItems(pageId: String, ofPageMenu: PageMenuEnum, shouldUseCache: Bool) -> Observable<ItemList>",
                parameters: (pageId, ofPageMenu, shouldUseCache),
                original: observed.map { o in
                    return { (args) -> Observable<ItemList> in
                        let (pageId, ofPageMenu, shouldUseCache) = args
                        return o.getNextItems(pageId: pageId, ofPageMenu: ofPageMenu, shouldUseCache: shouldUseCache)
                    }
                })
        
    }
    
    // ["name": "loadAlbums", "returnSignature": " -> Observable<ItemList>", "fullyQualifiedName": "loadAlbums(pageId: String) -> Observable<ItemList>", "parameterSignature": "pageId: String", "parameterSignatureWithoutNames": "pageId: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageId", "call": "pageId: pageId", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageId"), name: "pageId", type: "String", range: CountableRange(925..<939), nameRange: CountableRange(925..<931))], "returnType": "Observable<ItemList>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func loadAlbums(pageId: String)  -> Observable<ItemList> {
        
            return cuckoo_manager.call("loadAlbums(pageId: String) -> Observable<ItemList>",
                parameters: (pageId),
                original: observed.map { o in
                    return { (args) -> Observable<ItemList> in
                        let (pageId) = args
                        return o.loadAlbums(pageId: pageId)
                    }
                })
        
    }
    
    // ["name": "loadNextAlbum", "returnSignature": " -> Observable<Album>", "fullyQualifiedName": "loadNextAlbum(pageId: String, currentAlbumContentId: String, publishDate: String, isNextAlbum: Bool) -> Observable<Album>", "parameterSignature": "pageId: String, currentAlbumContentId: String, publishDate: String, isNextAlbum: Bool", "parameterSignatureWithoutNames": "pageId: String, currentAlbumContentId: String, publishDate: String, isNextAlbum: Bool", "inputTypes": "String, String, String, Bool", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageId, currentAlbumContentId, publishDate, isNextAlbum", "call": "pageId: pageId, currentAlbumContentId: currentAlbumContentId, publishDate: publishDate, isNextAlbum: isNextAlbum", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageId"), name: "pageId", type: "String", range: CountableRange(985..<999), nameRange: CountableRange(985..<991)), CuckooGeneratorFramework.MethodParameter(label: Optional("currentAlbumContentId"), name: "currentAlbumContentId", type: "String", range: CountableRange(1001..<1030), nameRange: CountableRange(1001..<1022)), CuckooGeneratorFramework.MethodParameter(label: Optional("publishDate"), name: "publishDate", type: "String", range: CountableRange(1040..<1059), nameRange: CountableRange(1040..<1051)), CuckooGeneratorFramework.MethodParameter(label: Optional("isNextAlbum"), name: "isNextAlbum", type: "Bool", range: CountableRange(1061..<1078), nameRange: CountableRange(1061..<1072))], "returnType": "Observable<Album>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func loadNextAlbum(pageId: String, currentAlbumContentId: String, publishDate: String, isNextAlbum: Bool)  -> Observable<Album> {
        
            return cuckoo_manager.call("loadNextAlbum(pageId: String, currentAlbumContentId: String, publishDate: String, isNextAlbum: Bool) -> Observable<Album>",
                parameters: (pageId, currentAlbumContentId, publishDate, isNextAlbum),
                original: observed.map { o in
                    return { (args) -> Observable<Album> in
                        let (pageId, currentAlbumContentId, publishDate, isNextAlbum) = args
                        return o.loadNextAlbum(pageId: pageId, currentAlbumContentId: currentAlbumContentId, publishDate: publishDate, isNextAlbum: isNextAlbum)
                    }
                })
        
    }
    
    // ["name": "loadDescriptionOfPost", "returnSignature": " -> Observable<Album>", "fullyQualifiedName": "loadDescriptionOfPost(pageId: String, postId: String, page: Int, pageSize: Int, damId: String) -> Observable<Album>", "parameterSignature": "pageId: String, postId: String, page: Int, pageSize: Int, damId: String", "parameterSignatureWithoutNames": "pageId: String, postId: String, page: Int, pageSize: Int, damId: String", "inputTypes": "String, String, Int, Int, String", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageId, postId, page, pageSize, damId", "call": "pageId: pageId, postId: postId, page: page, pageSize: pageSize, damId: damId", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageId"), name: "pageId", type: "String", range: CountableRange(1129..<1143), nameRange: CountableRange(1129..<1135)), CuckooGeneratorFramework.MethodParameter(label: Optional("postId"), name: "postId", type: "String", range: CountableRange(1145..<1159), nameRange: CountableRange(1145..<1151)), CuckooGeneratorFramework.MethodParameter(label: Optional("page"), name: "page", type: "Int", range: CountableRange(1171..<1180), nameRange: CountableRange(1171..<1175)), CuckooGeneratorFramework.MethodParameter(label: Optional("pageSize"), name: "pageSize", type: "Int", range: CountableRange(1182..<1195), nameRange: CountableRange(1182..<1190)), CuckooGeneratorFramework.MethodParameter(label: Optional("damId"), name: "damId", type: "String", range: CountableRange(1197..<1210), nameRange: CountableRange(1197..<1202))], "returnType": "Observable<Album>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func loadDescriptionOfPost(pageId: String, postId: String, page: Int, pageSize: Int, damId: String)  -> Observable<Album> {
        
            return cuckoo_manager.call("loadDescriptionOfPost(pageId: String, postId: String, page: Int, pageSize: Int, damId: String) -> Observable<Album>",
                parameters: (pageId, postId, page, pageSize, damId),
                original: observed.map { o in
                    return { (args) -> Observable<Album> in
                        let (pageId, postId, page, pageSize, damId) = args
                        return o.loadDescriptionOfPost(pageId: pageId, postId: postId, page: page, pageSize: pageSize, damId: damId)
                    }
                })
        
    }
    
    // ["name": "getTaggedPagesFor", "returnSignature": " -> Observable<Media>", "fullyQualifiedName": "getTaggedPagesFor(media: Media) -> Observable<Media>", "parameterSignature": "media: Media", "parameterSignatureWithoutNames": "media: Media", "inputTypes": "Media", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "media", "call": "media: media", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("media"), name: "media", type: "Media", range: CountableRange(1260..<1272), nameRange: CountableRange(1260..<1265))], "returnType": "Observable<Media>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func getTaggedPagesFor(media: Media)  -> Observable<Media> {
        
            return cuckoo_manager.call("getTaggedPagesFor(media: Media) -> Observable<Media>",
                parameters: (media),
                original: observed.map { o in
                    return { (args) -> Observable<Media> in
                        let (media) = args
                        return o.getTaggedPagesFor(media: media)
                    }
                })
        
    }
    
    // ["name": "getNextDefaultPlaylistFrom", "returnSignature": " -> Observable<ItemList>", "fullyQualifiedName": "getNextDefaultPlaylistFrom(pageId: String) -> Observable<ItemList>", "parameterSignature": "pageId: String", "parameterSignatureWithoutNames": "pageId: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageId", "call": "pageId: pageId", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageId"), name: "pageId", type: "String", range: CountableRange(1331..<1345), nameRange: CountableRange(1331..<1337))], "returnType": "Observable<ItemList>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func getNextDefaultPlaylistFrom(pageId: String)  -> Observable<ItemList> {
        
            return cuckoo_manager.call("getNextDefaultPlaylistFrom(pageId: String) -> Observable<ItemList>",
                parameters: (pageId),
                original: observed.map { o in
                    return { (args) -> Observable<ItemList> in
                        let (pageId) = args
                        return o.getNextDefaultPlaylistFrom(pageId: pageId)
                    }
                })
        
    }
    
    // ["name": "getCustomPlaylisFrom", "returnSignature": " -> Observable<ItemList>", "fullyQualifiedName": "getCustomPlaylisFrom(pageId: String) -> Observable<ItemList>", "parameterSignature": "pageId: String", "parameterSignatureWithoutNames": "pageId: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageId", "call": "pageId: pageId", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageId"), name: "pageId", type: "String", range: CountableRange(1400..<1414), nameRange: CountableRange(1400..<1406))], "returnType": "Observable<ItemList>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func getCustomPlaylisFrom(pageId: String)  -> Observable<ItemList> {
        
            return cuckoo_manager.call("getCustomPlaylisFrom(pageId: String) -> Observable<ItemList>",
                parameters: (pageId),
                original: observed.map { o in
                    return { (args) -> Observable<ItemList> in
                        let (pageId) = args
                        return o.getCustomPlaylisFrom(pageId: pageId)
                    }
                })
        
    }
    
    // ["name": "clearCache", "returnSignature": "", "fullyQualifiedName": "clearCache(pageId: String)", "parameterSignature": "pageId: String", "parameterSignatureWithoutNames": "pageId: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageId", "call": "pageId: pageId", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageId"), name: "pageId", type: "String", range: CountableRange(1461..<1475), nameRange: CountableRange(1461..<1467))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func clearCache(pageId: String)  {
        
            return cuckoo_manager.call("clearCache(pageId: String)",
                parameters: (pageId),
                original: observed.map { o in
                    return { (args) in
                        let (pageId) = args
                         o.clearCache(pageId: pageId)
                    }
                })
        
    }
    
    // ["name": "setPageSize", "returnSignature": "", "fullyQualifiedName": "setPageSize(pageSize: Int)", "parameterSignature": "pageSize: Int", "parameterSignatureWithoutNames": "pageSize: Int", "inputTypes": "Int", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageSize", "call": "pageSize: pageSize", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageSize"), name: "pageSize", type: "Int", range: CountableRange(1495..<1508), nameRange: CountableRange(1495..<1503))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func setPageSize(pageSize: Int)  {
        
            return cuckoo_manager.call("setPageSize(pageSize: Int)",
                parameters: (pageSize),
                original: observed.map { o in
                    return { (args) in
                        let (pageSize) = args
                         o.setPageSize(pageSize: pageSize)
                    }
                })
        
    }
    
    // ["name": "resetPageSize", "returnSignature": "", "fullyQualifiedName": "resetPageSize()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func resetPageSize()  {
        
            return cuckoo_manager.call("resetPageSize()",
                parameters: (),
                original: observed.map { o in
                    return { (args) in
                        let () = args
                         o.resetPageSize()
                    }
                })
        
    }
    
    // ["name": "getInfoComponent", "returnSignature": " -> Observable<[InfoComponent]>", "fullyQualifiedName": "getInfoComponent(pageId: String) -> Observable<[InfoComponent]>", "parameterSignature": "pageId: String", "parameterSignatureWithoutNames": "pageId: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageId", "call": "pageId: pageId", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageId"), name: "pageId", type: "String", range: CountableRange(1558..<1572), nameRange: CountableRange(1558..<1564))], "returnType": "Observable<[InfoComponent]>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func getInfoComponent(pageId: String)  -> Observable<[InfoComponent]> {
        
            return cuckoo_manager.call("getInfoComponent(pageId: String) -> Observable<[InfoComponent]>",
                parameters: (pageId),
                original: observed.map { o in
                    return { (args) -> Observable<[InfoComponent]> in
                        let (pageId) = args
                        return o.getInfoComponent(pageId: pageId)
                    }
                })
        
    }
    

    struct __StubbingProxy_PageDetailInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var onFinishLoadItems: Cuckoo.ToBeStubbedReadOnlyProperty<Observable<Void>> {
            return .init(manager: cuckoo_manager, name: "onFinishLoadItems")
        }
        
        var onErrorLoadItems: Cuckoo.ToBeStubbedReadOnlyProperty<Observable<Error>> {
            return .init(manager: cuckoo_manager, name: "onErrorLoadItems")
        }
        
        var onErrorLoadAlbums: Cuckoo.ToBeStubbedReadOnlyProperty<Observable<Error>> {
            return .init(manager: cuckoo_manager, name: "onErrorLoadAlbums")
        }
        
        var onErrorLoadCustomVideoPlaylist: Cuckoo.ToBeStubbedReadOnlyProperty<Observable<Error>> {
            return .init(manager: cuckoo_manager, name: "onErrorLoadCustomVideoPlaylist")
        }
        
        var onErrorGetPageDetail: Cuckoo.ToBeStubbedReadOnlyProperty<Observable<Error>> {
            return .init(manager: cuckoo_manager, name: "onErrorGetPageDetail")
        }
        
        var onGetRedirectUrl: Cuckoo.ToBeStubbedReadOnlyProperty<Observable<String>> {
            return .init(manager: cuckoo_manager, name: "onGetRedirectUrl")
        }
        
        var selectedAlbumId: Cuckoo.ToBeStubbedProperty<String?> {
            return .init(manager: cuckoo_manager, name: "selectedAlbumId")
        }
        
        
        func getPageDetailUrl<M1: Cuckoo.Matchable>(pageUrl: M1) -> Cuckoo.StubFunction<(String), Observable<PageDetail>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageUrl) { $0 }]
            return .init(stub: cuckoo_manager.createStub("getPageDetailUrl(pageUrl: String) -> Observable<PageDetail>", parameterMatchers: matchers))
        }
        
        func getPageDetailBy<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.StubFunction<(String), Observable<PageDetail>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return .init(stub: cuckoo_manager.createStub("getPageDetailBy(pageId: String) -> Observable<PageDetail>", parameterMatchers: matchers))
        }
        
        func shouldStartLoadItems() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("shouldStartLoadItems()", parameterMatchers: matchers))
        }
        
        func getPageIndex() -> Cuckoo.StubFunction<(), Int> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("getPageIndex() -> Int", parameterMatchers: matchers))
        }
        
        func getNextItems<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(pageId: M1, ofPageMenu: M2, shouldUseCache: M3) -> Cuckoo.StubFunction<(String, PageMenuEnum, Bool), Observable<ItemList>> where M1.MatchedType == String, M2.MatchedType == PageMenuEnum, M3.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(String, PageMenuEnum, Bool)>] = [wrap(matchable: pageId) { $0.0 }, wrap(matchable: ofPageMenu) { $0.1 }, wrap(matchable: shouldUseCache) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub("getNextItems(pageId: String, ofPageMenu: PageMenuEnum, shouldUseCache: Bool) -> Observable<ItemList>", parameterMatchers: matchers))
        }
        
        func loadAlbums<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.StubFunction<(String), Observable<ItemList>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return .init(stub: cuckoo_manager.createStub("loadAlbums(pageId: String) -> Observable<ItemList>", parameterMatchers: matchers))
        }
        
        func loadNextAlbum<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(pageId: M1, currentAlbumContentId: M2, publishDate: M3, isNextAlbum: M4) -> Cuckoo.StubFunction<(String, String, String, Bool), Observable<Album>> where M1.MatchedType == String, M2.MatchedType == String, M3.MatchedType == String, M4.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(String, String, String, Bool)>] = [wrap(matchable: pageId) { $0.0 }, wrap(matchable: currentAlbumContentId) { $0.1 }, wrap(matchable: publishDate) { $0.2 }, wrap(matchable: isNextAlbum) { $0.3 }]
            return .init(stub: cuckoo_manager.createStub("loadNextAlbum(pageId: String, currentAlbumContentId: String, publishDate: String, isNextAlbum: Bool) -> Observable<Album>", parameterMatchers: matchers))
        }
        
        func loadDescriptionOfPost<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable>(pageId: M1, postId: M2, page: M3, pageSize: M4, damId: M5) -> Cuckoo.StubFunction<(String, String, Int, Int, String), Observable<Album>> where M1.MatchedType == String, M2.MatchedType == String, M3.MatchedType == Int, M4.MatchedType == Int, M5.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String, Int, Int, String)>] = [wrap(matchable: pageId) { $0.0 }, wrap(matchable: postId) { $0.1 }, wrap(matchable: page) { $0.2 }, wrap(matchable: pageSize) { $0.3 }, wrap(matchable: damId) { $0.4 }]
            return .init(stub: cuckoo_manager.createStub("loadDescriptionOfPost(pageId: String, postId: String, page: Int, pageSize: Int, damId: String) -> Observable<Album>", parameterMatchers: matchers))
        }
        
        func getTaggedPagesFor<M1: Cuckoo.Matchable>(media: M1) -> Cuckoo.StubFunction<(Media), Observable<Media>> where M1.MatchedType == Media {
            let matchers: [Cuckoo.ParameterMatcher<(Media)>] = [wrap(matchable: media) { $0 }]
            return .init(stub: cuckoo_manager.createStub("getTaggedPagesFor(media: Media) -> Observable<Media>", parameterMatchers: matchers))
        }
        
        func getNextDefaultPlaylistFrom<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.StubFunction<(String), Observable<ItemList>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return .init(stub: cuckoo_manager.createStub("getNextDefaultPlaylistFrom(pageId: String) -> Observable<ItemList>", parameterMatchers: matchers))
        }
        
        func getCustomPlaylisFrom<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.StubFunction<(String), Observable<ItemList>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return .init(stub: cuckoo_manager.createStub("getCustomPlaylisFrom(pageId: String) -> Observable<ItemList>", parameterMatchers: matchers))
        }
        
        func clearCache<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.StubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return .init(stub: cuckoo_manager.createStub("clearCache(pageId: String)", parameterMatchers: matchers))
        }
        
        func setPageSize<M1: Cuckoo.Matchable>(pageSize: M1) -> Cuckoo.StubNoReturnFunction<(Int)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: pageSize) { $0 }]
            return .init(stub: cuckoo_manager.createStub("setPageSize(pageSize: Int)", parameterMatchers: matchers))
        }
        
        func resetPageSize() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("resetPageSize()", parameterMatchers: matchers))
        }
        
        func getInfoComponent<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.StubFunction<(String), Observable<[InfoComponent]>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return .init(stub: cuckoo_manager.createStub("getInfoComponent(pageId: String) -> Observable<[InfoComponent]>", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_PageDetailInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        
        var onFinishLoadItems: Cuckoo.VerifyReadOnlyProperty<Observable<Void>> {
            return .init(manager: cuckoo_manager, name: "onFinishLoadItems", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var onErrorLoadItems: Cuckoo.VerifyReadOnlyProperty<Observable<Error>> {
            return .init(manager: cuckoo_manager, name: "onErrorLoadItems", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var onErrorLoadAlbums: Cuckoo.VerifyReadOnlyProperty<Observable<Error>> {
            return .init(manager: cuckoo_manager, name: "onErrorLoadAlbums", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var onErrorLoadCustomVideoPlaylist: Cuckoo.VerifyReadOnlyProperty<Observable<Error>> {
            return .init(manager: cuckoo_manager, name: "onErrorLoadCustomVideoPlaylist", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var onErrorGetPageDetail: Cuckoo.VerifyReadOnlyProperty<Observable<Error>> {
            return .init(manager: cuckoo_manager, name: "onErrorGetPageDetail", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var onGetRedirectUrl: Cuckoo.VerifyReadOnlyProperty<Observable<String>> {
            return .init(manager: cuckoo_manager, name: "onGetRedirectUrl", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var selectedAlbumId: Cuckoo.VerifyProperty<String?> {
            return .init(manager: cuckoo_manager, name: "selectedAlbumId", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        

        
        @discardableResult
        func getPageDetailUrl<M1: Cuckoo.Matchable>(pageUrl: M1) -> Cuckoo.__DoNotUse<Observable<PageDetail>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageUrl) { $0 }]
            return cuckoo_manager.verify("getPageDetailUrl(pageUrl: String) -> Observable<PageDetail>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func getPageDetailBy<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.__DoNotUse<Observable<PageDetail>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return cuckoo_manager.verify("getPageDetailBy(pageId: String) -> Observable<PageDetail>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func shouldStartLoadItems() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("shouldStartLoadItems()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func getPageIndex() -> Cuckoo.__DoNotUse<Int> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("getPageIndex() -> Int", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func getNextItems<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(pageId: M1, ofPageMenu: M2, shouldUseCache: M3) -> Cuckoo.__DoNotUse<Observable<ItemList>> where M1.MatchedType == String, M2.MatchedType == PageMenuEnum, M3.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(String, PageMenuEnum, Bool)>] = [wrap(matchable: pageId) { $0.0 }, wrap(matchable: ofPageMenu) { $0.1 }, wrap(matchable: shouldUseCache) { $0.2 }]
            return cuckoo_manager.verify("getNextItems(pageId: String, ofPageMenu: PageMenuEnum, shouldUseCache: Bool) -> Observable<ItemList>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func loadAlbums<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.__DoNotUse<Observable<ItemList>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return cuckoo_manager.verify("loadAlbums(pageId: String) -> Observable<ItemList>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func loadNextAlbum<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(pageId: M1, currentAlbumContentId: M2, publishDate: M3, isNextAlbum: M4) -> Cuckoo.__DoNotUse<Observable<Album>> where M1.MatchedType == String, M2.MatchedType == String, M3.MatchedType == String, M4.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(String, String, String, Bool)>] = [wrap(matchable: pageId) { $0.0 }, wrap(matchable: currentAlbumContentId) { $0.1 }, wrap(matchable: publishDate) { $0.2 }, wrap(matchable: isNextAlbum) { $0.3 }]
            return cuckoo_manager.verify("loadNextAlbum(pageId: String, currentAlbumContentId: String, publishDate: String, isNextAlbum: Bool) -> Observable<Album>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func loadDescriptionOfPost<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable>(pageId: M1, postId: M2, page: M3, pageSize: M4, damId: M5) -> Cuckoo.__DoNotUse<Observable<Album>> where M1.MatchedType == String, M2.MatchedType == String, M3.MatchedType == Int, M4.MatchedType == Int, M5.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String, Int, Int, String)>] = [wrap(matchable: pageId) { $0.0 }, wrap(matchable: postId) { $0.1 }, wrap(matchable: page) { $0.2 }, wrap(matchable: pageSize) { $0.3 }, wrap(matchable: damId) { $0.4 }]
            return cuckoo_manager.verify("loadDescriptionOfPost(pageId: String, postId: String, page: Int, pageSize: Int, damId: String) -> Observable<Album>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func getTaggedPagesFor<M1: Cuckoo.Matchable>(media: M1) -> Cuckoo.__DoNotUse<Observable<Media>> where M1.MatchedType == Media {
            let matchers: [Cuckoo.ParameterMatcher<(Media)>] = [wrap(matchable: media) { $0 }]
            return cuckoo_manager.verify("getTaggedPagesFor(media: Media) -> Observable<Media>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func getNextDefaultPlaylistFrom<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.__DoNotUse<Observable<ItemList>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return cuckoo_manager.verify("getNextDefaultPlaylistFrom(pageId: String) -> Observable<ItemList>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func getCustomPlaylisFrom<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.__DoNotUse<Observable<ItemList>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return cuckoo_manager.verify("getCustomPlaylisFrom(pageId: String) -> Observable<ItemList>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func clearCache<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return cuckoo_manager.verify("clearCache(pageId: String)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func setPageSize<M1: Cuckoo.Matchable>(pageSize: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: pageSize) { $0 }]
            return cuckoo_manager.verify("setPageSize(pageSize: Int)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func resetPageSize() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("resetPageSize()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func getInfoComponent<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.__DoNotUse<Observable<[InfoComponent]>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return cuckoo_manager.verify("getInfoComponent(pageId: String) -> Observable<[InfoComponent]>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class PageDetailInteractorStub: PageDetailInteractor {
    
     var onFinishLoadItems: Observable<Void> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Observable<Void>).self)
        }
        
    }
    
     var onErrorLoadItems: Observable<Error> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Observable<Error>).self)
        }
        
    }
    
     var onErrorLoadAlbums: Observable<Error> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Observable<Error>).self)
        }
        
    }
    
     var onErrorLoadCustomVideoPlaylist: Observable<Error> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Observable<Error>).self)
        }
        
    }
    
     var onErrorGetPageDetail: Observable<Error> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Observable<Error>).self)
        }
        
    }
    
     var onGetRedirectUrl: Observable<String> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Observable<String>).self)
        }
        
    }
    
     var selectedAlbumId: String? {
        get {
            return DefaultValueRegistry.defaultValue(for: (String?).self)
        }
        
        set { }
        
    }
    

    

    
     func getPageDetailUrl(pageUrl: String)  -> Observable<PageDetail> {
        return DefaultValueRegistry.defaultValue(for: Observable<PageDetail>.self)
    }
    
     func getPageDetailBy(pageId: String)  -> Observable<PageDetail> {
        return DefaultValueRegistry.defaultValue(for: Observable<PageDetail>.self)
    }
    
     func shouldStartLoadItems()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func getPageIndex()  -> Int {
        return DefaultValueRegistry.defaultValue(for: Int.self)
    }
    
     func getNextItems(pageId: String, ofPageMenu: PageMenuEnum, shouldUseCache: Bool)  -> Observable<ItemList> {
        return DefaultValueRegistry.defaultValue(for: Observable<ItemList>.self)
    }
    
     func loadAlbums(pageId: String)  -> Observable<ItemList> {
        return DefaultValueRegistry.defaultValue(for: Observable<ItemList>.self)
    }
    
     func loadNextAlbum(pageId: String, currentAlbumContentId: String, publishDate: String, isNextAlbum: Bool)  -> Observable<Album> {
        return DefaultValueRegistry.defaultValue(for: Observable<Album>.self)
    }
    
     func loadDescriptionOfPost(pageId: String, postId: String, page: Int, pageSize: Int, damId: String)  -> Observable<Album> {
        return DefaultValueRegistry.defaultValue(for: Observable<Album>.self)
    }
    
     func getTaggedPagesFor(media: Media)  -> Observable<Media> {
        return DefaultValueRegistry.defaultValue(for: Observable<Media>.self)
    }
    
     func getNextDefaultPlaylistFrom(pageId: String)  -> Observable<ItemList> {
        return DefaultValueRegistry.defaultValue(for: Observable<ItemList>.self)
    }
    
     func getCustomPlaylisFrom(pageId: String)  -> Observable<ItemList> {
        return DefaultValueRegistry.defaultValue(for: Observable<ItemList>.self)
    }
    
     func clearCache(pageId: String)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func setPageSize(pageSize: Int)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func resetPageSize()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func getInfoComponent(pageId: String)  -> Observable<[InfoComponent]> {
        return DefaultValueRegistry.defaultValue(for: Observable<[InfoComponent]>.self)
    }
    
}




// MARK: - Mocks generated from file: MBC/features/menu/interactors/MenuInteractor.swift at 2018-03-17 12:42:56 +0000

//
//  MenuInteractor.swift
//  F8
//
//  Created by Dao Le Quang on 11/9/16.
//  Copyright © 2016 Tuyen Nguyen Thanh. All rights reserved.
//

import Cuckoo
@testable import MBC

import Foundation
import RxSwift

class MockMenuInteractor: MenuInteractor, Cuckoo.Mock {
    typealias MocksType = MenuInteractor
    typealias Stubbing = __StubbingProxy_MenuInteractor
    typealias Verification = __VerificationProxy_MenuInteractor
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: MenuInteractor?

    func spy(on victim: MenuInteractor) -> Self {
        observed = victim
        return self
    }

    
    // ["name": "onDidSignoutError", "accesibility": "", "@type": "InstanceVariable", "type": "Observable<Error>", "isReadOnly": true]
     var onDidSignoutError: Observable<Error> {
        get {
            return cuckoo_manager.getter("onDidSignoutError", original: observed.map { o in return { () -> Observable<Error> in o.onDidSignoutError }})
        }
        
    }
    
    // ["name": "onDidSignoutSuccess", "accesibility": "", "@type": "InstanceVariable", "type": "Observable<Void>", "isReadOnly": true]
     var onDidSignoutSuccess: Observable<Void> {
        get {
            return cuckoo_manager.getter("onDidSignoutSuccess", original: observed.map { o in return { () -> Observable<Void> in o.onDidSignoutSuccess }})
        }
        
    }
    

    

    
    // ["name": "getFeaturePagesBy", "returnSignature": " -> Observable<[MenuPage]>", "fullyQualifiedName": "getFeaturePagesBy(siteName: String) -> Observable<[MenuPage]>", "parameterSignature": "siteName: String", "parameterSignatureWithoutNames": "siteName: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "siteName", "call": "siteName: siteName", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("siteName"), name: "siteName", type: "String", range: CountableRange(232..<248), nameRange: CountableRange(232..<240))], "returnType": "Observable<[MenuPage]>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func getFeaturePagesBy(siteName: String)  -> Observable<[MenuPage]> {
        
            return cuckoo_manager.call("getFeaturePagesBy(siteName: String) -> Observable<[MenuPage]>",
                parameters: (siteName),
                original: observed.map { o in
                    return { (args) -> Observable<[MenuPage]> in
                        let (siteName) = args
                        return o.getFeaturePagesBy(siteName: siteName)
                    }
                })
        
    }
    
    // ["name": "signout", "returnSignature": "", "fullyQualifiedName": "signout()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func signout()  {
        
            return cuckoo_manager.call("signout()",
                parameters: (),
                original: observed.map { o in
                    return { (args) in
                        let () = args
                         o.signout()
                    }
                })
        
    }
    

    struct __StubbingProxy_MenuInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var onDidSignoutError: Cuckoo.ToBeStubbedReadOnlyProperty<Observable<Error>> {
            return .init(manager: cuckoo_manager, name: "onDidSignoutError")
        }
        
        var onDidSignoutSuccess: Cuckoo.ToBeStubbedReadOnlyProperty<Observable<Void>> {
            return .init(manager: cuckoo_manager, name: "onDidSignoutSuccess")
        }
        
        
        func getFeaturePagesBy<M1: Cuckoo.Matchable>(siteName: M1) -> Cuckoo.StubFunction<(String), Observable<[MenuPage]>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: siteName) { $0 }]
            return .init(stub: cuckoo_manager.createStub("getFeaturePagesBy(siteName: String) -> Observable<[MenuPage]>", parameterMatchers: matchers))
        }
        
        func signout() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("signout()", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_MenuInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        
        var onDidSignoutError: Cuckoo.VerifyReadOnlyProperty<Observable<Error>> {
            return .init(manager: cuckoo_manager, name: "onDidSignoutError", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var onDidSignoutSuccess: Cuckoo.VerifyReadOnlyProperty<Observable<Void>> {
            return .init(manager: cuckoo_manager, name: "onDidSignoutSuccess", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        

        
        @discardableResult
        func getFeaturePagesBy<M1: Cuckoo.Matchable>(siteName: M1) -> Cuckoo.__DoNotUse<Observable<[MenuPage]>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: siteName) { $0 }]
            return cuckoo_manager.verify("getFeaturePagesBy(siteName: String) -> Observable<[MenuPage]>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func signout() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("signout()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class MenuInteractorStub: MenuInteractor {
    
     var onDidSignoutError: Observable<Error> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Observable<Error>).self)
        }
        
    }
    
     var onDidSignoutSuccess: Observable<Void> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Observable<Void>).self)
        }
        
    }
    

    

    
     func getFeaturePagesBy(siteName: String)  -> Observable<[MenuPage]> {
        return DefaultValueRegistry.defaultValue(for: Observable<[MenuPage]>.self)
    }
    
     func signout()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: MBC/features/homestream/interactors/HomeStreamInteractor.swift at 2018-03-17 12:42:56 +0000

//
//  HomeStreamInteractor.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/15/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Cuckoo
@testable import MBC

import Foundation
import RxSwift

class MockHomeStreamInteractor: HomeStreamInteractor, Cuckoo.Mock {
    typealias MocksType = HomeStreamInteractor
    typealias Stubbing = __StubbingProxy_HomeStreamInteractor
    typealias Verification = __VerificationProxy_HomeStreamInteractor
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: HomeStreamInteractor?

    func spy(on victim: HomeStreamInteractor) -> Self {
        observed = victim
        return self
    }

    
    // ["name": "onFinishLoadItems", "accesibility": "", "@type": "InstanceVariable", "type": "Observable<Void>", "isReadOnly": true]
     var onFinishLoadItems: Observable<Void> {
        get {
            return cuckoo_manager.getter("onFinishLoadItems", original: observed.map { o in return { () -> Observable<Void> in o.onFinishLoadItems }})
        }
        
    }
    
    // ["name": "onErrorLoadItems", "accesibility": "", "@type": "InstanceVariable", "type": "Observable<Error>", "isReadOnly": true]
     var onErrorLoadItems: Observable<Error> {
        get {
            return cuckoo_manager.getter("onErrorLoadItems", original: observed.map { o in return { () -> Observable<Error> in o.onErrorLoadItems }})
        }
        
    }
    

    

    
    // ["name": "shouldStartLoadItems", "returnSignature": "", "fullyQualifiedName": "shouldStartLoadItems()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func shouldStartLoadItems()  {
        
            return cuckoo_manager.call("shouldStartLoadItems()",
                parameters: (),
                original: observed.map { o in
                    return { (args) in
                        let () = args
                         o.shouldStartLoadItems()
                    }
                })
        
    }
    
    // ["name": "getNextItems", "returnSignature": " -> Observable<([Campaign], SearchStatistic?)>", "fullyQualifiedName": "getNextItems() -> Observable<([Campaign], SearchStatistic?)>", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Observable<([Campaign], SearchStatistic?)>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func getNextItems()  -> Observable<([Campaign], SearchStatistic?)> {
        
            return cuckoo_manager.call("getNextItems() -> Observable<([Campaign], SearchStatistic?)>",
                parameters: (),
                original: observed.map { o in
                    return { (args) -> Observable<([Campaign], SearchStatistic?)> in
                        let () = args
                        return o.getNextItems()
                    }
                })
        
    }
    
    // ["name": "clearCache", "returnSignature": "", "fullyQualifiedName": "clearCache()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func clearCache()  {
        
            return cuckoo_manager.call("clearCache()",
                parameters: (),
                original: observed.map { o in
                    return { (args) in
                        let () = args
                         o.clearCache()
                    }
                })
        
    }
    
    // ["name": "setForVideoStream", "returnSignature": "", "fullyQualifiedName": "setForVideoStream()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func setForVideoStream()  {
        
            return cuckoo_manager.call("setForVideoStream()",
                parameters: (),
                original: observed.map { o in
                    return { (args) in
                        let () = args
                         o.setForVideoStream()
                    }
                })
        
    }
    
    // ["name": "setForSearchResult", "returnSignature": "", "fullyQualifiedName": "setForSearchResult(keyword: String, searchType: SearchItemEnum, hasStatistic: Bool)", "parameterSignature": "keyword: String, searchType: SearchItemEnum, hasStatistic: Bool", "parameterSignatureWithoutNames": "keyword: String, searchType: SearchItemEnum, hasStatistic: Bool", "inputTypes": "String, SearchItemEnum, Bool", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "keyword, searchType, hasStatistic", "call": "keyword: keyword, searchType: searchType, hasStatistic: hasStatistic", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("keyword"), name: "keyword", type: "String", range: CountableRange(389..<404), nameRange: CountableRange(389..<396)), CuckooGeneratorFramework.MethodParameter(label: Optional("searchType"), name: "searchType", type: "SearchItemEnum", range: CountableRange(406..<432), nameRange: CountableRange(406..<416)), CuckooGeneratorFramework.MethodParameter(label: Optional("hasStatistic"), name: "hasStatistic", type: "Bool", range: CountableRange(434..<452), nameRange: CountableRange(434..<446))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func setForSearchResult(keyword: String, searchType: SearchItemEnum, hasStatistic: Bool)  {
        
            return cuckoo_manager.call("setForSearchResult(keyword: String, searchType: SearchItemEnum, hasStatistic: Bool)",
                parameters: (keyword, searchType, hasStatistic),
                original: observed.map { o in
                    return { (args) in
                        let (keyword, searchType, hasStatistic) = args
                         o.setForSearchResult(keyword: keyword, searchType: searchType, hasStatistic: hasStatistic)
                    }
                })
        
    }
    

    struct __StubbingProxy_HomeStreamInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var onFinishLoadItems: Cuckoo.ToBeStubbedReadOnlyProperty<Observable<Void>> {
            return .init(manager: cuckoo_manager, name: "onFinishLoadItems")
        }
        
        var onErrorLoadItems: Cuckoo.ToBeStubbedReadOnlyProperty<Observable<Error>> {
            return .init(manager: cuckoo_manager, name: "onErrorLoadItems")
        }
        
        
        func shouldStartLoadItems() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("shouldStartLoadItems()", parameterMatchers: matchers))
        }
        
        func getNextItems() -> Cuckoo.StubFunction<(), Observable<([Campaign], SearchStatistic?)>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("getNextItems() -> Observable<([Campaign], SearchStatistic?)>", parameterMatchers: matchers))
        }
        
        func clearCache() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("clearCache()", parameterMatchers: matchers))
        }
        
        func setForVideoStream() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("setForVideoStream()", parameterMatchers: matchers))
        }
        
        func setForSearchResult<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(keyword: M1, searchType: M2, hasStatistic: M3) -> Cuckoo.StubNoReturnFunction<(String, SearchItemEnum, Bool)> where M1.MatchedType == String, M2.MatchedType == SearchItemEnum, M3.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(String, SearchItemEnum, Bool)>] = [wrap(matchable: keyword) { $0.0 }, wrap(matchable: searchType) { $0.1 }, wrap(matchable: hasStatistic) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub("setForSearchResult(keyword: String, searchType: SearchItemEnum, hasStatistic: Bool)", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_HomeStreamInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        
        var onFinishLoadItems: Cuckoo.VerifyReadOnlyProperty<Observable<Void>> {
            return .init(manager: cuckoo_manager, name: "onFinishLoadItems", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var onErrorLoadItems: Cuckoo.VerifyReadOnlyProperty<Observable<Error>> {
            return .init(manager: cuckoo_manager, name: "onErrorLoadItems", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        

        
        @discardableResult
        func shouldStartLoadItems() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("shouldStartLoadItems()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func getNextItems() -> Cuckoo.__DoNotUse<Observable<([Campaign], SearchStatistic?)>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("getNextItems() -> Observable<([Campaign], SearchStatistic?)>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func clearCache() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("clearCache()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func setForVideoStream() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("setForVideoStream()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func setForSearchResult<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(keyword: M1, searchType: M2, hasStatistic: M3) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String, M2.MatchedType == SearchItemEnum, M3.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(String, SearchItemEnum, Bool)>] = [wrap(matchable: keyword) { $0.0 }, wrap(matchable: searchType) { $0.1 }, wrap(matchable: hasStatistic) { $0.2 }]
            return cuckoo_manager.verify("setForSearchResult(keyword: String, searchType: SearchItemEnum, hasStatistic: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class HomeStreamInteractorStub: HomeStreamInteractor {
    
     var onFinishLoadItems: Observable<Void> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Observable<Void>).self)
        }
        
    }
    
     var onErrorLoadItems: Observable<Error> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Observable<Error>).self)
        }
        
    }
    

    

    
     func shouldStartLoadItems()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func getNextItems()  -> Observable<([Campaign], SearchStatistic?)> {
        return DefaultValueRegistry.defaultValue(for: Observable<([Campaign], SearchStatistic?)>.self)
    }
    
     func clearCache()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func setForVideoStream()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func setForSearchResult(keyword: String, searchType: SearchItemEnum, hasStatistic: Bool)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: MBC/features/common/ErrorDecorator.swift at 2018-03-17 12:42:56 +0000

//
//  ErrorDecorator.swift
//  MBC
//
//  Created by Tuyen Nguyen Thanh on 10/14/16.
//  Copyright © 2016 MBC. All rights reserved.
//

import Cuckoo
@testable import MBC

import Foundation
import UIKit

class MockErrorDecorator: ErrorDecorator, Cuckoo.Mock {
    typealias MocksType = ErrorDecorator
    typealias Stubbing = __StubbingProxy_ErrorDecorator
    typealias Verification = __VerificationProxy_ErrorDecorator
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: ErrorDecorator?

    func spy(on victim: ErrorDecorator) -> Self {
        observed = victim
        return self
    }

    

    

    
    // ["name": "showError", "returnSignature": "", "fullyQualifiedName": "showError(message: String, completed: (() -> Void)?)", "parameterSignature": "message: String, completed: (() -> Void)?", "parameterSignatureWithoutNames": "message: String, completed: (() -> Void)?", "inputTypes": "String, (() -> Void)?", "isThrowing": false, "isInit": false, "hasClosureParams": true, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "message, completed", "call": "message: message, completed: completed", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("message"), name: "message", type: "String", range: CountableRange(222..<237), nameRange: CountableRange(222..<229)), CuckooGeneratorFramework.MethodParameter(label: Optional("completed"), name: "completed", type: "(() -> Void)?", range: CountableRange(239..<263), nameRange: CountableRange(239..<248))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func showError(message: String, completed: (() -> Void)?)  {
        
            return cuckoo_manager.call("showError(message: String, completed: (() -> Void)?)",
                parameters: (message, completed),
                original: observed.map { o in
                    return { (args) in
                        let (message, completed) = args
                         o.showError(message: message, completed: completed)
                    }
                })
        
    }
    
    // ["name": "showConfirm", "returnSignature": "", "fullyQualifiedName": "showConfirm(message: String, leftAction: AlertAction, rightAction: AlertAction)", "parameterSignature": "message: String, leftAction: AlertAction, rightAction: AlertAction", "parameterSignatureWithoutNames": "message: String, leftAction: AlertAction, rightAction: AlertAction", "inputTypes": "String, AlertAction, AlertAction", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "message, leftAction, rightAction", "call": "message: message, leftAction: leftAction, rightAction: rightAction", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("message"), name: "message", type: "String", range: CountableRange(286..<301), nameRange: CountableRange(286..<293)), CuckooGeneratorFramework.MethodParameter(label: Optional("leftAction"), name: "leftAction", type: "AlertAction", range: CountableRange(303..<326), nameRange: CountableRange(303..<313)), CuckooGeneratorFramework.MethodParameter(label: Optional("rightAction"), name: "rightAction", type: "AlertAction", range: CountableRange(328..<352), nameRange: CountableRange(328..<339))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func showConfirm(message: String, leftAction: AlertAction, rightAction: AlertAction)  {
        
            return cuckoo_manager.call("showConfirm(message: String, leftAction: AlertAction, rightAction: AlertAction)",
                parameters: (message, leftAction, rightAction),
                original: observed.map { o in
                    return { (args) in
                        let (message, leftAction, rightAction) = args
                         o.showConfirm(message: message, leftAction: leftAction, rightAction: rightAction)
                    }
                })
        
    }
    

    struct __StubbingProxy_ErrorDecorator: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func showError<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(message: M1, completed: M2) -> Cuckoo.StubNoReturnFunction<(String, (() -> Void)?)> where M1.MatchedType == String, M2.MatchedType == (() -> Void)? {
            let matchers: [Cuckoo.ParameterMatcher<(String, (() -> Void)?)>] = [wrap(matchable: message) { $0.0 }, wrap(matchable: completed) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub("showError(message: String, completed: (() -> Void)?)", parameterMatchers: matchers))
        }
        
        func showConfirm<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(message: M1, leftAction: M2, rightAction: M3) -> Cuckoo.StubNoReturnFunction<(String, AlertAction, AlertAction)> where M1.MatchedType == String, M2.MatchedType == AlertAction, M3.MatchedType == AlertAction {
            let matchers: [Cuckoo.ParameterMatcher<(String, AlertAction, AlertAction)>] = [wrap(matchable: message) { $0.0 }, wrap(matchable: leftAction) { $0.1 }, wrap(matchable: rightAction) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub("showConfirm(message: String, leftAction: AlertAction, rightAction: AlertAction)", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_ErrorDecorator: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func showError<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(message: M1, completed: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String, M2.MatchedType == (() -> Void)? {
            let matchers: [Cuckoo.ParameterMatcher<(String, (() -> Void)?)>] = [wrap(matchable: message) { $0.0 }, wrap(matchable: completed) { $0.1 }]
            return cuckoo_manager.verify("showError(message: String, completed: (() -> Void)?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func showConfirm<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(message: M1, leftAction: M2, rightAction: M3) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String, M2.MatchedType == AlertAction, M3.MatchedType == AlertAction {
            let matchers: [Cuckoo.ParameterMatcher<(String, AlertAction, AlertAction)>] = [wrap(matchable: message) { $0.0 }, wrap(matchable: leftAction) { $0.1 }, wrap(matchable: rightAction) { $0.2 }]
            return cuckoo_manager.verify("showConfirm(message: String, leftAction: AlertAction, rightAction: AlertAction)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class ErrorDecoratorStub: ErrorDecorator {
    

    

    
     func showError(message: String, completed: (() -> Void)?)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func showConfirm(message: String, leftAction: AlertAction, rightAction: AlertAction)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: MBC/data/repositories/StreamRepository.swift at 2018-03-17 12:42:56 +0000

//
//  StreamRepository.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/11/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Cuckoo
@testable import MBC

import UIKit

class MockStreamRepository: StreamRepository, Cuckoo.Mock {
    typealias MocksType = StreamRepository
    typealias Stubbing = __StubbingProxy_StreamRepository
    typealias Verification = __VerificationProxy_StreamRepository
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: StreamRepository?

    func spy(on victim: StreamRepository) -> Self {
        observed = victim
        return self
    }

    

    

    
    // ["name": "savePageStream", "returnSignature": "", "fullyQualifiedName": "savePageStream(pageId: String, itemList: ItemList, dataIndex: (index: Int, totalLoaded: Int)?)", "parameterSignature": "pageId: String, itemList: ItemList, dataIndex: (index: Int, totalLoaded: Int)?", "parameterSignatureWithoutNames": "pageId: String, itemList: ItemList, dataIndex: (index: Int, totalLoaded: Int)?", "inputTypes": "String, ItemList, (index: Int, totalLoaded: Int)?", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageId, itemList, dataIndex", "call": "pageId: pageId, itemList: itemList, dataIndex: dataIndex", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageId"), name: "pageId", type: "String", range: CountableRange(205..<219), nameRange: CountableRange(205..<211)), CuckooGeneratorFramework.MethodParameter(label: Optional("itemList"), name: "itemList", type: "ItemList", range: CountableRange(221..<239), nameRange: CountableRange(221..<229)), CuckooGeneratorFramework.MethodParameter(label: Optional("dataIndex"), name: "dataIndex", type: "(index: Int, totalLoaded: Int)?", range: CountableRange(241..<283), nameRange: CountableRange(241..<250))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func savePageStream(pageId: String, itemList: ItemList, dataIndex: (index: Int, totalLoaded: Int)?)  {
        
            return cuckoo_manager.call("savePageStream(pageId: String, itemList: ItemList, dataIndex: (index: Int, totalLoaded: Int)?)",
                parameters: (pageId, itemList, dataIndex),
                original: observed.map { o in
                    return { (args) in
                        let (pageId, itemList, dataIndex) = args
                         o.savePageStream(pageId: pageId, itemList: itemList, dataIndex: dataIndex)
                    }
                })
        
    }
    
    // ["name": "getCachedPageStream", "returnSignature": " -> (itemList: ItemList?, index: Int, totalLoaded: Int)", "fullyQualifiedName": "getCachedPageStream(pageId: String) -> (itemList: ItemList?, index: Int, totalLoaded: Int)", "parameterSignature": "pageId: String", "parameterSignatureWithoutNames": "pageId: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageId", "call": "pageId: pageId", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageId"), name: "pageId", type: "String", range: CountableRange(314..<328), nameRange: CountableRange(314..<320))], "returnType": "(itemList: ItemList?, index: Int, totalLoaded: Int)", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func getCachedPageStream(pageId: String)  -> (itemList: ItemList?, index: Int, totalLoaded: Int) {
        
            return cuckoo_manager.call("getCachedPageStream(pageId: String) -> (itemList: ItemList?, index: Int, totalLoaded: Int)",
                parameters: (pageId),
                original: observed.map { o in
                    return { (args) -> (itemList: ItemList?, index: Int, totalLoaded: Int) in
                        let (pageId) = args
                        return o.getCachedPageStream(pageId: pageId)
                    }
                })
        
    }
    
    // ["name": "clearPageStreamCache", "returnSignature": "", "fullyQualifiedName": "clearPageStreamCache()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func clearPageStreamCache()  {
        
            return cuckoo_manager.call("clearPageStreamCache()",
                parameters: (),
                original: observed.map { o in
                    return { (args) in
                        let () = args
                         o.clearPageStreamCache()
                    }
                })
        
    }
    
    // ["name": "clearPageStreamCache", "returnSignature": "", "fullyQualifiedName": "clearPageStreamCache(pageId: String)", "parameterSignature": "pageId: String", "parameterSignatureWithoutNames": "pageId: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageId", "call": "pageId: pageId", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageId"), name: "pageId", type: "String", range: CountableRange(447..<461), nameRange: CountableRange(447..<453))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func clearPageStreamCache(pageId: String)  {
        
            return cuckoo_manager.call("clearPageStreamCache(pageId: String)",
                parameters: (pageId),
                original: observed.map { o in
                    return { (args) in
                        let (pageId) = args
                         o.clearPageStreamCache(pageId: pageId)
                    }
                })
        
    }
    
    // ["name": "saveCampaigns", "returnSignature": "", "fullyQualifiedName": "saveCampaigns(_: [Campaign], dataIndex: (index: Int, totalLoaded: Int)?)", "parameterSignature": "_ campaigns: [Campaign], dataIndex: (index: Int, totalLoaded: Int)?", "parameterSignatureWithoutNames": "campaigns: [Campaign], dataIndex: (index: Int, totalLoaded: Int)?", "inputTypes": "[Campaign], (index: Int, totalLoaded: Int)?", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "campaigns, dataIndex", "call": "campaigns, dataIndex: dataIndex", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "campaigns", type: "[Campaign]", range: CountableRange(491..<514), nameRange: CountableRange(0..<0)), CuckooGeneratorFramework.MethodParameter(label: Optional("dataIndex"), name: "dataIndex", type: "(index: Int, totalLoaded: Int)?", range: CountableRange(516..<558), nameRange: CountableRange(516..<525))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func saveCampaigns(_ campaigns: [Campaign], dataIndex: (index: Int, totalLoaded: Int)?)  {
        
            return cuckoo_manager.call("saveCampaigns(_: [Campaign], dataIndex: (index: Int, totalLoaded: Int)?)",
                parameters: (campaigns, dataIndex),
                original: observed.map { o in
                    return { (args) in
                        let (campaigns, dataIndex) = args
                         o.saveCampaigns(campaigns, dataIndex: dataIndex)
                    }
                })
        
    }
    
    // ["name": "getCachedCampaigns", "returnSignature": " -> (list: [Campaign]?, index: Int, totalLoaded: Int)", "fullyQualifiedName": "getCachedCampaigns() -> (list: [Campaign]?, index: Int, totalLoaded: Int)", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "(list: [Campaign]?, index: Int, totalLoaded: Int)", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func getCachedCampaigns()  -> (list: [Campaign]?, index: Int, totalLoaded: Int) {
        
            return cuckoo_manager.call("getCachedCampaigns() -> (list: [Campaign]?, index: Int, totalLoaded: Int)",
                parameters: (),
                original: observed.map { o in
                    return { (args) -> (list: [Campaign]?, index: Int, totalLoaded: Int) in
                        let () = args
                        return o.getCachedCampaigns()
                    }
                })
        
    }
    
    // ["name": "clearCampaignsCache", "returnSignature": "", "fullyQualifiedName": "clearCampaignsCache()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func clearCampaignsCache()  {
        
            return cuckoo_manager.call("clearCampaignsCache()",
                parameters: (),
                original: observed.map { o in
                    return { (args) in
                        let () = args
                         o.clearCampaignsCache()
                    }
                })
        
    }
    
    // ["name": "saveVideoCampaigns", "returnSignature": "", "fullyQualifiedName": "saveVideoCampaigns(_: [Campaign], dataIndex: (index: Int, totalLoaded: Int)?)", "parameterSignature": "_ campaigns: [Campaign], dataIndex: (index: Int, totalLoaded: Int)?", "parameterSignatureWithoutNames": "campaigns: [Campaign], dataIndex: (index: Int, totalLoaded: Int)?", "inputTypes": "[Campaign], (index: Int, totalLoaded: Int)?", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "campaigns, dataIndex", "call": "campaigns, dataIndex: dataIndex", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "campaigns", type: "[Campaign]", range: CountableRange(707..<730), nameRange: CountableRange(0..<0)), CuckooGeneratorFramework.MethodParameter(label: Optional("dataIndex"), name: "dataIndex", type: "(index: Int, totalLoaded: Int)?", range: CountableRange(732..<774), nameRange: CountableRange(732..<741))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func saveVideoCampaigns(_ campaigns: [Campaign], dataIndex: (index: Int, totalLoaded: Int)?)  {
        
            return cuckoo_manager.call("saveVideoCampaigns(_: [Campaign], dataIndex: (index: Int, totalLoaded: Int)?)",
                parameters: (campaigns, dataIndex),
                original: observed.map { o in
                    return { (args) in
                        let (campaigns, dataIndex) = args
                         o.saveVideoCampaigns(campaigns, dataIndex: dataIndex)
                    }
                })
        
    }
    
    // ["name": "getCachedVideoCampaigns", "returnSignature": " -> (list: [Campaign]?, index: Int, totalLoaded: Int)", "fullyQualifiedName": "getCachedVideoCampaigns() -> (list: [Campaign]?, index: Int, totalLoaded: Int)", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "(list: [Campaign]?, index: Int, totalLoaded: Int)", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func getCachedVideoCampaigns()  -> (list: [Campaign]?, index: Int, totalLoaded: Int) {
        
            return cuckoo_manager.call("getCachedVideoCampaigns() -> (list: [Campaign]?, index: Int, totalLoaded: Int)",
                parameters: (),
                original: observed.map { o in
                    return { (args) -> (list: [Campaign]?, index: Int, totalLoaded: Int) in
                        let () = args
                        return o.getCachedVideoCampaigns()
                    }
                })
        
    }
    
    // ["name": "clearVideoCampaignsCache", "returnSignature": "", "fullyQualifiedName": "clearVideoCampaignsCache()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func clearVideoCampaignsCache()  {
        
            return cuckoo_manager.call("clearVideoCampaignsCache()",
                parameters: (),
                original: observed.map { o in
                    return { (args) in
                        let () = args
                         o.clearVideoCampaignsCache()
                    }
                })
        
    }
    

    struct __StubbingProxy_StreamRepository: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func savePageStream<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(pageId: M1, itemList: M2, dataIndex: M3) -> Cuckoo.StubNoReturnFunction<(String, ItemList, (index: Int, totalLoaded: Int)?)> where M1.MatchedType == String, M2.MatchedType == ItemList, M3.MatchedType == (index: Int, totalLoaded: Int)? {
            let matchers: [Cuckoo.ParameterMatcher<(String, ItemList, (index: Int, totalLoaded: Int)?)>] = [wrap(matchable: pageId) { $0.0 }, wrap(matchable: itemList) { $0.1 }, wrap(matchable: dataIndex) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub("savePageStream(pageId: String, itemList: ItemList, dataIndex: (index: Int, totalLoaded: Int)?)", parameterMatchers: matchers))
        }
        
        func getCachedPageStream<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.StubFunction<(String), (itemList: ItemList?, index: Int, totalLoaded: Int)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return .init(stub: cuckoo_manager.createStub("getCachedPageStream(pageId: String) -> (itemList: ItemList?, index: Int, totalLoaded: Int)", parameterMatchers: matchers))
        }
        
        func clearPageStreamCache() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("clearPageStreamCache()", parameterMatchers: matchers))
        }
        
        func clearPageStreamCache<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.StubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return .init(stub: cuckoo_manager.createStub("clearPageStreamCache(pageId: String)", parameterMatchers: matchers))
        }
        
        func saveCampaigns<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ campaigns: M1, dataIndex: M2) -> Cuckoo.StubNoReturnFunction<([Campaign], (index: Int, totalLoaded: Int)?)> where M1.MatchedType == [Campaign], M2.MatchedType == (index: Int, totalLoaded: Int)? {
            let matchers: [Cuckoo.ParameterMatcher<([Campaign], (index: Int, totalLoaded: Int)?)>] = [wrap(matchable: campaigns) { $0.0 }, wrap(matchable: dataIndex) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub("saveCampaigns(_: [Campaign], dataIndex: (index: Int, totalLoaded: Int)?)", parameterMatchers: matchers))
        }
        
        func getCachedCampaigns() -> Cuckoo.StubFunction<(), (list: [Campaign]?, index: Int, totalLoaded: Int)> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("getCachedCampaigns() -> (list: [Campaign]?, index: Int, totalLoaded: Int)", parameterMatchers: matchers))
        }
        
        func clearCampaignsCache() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("clearCampaignsCache()", parameterMatchers: matchers))
        }
        
        func saveVideoCampaigns<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ campaigns: M1, dataIndex: M2) -> Cuckoo.StubNoReturnFunction<([Campaign], (index: Int, totalLoaded: Int)?)> where M1.MatchedType == [Campaign], M2.MatchedType == (index: Int, totalLoaded: Int)? {
            let matchers: [Cuckoo.ParameterMatcher<([Campaign], (index: Int, totalLoaded: Int)?)>] = [wrap(matchable: campaigns) { $0.0 }, wrap(matchable: dataIndex) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub("saveVideoCampaigns(_: [Campaign], dataIndex: (index: Int, totalLoaded: Int)?)", parameterMatchers: matchers))
        }
        
        func getCachedVideoCampaigns() -> Cuckoo.StubFunction<(), (list: [Campaign]?, index: Int, totalLoaded: Int)> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("getCachedVideoCampaigns() -> (list: [Campaign]?, index: Int, totalLoaded: Int)", parameterMatchers: matchers))
        }
        
        func clearVideoCampaignsCache() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("clearVideoCampaignsCache()", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_StreamRepository: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func savePageStream<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(pageId: M1, itemList: M2, dataIndex: M3) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String, M2.MatchedType == ItemList, M3.MatchedType == (index: Int, totalLoaded: Int)? {
            let matchers: [Cuckoo.ParameterMatcher<(String, ItemList, (index: Int, totalLoaded: Int)?)>] = [wrap(matchable: pageId) { $0.0 }, wrap(matchable: itemList) { $0.1 }, wrap(matchable: dataIndex) { $0.2 }]
            return cuckoo_manager.verify("savePageStream(pageId: String, itemList: ItemList, dataIndex: (index: Int, totalLoaded: Int)?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func getCachedPageStream<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.__DoNotUse<(itemList: ItemList?, index: Int, totalLoaded: Int)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return cuckoo_manager.verify("getCachedPageStream(pageId: String) -> (itemList: ItemList?, index: Int, totalLoaded: Int)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func clearPageStreamCache() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("clearPageStreamCache()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func clearPageStreamCache<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return cuckoo_manager.verify("clearPageStreamCache(pageId: String)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func saveCampaigns<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ campaigns: M1, dataIndex: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == [Campaign], M2.MatchedType == (index: Int, totalLoaded: Int)? {
            let matchers: [Cuckoo.ParameterMatcher<([Campaign], (index: Int, totalLoaded: Int)?)>] = [wrap(matchable: campaigns) { $0.0 }, wrap(matchable: dataIndex) { $0.1 }]
            return cuckoo_manager.verify("saveCampaigns(_: [Campaign], dataIndex: (index: Int, totalLoaded: Int)?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func getCachedCampaigns() -> Cuckoo.__DoNotUse<(list: [Campaign]?, index: Int, totalLoaded: Int)> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("getCachedCampaigns() -> (list: [Campaign]?, index: Int, totalLoaded: Int)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func clearCampaignsCache() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("clearCampaignsCache()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func saveVideoCampaigns<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ campaigns: M1, dataIndex: M2) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == [Campaign], M2.MatchedType == (index: Int, totalLoaded: Int)? {
            let matchers: [Cuckoo.ParameterMatcher<([Campaign], (index: Int, totalLoaded: Int)?)>] = [wrap(matchable: campaigns) { $0.0 }, wrap(matchable: dataIndex) { $0.1 }]
            return cuckoo_manager.verify("saveVideoCampaigns(_: [Campaign], dataIndex: (index: Int, totalLoaded: Int)?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func getCachedVideoCampaigns() -> Cuckoo.__DoNotUse<(list: [Campaign]?, index: Int, totalLoaded: Int)> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("getCachedVideoCampaigns() -> (list: [Campaign]?, index: Int, totalLoaded: Int)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func clearVideoCampaignsCache() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("clearVideoCampaignsCache()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class StreamRepositoryStub: StreamRepository {
    

    

    
     func savePageStream(pageId: String, itemList: ItemList, dataIndex: (index: Int, totalLoaded: Int)?)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func getCachedPageStream(pageId: String)  -> (itemList: ItemList?, index: Int, totalLoaded: Int) {
        return DefaultValueRegistry.defaultValue(for: (itemList: ItemList?, index: Int, totalLoaded: Int).self)
    }
    
     func clearPageStreamCache()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func clearPageStreamCache(pageId: String)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func saveCampaigns(_ campaigns: [Campaign], dataIndex: (index: Int, totalLoaded: Int)?)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func getCachedCampaigns()  -> (list: [Campaign]?, index: Int, totalLoaded: Int) {
        return DefaultValueRegistry.defaultValue(for: (list: [Campaign]?, index: Int, totalLoaded: Int).self)
    }
    
     func clearCampaignsCache()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func saveVideoCampaigns(_ campaigns: [Campaign], dataIndex: (index: Int, totalLoaded: Int)?)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func getCachedVideoCampaigns()  -> (list: [Campaign]?, index: Int, totalLoaded: Int) {
        return DefaultValueRegistry.defaultValue(for: (list: [Campaign]?, index: Int, totalLoaded: Int).self)
    }
    
     func clearVideoCampaignsCache()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: MBC/data/repositories/PageDetailRepository.swift at 2018-03-17 12:42:56 +0000

//
//  PageDetailRepository.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/7/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Cuckoo
@testable import MBC

import UIKit

class MockPageDetailRepository: PageDetailRepository, Cuckoo.Mock {
    typealias MocksType = PageDetailRepository
    typealias Stubbing = __StubbingProxy_PageDetailRepository
    typealias Verification = __VerificationProxy_PageDetailRepository
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: PageDetailRepository?

    func spy(on victim: PageDetailRepository) -> Self {
        observed = victim
        return self
    }

    

    

    
    // ["name": "savePageDetail", "returnSignature": "", "fullyQualifiedName": "savePageDetail(pageDetail: PageDetail)", "parameterSignature": "pageDetail: PageDetail", "parameterSignatureWithoutNames": "pageDetail: PageDetail", "inputTypes": "PageDetail", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageDetail", "call": "pageDetail: pageDetail", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageDetail"), name: "pageDetail", type: "PageDetail", range: CountableRange(212..<234), nameRange: CountableRange(212..<222))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func savePageDetail(pageDetail: PageDetail)  {
        
            return cuckoo_manager.call("savePageDetail(pageDetail: PageDetail)",
                parameters: (pageDetail),
                original: observed.map { o in
                    return { (args) in
                        let (pageDetail) = args
                         o.savePageDetail(pageDetail: pageDetail)
                    }
                })
        
    }
    
    // ["name": "getCachedPageDetail", "returnSignature": " -> PageDetail?", "fullyQualifiedName": "getCachedPageDetail(pageId: String) -> PageDetail?", "parameterSignature": "pageId: String", "parameterSignatureWithoutNames": "pageId: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageId", "call": "pageId: pageId", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageId"), name: "pageId", type: "String", range: CountableRange(265..<279), nameRange: CountableRange(265..<271))], "returnType": "Optional<PageDetail>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func getCachedPageDetail(pageId: String)  -> PageDetail? {
        
            return cuckoo_manager.call("getCachedPageDetail(pageId: String) -> PageDetail?",
                parameters: (pageId),
                original: observed.map { o in
                    return { (args) -> PageDetail? in
                        let (pageId) = args
                        return o.getCachedPageDetail(pageId: pageId)
                    }
                })
        
    }
    
    // ["name": "clearPageDetailCache", "returnSignature": "", "fullyQualifiedName": "clearPageDetailCache(pageId: String)", "parameterSignature": "pageId: String", "parameterSignatureWithoutNames": "pageId: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageId", "call": "pageId: pageId", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageId"), name: "pageId", type: "String", range: CountableRange(326..<340), nameRange: CountableRange(326..<332))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func clearPageDetailCache(pageId: String)  {
        
            return cuckoo_manager.call("clearPageDetailCache(pageId: String)",
                parameters: (pageId),
                original: observed.map { o in
                    return { (args) in
                        let (pageId) = args
                         o.clearPageDetailCache(pageId: pageId)
                    }
                })
        
    }
    
    // ["name": "clearPageDetailCache", "returnSignature": "", "fullyQualifiedName": "clearPageDetailCache()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func clearPageDetailCache()  {
        
            return cuckoo_manager.call("clearPageDetailCache()",
                parameters: (),
                original: observed.map { o in
                    return { (args) in
                        let () = args
                         o.clearPageDetailCache()
                    }
                })
        
    }
    

    struct __StubbingProxy_PageDetailRepository: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func savePageDetail<M1: Cuckoo.Matchable>(pageDetail: M1) -> Cuckoo.StubNoReturnFunction<(PageDetail)> where M1.MatchedType == PageDetail {
            let matchers: [Cuckoo.ParameterMatcher<(PageDetail)>] = [wrap(matchable: pageDetail) { $0 }]
            return .init(stub: cuckoo_manager.createStub("savePageDetail(pageDetail: PageDetail)", parameterMatchers: matchers))
        }
        
        func getCachedPageDetail<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.StubFunction<(String), Optional<PageDetail>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return .init(stub: cuckoo_manager.createStub("getCachedPageDetail(pageId: String) -> PageDetail?", parameterMatchers: matchers))
        }
        
        func clearPageDetailCache<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.StubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return .init(stub: cuckoo_manager.createStub("clearPageDetailCache(pageId: String)", parameterMatchers: matchers))
        }
        
        func clearPageDetailCache() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("clearPageDetailCache()", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_PageDetailRepository: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func savePageDetail<M1: Cuckoo.Matchable>(pageDetail: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == PageDetail {
            let matchers: [Cuckoo.ParameterMatcher<(PageDetail)>] = [wrap(matchable: pageDetail) { $0 }]
            return cuckoo_manager.verify("savePageDetail(pageDetail: PageDetail)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func getCachedPageDetail<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.__DoNotUse<Optional<PageDetail>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return cuckoo_manager.verify("getCachedPageDetail(pageId: String) -> PageDetail?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func clearPageDetailCache<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return cuckoo_manager.verify("clearPageDetailCache(pageId: String)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func clearPageDetailCache() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("clearPageDetailCache()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class PageDetailRepositoryStub: PageDetailRepository {
    

    

    
     func savePageDetail(pageDetail: PageDetail)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func getCachedPageDetail(pageId: String)  -> PageDetail? {
        return DefaultValueRegistry.defaultValue(for: Optional<PageDetail>.self)
    }
    
     func clearPageDetailCache(pageId: String)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func clearPageDetailCache()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: MBC/data/repositories/PageAlbumRepository.swift at 2018-03-17 12:42:56 +0000

//
//  PageAlbumRepository.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/14/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Cuckoo
@testable import MBC

import UIKit

class MockPageAlbumRepository: PageAlbumRepository, Cuckoo.Mock {
    typealias MocksType = PageAlbumRepository
    typealias Stubbing = __StubbingProxy_PageAlbumRepository
    typealias Verification = __VerificationProxy_PageAlbumRepository
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: PageAlbumRepository?

    func spy(on victim: PageAlbumRepository) -> Self {
        observed = victim
        return self
    }

    

    

    
    // ["name": "saveDefaultAlbum", "returnSignature": "", "fullyQualifiedName": "saveDefaultAlbum(pageId: String, mediaList: [Media], grandTotal: Int?)", "parameterSignature": "pageId: String, mediaList: [Media], grandTotal: Int?", "parameterSignatureWithoutNames": "pageId: String, mediaList: [Media], grandTotal: Int?", "inputTypes": "String, [Media], Int?", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageId, mediaList, grandTotal", "call": "pageId: pageId, mediaList: mediaList, grandTotal: grandTotal", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageId"), name: "pageId", type: "String", range: CountableRange(213..<227), nameRange: CountableRange(213..<219)), CuckooGeneratorFramework.MethodParameter(label: Optional("mediaList"), name: "mediaList", type: "[Media]", range: CountableRange(229..<247), nameRange: CountableRange(229..<238)), CuckooGeneratorFramework.MethodParameter(label: Optional("grandTotal"), name: "grandTotal", type: "Int?", range: CountableRange(249..<265), nameRange: CountableRange(249..<259))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func saveDefaultAlbum(pageId: String, mediaList: [Media], grandTotal: Int?)  {
        
            return cuckoo_manager.call("saveDefaultAlbum(pageId: String, mediaList: [Media], grandTotal: Int?)",
                parameters: (pageId, mediaList, grandTotal),
                original: observed.map { o in
                    return { (args) in
                        let (pageId, mediaList, grandTotal) = args
                         o.saveDefaultAlbum(pageId: pageId, mediaList: mediaList, grandTotal: grandTotal)
                    }
                })
        
    }
    
    // ["name": "getCachedDefaultAlbum", "returnSignature": " -> ([Media]?, Int)", "fullyQualifiedName": "getCachedDefaultAlbum(pageId: String) -> ([Media]?, Int)", "parameterSignature": "pageId: String", "parameterSignatureWithoutNames": "pageId: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageId", "call": "pageId: pageId", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageId"), name: "pageId", type: "String", range: CountableRange(298..<312), nameRange: CountableRange(298..<304))], "returnType": "([Media]?, Int)", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func getCachedDefaultAlbum(pageId: String)  -> ([Media]?, Int) {
        
            return cuckoo_manager.call("getCachedDefaultAlbum(pageId: String) -> ([Media]?, Int)",
                parameters: (pageId),
                original: observed.map { o in
                    return { (args) -> ([Media]?, Int) in
                        let (pageId) = args
                        return o.getCachedDefaultAlbum(pageId: pageId)
                    }
                })
        
    }
    
    // ["name": "clearDefaultAlbumCache", "returnSignature": "", "fullyQualifiedName": "clearDefaultAlbumCache()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func clearDefaultAlbumCache()  {
        
            return cuckoo_manager.call("clearDefaultAlbumCache()",
                parameters: (),
                original: observed.map { o in
                    return { (args) in
                        let () = args
                         o.clearDefaultAlbumCache()
                    }
                })
        
    }
    
    // ["name": "clearDefaultAlbumCache", "returnSignature": "", "fullyQualifiedName": "clearDefaultAlbumCache(pageId: String)", "parameterSignature": "pageId: String", "parameterSignatureWithoutNames": "pageId: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageId", "call": "pageId: pageId", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageId"), name: "pageId", type: "String", range: CountableRange(399..<413), nameRange: CountableRange(399..<405))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func clearDefaultAlbumCache(pageId: String)  {
        
            return cuckoo_manager.call("clearDefaultAlbumCache(pageId: String)",
                parameters: (pageId),
                original: observed.map { o in
                    return { (args) in
                        let (pageId) = args
                         o.clearDefaultAlbumCache(pageId: pageId)
                    }
                })
        
    }
    

    struct __StubbingProxy_PageAlbumRepository: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func saveDefaultAlbum<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(pageId: M1, mediaList: M2, grandTotal: M3) -> Cuckoo.StubNoReturnFunction<(String, [Media], Int?)> where M1.MatchedType == String, M2.MatchedType == [Media], M3.MatchedType == Int? {
            let matchers: [Cuckoo.ParameterMatcher<(String, [Media], Int?)>] = [wrap(matchable: pageId) { $0.0 }, wrap(matchable: mediaList) { $0.1 }, wrap(matchable: grandTotal) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub("saveDefaultAlbum(pageId: String, mediaList: [Media], grandTotal: Int?)", parameterMatchers: matchers))
        }
        
        func getCachedDefaultAlbum<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.StubFunction<(String), ([Media]?, Int)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return .init(stub: cuckoo_manager.createStub("getCachedDefaultAlbum(pageId: String) -> ([Media]?, Int)", parameterMatchers: matchers))
        }
        
        func clearDefaultAlbumCache() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("clearDefaultAlbumCache()", parameterMatchers: matchers))
        }
        
        func clearDefaultAlbumCache<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.StubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return .init(stub: cuckoo_manager.createStub("clearDefaultAlbumCache(pageId: String)", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_PageAlbumRepository: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func saveDefaultAlbum<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(pageId: M1, mediaList: M2, grandTotal: M3) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String, M2.MatchedType == [Media], M3.MatchedType == Int? {
            let matchers: [Cuckoo.ParameterMatcher<(String, [Media], Int?)>] = [wrap(matchable: pageId) { $0.0 }, wrap(matchable: mediaList) { $0.1 }, wrap(matchable: grandTotal) { $0.2 }]
            return cuckoo_manager.verify("saveDefaultAlbum(pageId: String, mediaList: [Media], grandTotal: Int?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func getCachedDefaultAlbum<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.__DoNotUse<([Media]?, Int)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return cuckoo_manager.verify("getCachedDefaultAlbum(pageId: String) -> ([Media]?, Int)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func clearDefaultAlbumCache() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("clearDefaultAlbumCache()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func clearDefaultAlbumCache<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return cuckoo_manager.verify("clearDefaultAlbumCache(pageId: String)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class PageAlbumRepositoryStub: PageAlbumRepository {
    

    

    
     func saveDefaultAlbum(pageId: String, mediaList: [Media], grandTotal: Int?)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func getCachedDefaultAlbum(pageId: String)  -> ([Media]?, Int) {
        return DefaultValueRegistry.defaultValue(for: ([Media]?, Int).self)
    }
    
     func clearDefaultAlbumCache()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func clearDefaultAlbumCache(pageId: String)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: MBC/data/repositories/LanguageConfigRepository.swift at 2018-03-17 12:42:56 +0000

//
//  LanguageConfigRepository.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/21/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Cuckoo
@testable import MBC

import Foundation

class MockLanguageConfigRepository: LanguageConfigRepository, Cuckoo.Mock {
    typealias MocksType = LanguageConfigRepository
    typealias Stubbing = __StubbingProxy_LanguageConfigRepository
    typealias Verification = __VerificationProxy_LanguageConfigRepository
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: LanguageConfigRepository?

    func spy(on victim: LanguageConfigRepository) -> Self {
        observed = victim
        return self
    }

    

    

    
    // ["name": "saveLanguageConfig", "returnSignature": "", "fullyQualifiedName": "saveLanguageConfig(languageConfig: LanguageConfigListEntity)", "parameterSignature": "languageConfig: LanguageConfigListEntity", "parameterSignatureWithoutNames": "languageConfig: LanguageConfigListEntity", "inputTypes": "LanguageConfigListEntity", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "languageConfig", "call": "languageConfig: languageConfig", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("languageConfig"), name: "languageConfig", type: "LanguageConfigListEntity", range: CountableRange(230..<270), nameRange: CountableRange(230..<244))], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func saveLanguageConfig(languageConfig: LanguageConfigListEntity)  {
        
            return cuckoo_manager.call("saveLanguageConfig(languageConfig: LanguageConfigListEntity)",
                parameters: (languageConfig),
                original: observed.map { o in
                    return { (args) in
                        let (languageConfig) = args
                         o.saveLanguageConfig(languageConfig: languageConfig)
                    }
                })
        
    }
    
    // ["name": "getLanguageConfig", "returnSignature": " -> LanguageConfigListEntity?", "fullyQualifiedName": "getLanguageConfig(type: String) -> LanguageConfigListEntity?", "parameterSignature": "type: String", "parameterSignatureWithoutNames": "type: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "type", "call": "type: type", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("type"), name: "type", type: "String", range: CountableRange(299..<311), nameRange: CountableRange(299..<303))], "returnType": "Optional<LanguageConfigListEntity>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func getLanguageConfig(type: String)  -> LanguageConfigListEntity? {
        
            return cuckoo_manager.call("getLanguageConfig(type: String) -> LanguageConfigListEntity?",
                parameters: (type),
                original: observed.map { o in
                    return { (args) -> LanguageConfigListEntity? in
                        let (type) = args
                        return o.getLanguageConfig(type: type)
                    }
                })
        
    }
    
    // ["name": "clearLanguageConfigCache", "returnSignature": "", "fullyQualifiedName": "clearLanguageConfigCache()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "stubFunction": "Cuckoo.StubNoReturnFunction"]
     func clearLanguageConfigCache()  {
        
            return cuckoo_manager.call("clearLanguageConfigCache()",
                parameters: (),
                original: observed.map { o in
                    return { (args) in
                        let () = args
                         o.clearLanguageConfigCache()
                    }
                })
        
    }
    

    struct __StubbingProxy_LanguageConfigRepository: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func saveLanguageConfig<M1: Cuckoo.Matchable>(languageConfig: M1) -> Cuckoo.StubNoReturnFunction<(LanguageConfigListEntity)> where M1.MatchedType == LanguageConfigListEntity {
            let matchers: [Cuckoo.ParameterMatcher<(LanguageConfigListEntity)>] = [wrap(matchable: languageConfig) { $0 }]
            return .init(stub: cuckoo_manager.createStub("saveLanguageConfig(languageConfig: LanguageConfigListEntity)", parameterMatchers: matchers))
        }
        
        func getLanguageConfig<M1: Cuckoo.Matchable>(type: M1) -> Cuckoo.StubFunction<(String), Optional<LanguageConfigListEntity>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: type) { $0 }]
            return .init(stub: cuckoo_manager.createStub("getLanguageConfig(type: String) -> LanguageConfigListEntity?", parameterMatchers: matchers))
        }
        
        func clearLanguageConfigCache() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("clearLanguageConfigCache()", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_LanguageConfigRepository: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func saveLanguageConfig<M1: Cuckoo.Matchable>(languageConfig: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == LanguageConfigListEntity {
            let matchers: [Cuckoo.ParameterMatcher<(LanguageConfigListEntity)>] = [wrap(matchable: languageConfig) { $0 }]
            return cuckoo_manager.verify("saveLanguageConfig(languageConfig: LanguageConfigListEntity)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func getLanguageConfig<M1: Cuckoo.Matchable>(type: M1) -> Cuckoo.__DoNotUse<Optional<LanguageConfigListEntity>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: type) { $0 }]
            return cuckoo_manager.verify("getLanguageConfig(type: String) -> LanguageConfigListEntity?", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func clearLanguageConfigCache() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("clearLanguageConfigCache()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class LanguageConfigRepositoryStub: LanguageConfigRepository {
    

    

    
     func saveLanguageConfig(languageConfig: LanguageConfigListEntity)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func getLanguageConfig(type: String)  -> LanguageConfigListEntity? {
        return DefaultValueRegistry.defaultValue(for: Optional<LanguageConfigListEntity>.self)
    }
    
     func clearLanguageConfigCache()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: MBC/data/api/StreamApi.swift at 2018-03-17 12:42:56 +0000

//
//  StreamApi.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/6/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Cuckoo
@testable import MBC

import Foundation
import RxSwift

class MockStreamApi: StreamApi, Cuckoo.Mock {
    typealias MocksType = StreamApi
    typealias Stubbing = __StubbingProxy_StreamApi
    typealias Verification = __VerificationProxy_StreamApi
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: StreamApi?

    func spy(on victim: StreamApi) -> Self {
        observed = victim
        return self
    }

    

    

    
    // ["name": "loadStreamBy", "returnSignature": " -> Observable<StreamEntity>", "fullyQualifiedName": "loadStreamBy(pageId: String, fromIndex: Int, numberOfItems: Int) -> Observable<StreamEntity>", "parameterSignature": "pageId: String, fromIndex: Int, numberOfItems: Int", "parameterSignatureWithoutNames": "pageId: String, fromIndex: Int, numberOfItems: Int", "inputTypes": "String, Int, Int", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageId, fromIndex, numberOfItems", "call": "pageId: pageId, fromIndex: fromIndex, numberOfItems: numberOfItems", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageId"), name: "pageId", type: "String", range: CountableRange(208..<222), nameRange: CountableRange(208..<214)), CuckooGeneratorFramework.MethodParameter(label: Optional("fromIndex"), name: "fromIndex", type: "Int", range: CountableRange(224..<238), nameRange: CountableRange(224..<233)), CuckooGeneratorFramework.MethodParameter(label: Optional("numberOfItems"), name: "numberOfItems", type: "Int", range: CountableRange(240..<258), nameRange: CountableRange(240..<253))], "returnType": "Observable<StreamEntity>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func loadStreamBy(pageId: String, fromIndex: Int, numberOfItems: Int)  -> Observable<StreamEntity> {
        
            return cuckoo_manager.call("loadStreamBy(pageId: String, fromIndex: Int, numberOfItems: Int) -> Observable<StreamEntity>",
                parameters: (pageId, fromIndex, numberOfItems),
                original: observed.map { o in
                    return { (args) -> Observable<StreamEntity> in
                        let (pageId, fromIndex, numberOfItems) = args
                        return o.loadStreamBy(pageId: pageId, fromIndex: fromIndex, numberOfItems: numberOfItems)
                    }
                })
        
    }
    
    // ["name": "loadHomeStreamWith", "returnSignature": " -> Observable<HomeStreamEntity>", "fullyQualifiedName": "loadHomeStreamWith(timeOffset: Int, fromIndex: Int, numberOfItems: Int) -> Observable<HomeStreamEntity>", "parameterSignature": "timeOffset: Int, fromIndex: Int, numberOfItems: Int", "parameterSignatureWithoutNames": "timeOffset: Int, fromIndex: Int, numberOfItems: Int", "inputTypes": "Int, Int, Int", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "timeOffset, fromIndex, numberOfItems", "call": "timeOffset: timeOffset, fromIndex: fromIndex, numberOfItems: numberOfItems", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("timeOffset"), name: "timeOffset", type: "Int", range: CountableRange(316..<331), nameRange: CountableRange(316..<326)), CuckooGeneratorFramework.MethodParameter(label: Optional("fromIndex"), name: "fromIndex", type: "Int", range: CountableRange(333..<347), nameRange: CountableRange(333..<342)), CuckooGeneratorFramework.MethodParameter(label: Optional("numberOfItems"), name: "numberOfItems", type: "Int", range: CountableRange(349..<367), nameRange: CountableRange(349..<362))], "returnType": "Observable<HomeStreamEntity>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func loadHomeStreamWith(timeOffset: Int, fromIndex: Int, numberOfItems: Int)  -> Observable<HomeStreamEntity> {
        
            return cuckoo_manager.call("loadHomeStreamWith(timeOffset: Int, fromIndex: Int, numberOfItems: Int) -> Observable<HomeStreamEntity>",
                parameters: (timeOffset, fromIndex, numberOfItems),
                original: observed.map { o in
                    return { (args) -> Observable<HomeStreamEntity> in
                        let (timeOffset, fromIndex, numberOfItems) = args
                        return o.loadHomeStreamWith(timeOffset: timeOffset, fromIndex: fromIndex, numberOfItems: numberOfItems)
                    }
                })
        
    }
    
    // ["name": "loadVideoStreamWith", "returnSignature": " -> Observable<HomeStreamEntity>", "fullyQualifiedName": "loadVideoStreamWith(timeOffset: Int, fromIndex: Int, numberOfItems: Int) -> Observable<HomeStreamEntity>", "parameterSignature": "timeOffset: Int, fromIndex: Int, numberOfItems: Int", "parameterSignatureWithoutNames": "timeOffset: Int, fromIndex: Int, numberOfItems: Int", "inputTypes": "Int, Int, Int", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "timeOffset, fromIndex, numberOfItems", "call": "timeOffset: timeOffset, fromIndex: fromIndex, numberOfItems: numberOfItems", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("timeOffset"), name: "timeOffset", type: "Int", range: CountableRange(430..<445), nameRange: CountableRange(430..<440)), CuckooGeneratorFramework.MethodParameter(label: Optional("fromIndex"), name: "fromIndex", type: "Int", range: CountableRange(447..<461), nameRange: CountableRange(447..<456)), CuckooGeneratorFramework.MethodParameter(label: Optional("numberOfItems"), name: "numberOfItems", type: "Int", range: CountableRange(463..<481), nameRange: CountableRange(463..<476))], "returnType": "Observable<HomeStreamEntity>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func loadVideoStreamWith(timeOffset: Int, fromIndex: Int, numberOfItems: Int)  -> Observable<HomeStreamEntity> {
        
            return cuckoo_manager.call("loadVideoStreamWith(timeOffset: Int, fromIndex: Int, numberOfItems: Int) -> Observable<HomeStreamEntity>",
                parameters: (timeOffset, fromIndex, numberOfItems),
                original: observed.map { o in
                    return { (args) -> Observable<HomeStreamEntity> in
                        let (timeOffset, fromIndex, numberOfItems) = args
                        return o.loadVideoStreamWith(timeOffset: timeOffset, fromIndex: fromIndex, numberOfItems: numberOfItems)
                    }
                })
        
    }
    
    // ["name": "getSearchResult", "returnSignature": " -> Observable<SearchResultEntity>", "fullyQualifiedName": "getSearchResult(data: SearchCondition) -> Observable<SearchResultEntity>", "parameterSignature": "data: SearchCondition", "parameterSignatureWithoutNames": "data: SearchCondition", "inputTypes": "SearchCondition", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "data", "call": "data: data", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("data"), name: "data", type: "SearchCondition", range: CountableRange(537..<558), nameRange: CountableRange(537..<541))], "returnType": "Observable<SearchResultEntity>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func getSearchResult(data: SearchCondition)  -> Observable<SearchResultEntity> {
        
            return cuckoo_manager.call("getSearchResult(data: SearchCondition) -> Observable<SearchResultEntity>",
                parameters: (data),
                original: observed.map { o in
                    return { (args) -> Observable<SearchResultEntity> in
                        let (data) = args
                        return o.getSearchResult(data: data)
                    }
                })
        
    }
    

    struct __StubbingProxy_StreamApi: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func loadStreamBy<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(pageId: M1, fromIndex: M2, numberOfItems: M3) -> Cuckoo.StubFunction<(String, Int, Int), Observable<StreamEntity>> where M1.MatchedType == String, M2.MatchedType == Int, M3.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(String, Int, Int)>] = [wrap(matchable: pageId) { $0.0 }, wrap(matchable: fromIndex) { $0.1 }, wrap(matchable: numberOfItems) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub("loadStreamBy(pageId: String, fromIndex: Int, numberOfItems: Int) -> Observable<StreamEntity>", parameterMatchers: matchers))
        }
        
        func loadHomeStreamWith<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(timeOffset: M1, fromIndex: M2, numberOfItems: M3) -> Cuckoo.StubFunction<(Int, Int, Int), Observable<HomeStreamEntity>> where M1.MatchedType == Int, M2.MatchedType == Int, M3.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int, Int, Int)>] = [wrap(matchable: timeOffset) { $0.0 }, wrap(matchable: fromIndex) { $0.1 }, wrap(matchable: numberOfItems) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub("loadHomeStreamWith(timeOffset: Int, fromIndex: Int, numberOfItems: Int) -> Observable<HomeStreamEntity>", parameterMatchers: matchers))
        }
        
        func loadVideoStreamWith<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(timeOffset: M1, fromIndex: M2, numberOfItems: M3) -> Cuckoo.StubFunction<(Int, Int, Int), Observable<HomeStreamEntity>> where M1.MatchedType == Int, M2.MatchedType == Int, M3.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int, Int, Int)>] = [wrap(matchable: timeOffset) { $0.0 }, wrap(matchable: fromIndex) { $0.1 }, wrap(matchable: numberOfItems) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub("loadVideoStreamWith(timeOffset: Int, fromIndex: Int, numberOfItems: Int) -> Observable<HomeStreamEntity>", parameterMatchers: matchers))
        }
        
        func getSearchResult<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.StubFunction<(SearchCondition), Observable<SearchResultEntity>> where M1.MatchedType == SearchCondition {
            let matchers: [Cuckoo.ParameterMatcher<(SearchCondition)>] = [wrap(matchable: data) { $0 }]
            return .init(stub: cuckoo_manager.createStub("getSearchResult(data: SearchCondition) -> Observable<SearchResultEntity>", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_StreamApi: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func loadStreamBy<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(pageId: M1, fromIndex: M2, numberOfItems: M3) -> Cuckoo.__DoNotUse<Observable<StreamEntity>> where M1.MatchedType == String, M2.MatchedType == Int, M3.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(String, Int, Int)>] = [wrap(matchable: pageId) { $0.0 }, wrap(matchable: fromIndex) { $0.1 }, wrap(matchable: numberOfItems) { $0.2 }]
            return cuckoo_manager.verify("loadStreamBy(pageId: String, fromIndex: Int, numberOfItems: Int) -> Observable<StreamEntity>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func loadHomeStreamWith<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(timeOffset: M1, fromIndex: M2, numberOfItems: M3) -> Cuckoo.__DoNotUse<Observable<HomeStreamEntity>> where M1.MatchedType == Int, M2.MatchedType == Int, M3.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int, Int, Int)>] = [wrap(matchable: timeOffset) { $0.0 }, wrap(matchable: fromIndex) { $0.1 }, wrap(matchable: numberOfItems) { $0.2 }]
            return cuckoo_manager.verify("loadHomeStreamWith(timeOffset: Int, fromIndex: Int, numberOfItems: Int) -> Observable<HomeStreamEntity>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func loadVideoStreamWith<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(timeOffset: M1, fromIndex: M2, numberOfItems: M3) -> Cuckoo.__DoNotUse<Observable<HomeStreamEntity>> where M1.MatchedType == Int, M2.MatchedType == Int, M3.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int, Int, Int)>] = [wrap(matchable: timeOffset) { $0.0 }, wrap(matchable: fromIndex) { $0.1 }, wrap(matchable: numberOfItems) { $0.2 }]
            return cuckoo_manager.verify("loadVideoStreamWith(timeOffset: Int, fromIndex: Int, numberOfItems: Int) -> Observable<HomeStreamEntity>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func getSearchResult<M1: Cuckoo.Matchable>(data: M1) -> Cuckoo.__DoNotUse<Observable<SearchResultEntity>> where M1.MatchedType == SearchCondition {
            let matchers: [Cuckoo.ParameterMatcher<(SearchCondition)>] = [wrap(matchable: data) { $0 }]
            return cuckoo_manager.verify("getSearchResult(data: SearchCondition) -> Observable<SearchResultEntity>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class StreamApiStub: StreamApi {
    

    

    
     func loadStreamBy(pageId: String, fromIndex: Int, numberOfItems: Int)  -> Observable<StreamEntity> {
        return DefaultValueRegistry.defaultValue(for: Observable<StreamEntity>.self)
    }
    
     func loadHomeStreamWith(timeOffset: Int, fromIndex: Int, numberOfItems: Int)  -> Observable<HomeStreamEntity> {
        return DefaultValueRegistry.defaultValue(for: Observable<HomeStreamEntity>.self)
    }
    
     func loadVideoStreamWith(timeOffset: Int, fromIndex: Int, numberOfItems: Int)  -> Observable<HomeStreamEntity> {
        return DefaultValueRegistry.defaultValue(for: Observable<HomeStreamEntity>.self)
    }
    
     func getSearchResult(data: SearchCondition)  -> Observable<SearchResultEntity> {
        return DefaultValueRegistry.defaultValue(for: Observable<SearchResultEntity>.self)
    }
    
}




// MARK: - Mocks generated from file: MBC/data/api/PageDetailApi.swift at 2018-03-17 12:42:56 +0000

//
//  PageDetailApi.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 11/29/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Cuckoo
@testable import MBC

import Foundation
import RxSwift

class MockPageDetailApi: PageDetailApi, Cuckoo.Mock {
    typealias MocksType = PageDetailApi
    typealias Stubbing = __StubbingProxy_PageDetailApi
    typealias Verification = __VerificationProxy_PageDetailApi
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: PageDetailApi?

    func spy(on victim: PageDetailApi) -> Self {
        observed = victim
        return self
    }

    

    

    
    // ["name": "getPageDetailBy", "returnSignature": " -> Observable<PageDetailEntity>", "fullyQualifiedName": "getPageDetailBy(pageId: String) -> Observable<PageDetailEntity>", "parameterSignature": "pageId: String", "parameterSignatureWithoutNames": "pageId: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageId", "call": "pageId: pageId", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageId"), name: "pageId", type: "String", range: CountableRange(253..<267), nameRange: CountableRange(253..<259))], "returnType": "Observable<PageDetailEntity>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func getPageDetailBy(pageId: String)  -> Observable<PageDetailEntity> {
        
            return cuckoo_manager.call("getPageDetailBy(pageId: String) -> Observable<PageDetailEntity>",
                parameters: (pageId),
                original: observed.map { o in
                    return { (args) -> Observable<PageDetailEntity> in
                        let (pageId) = args
                        return o.getPageDetailBy(pageId: pageId)
                    }
                })
        
    }
    

    struct __StubbingProxy_PageDetailApi: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func getPageDetailBy<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.StubFunction<(String), Observable<PageDetailEntity>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return .init(stub: cuckoo_manager.createStub("getPageDetailBy(pageId: String) -> Observable<PageDetailEntity>", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_PageDetailApi: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func getPageDetailBy<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.__DoNotUse<Observable<PageDetailEntity>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return cuckoo_manager.verify("getPageDetailBy(pageId: String) -> Observable<PageDetailEntity>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class PageDetailApiStub: PageDetailApi {
    

    

    
     func getPageDetailBy(pageId: String)  -> Observable<PageDetailEntity> {
        return DefaultValueRegistry.defaultValue(for: Observable<PageDetailEntity>.self)
    }
    
}




// MARK: - Mocks generated from file: MBC/data/api/PageApi.swift at 2018-03-17 12:42:56 +0000

//
//  PageApi.swift
//  MBC
//
//  Created by Dao Le Quang on 11/23/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Cuckoo
@testable import MBC

import Foundation
import RxSwift

class MockPageApi: PageApi, Cuckoo.Mock {
    typealias MocksType = PageApi
    typealias Stubbing = __StubbingProxy_PageApi
    typealias Verification = __VerificationProxy_PageApi
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: PageApi?

    func spy(on victim: PageApi) -> Self {
        observed = victim
        return self
    }

    

    

    
    // ["name": "getFeaturePagesBy", "returnSignature": " -> Observable<[PageEntity]>", "fullyQualifiedName": "getFeaturePagesBy(siteName: String) -> Observable<[PageEntity]>", "parameterSignature": "siteName: String", "parameterSignatureWithoutNames": "siteName: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "siteName", "call": "siteName: siteName", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("siteName"), name: "siteName", type: "String", range: CountableRange(335..<351), nameRange: CountableRange(335..<343))], "returnType": "Observable<[PageEntity]>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func getFeaturePagesBy(siteName: String)  -> Observable<[PageEntity]> {
        
            return cuckoo_manager.call("getFeaturePagesBy(siteName: String) -> Observable<[PageEntity]>",
                parameters: (siteName),
                original: observed.map { o in
                    return { (args) -> Observable<[PageEntity]> in
                        let (siteName) = args
                        return o.getFeaturePagesBy(siteName: siteName)
                    }
                })
        
    }
    

    struct __StubbingProxy_PageApi: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func getFeaturePagesBy<M1: Cuckoo.Matchable>(siteName: M1) -> Cuckoo.StubFunction<(String), Observable<[PageEntity]>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: siteName) { $0 }]
            return .init(stub: cuckoo_manager.createStub("getFeaturePagesBy(siteName: String) -> Observable<[PageEntity]>", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_PageApi: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func getFeaturePagesBy<M1: Cuckoo.Matchable>(siteName: M1) -> Cuckoo.__DoNotUse<Observable<[PageEntity]>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: siteName) { $0 }]
            return cuckoo_manager.verify("getFeaturePagesBy(siteName: String) -> Observable<[PageEntity]>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class PageApiStub: PageApi {
    

    

    
     func getFeaturePagesBy(siteName: String)  -> Observable<[PageEntity]> {
        return DefaultValueRegistry.defaultValue(for: Observable<[PageEntity]>.self)
    }
    
}




// MARK: - Mocks generated from file: MBC/data/api/PageAlbumApi.swift at 2018-03-17 12:42:56 +0000

//
//  PageAlbumApi.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/11/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Cuckoo
@testable import MBC

import Foundation
import RxSwift

class MockPageAlbumApi: PageAlbumApi, Cuckoo.Mock {
    typealias MocksType = PageAlbumApi
    typealias Stubbing = __StubbingProxy_PageAlbumApi
    typealias Verification = __VerificationProxy_PageAlbumApi
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: PageAlbumApi?

    func spy(on victim: PageAlbumApi) -> Self {
        observed = victim
        return self
    }

    

    

    
    // ["name": "loadAlbumOf", "returnSignature": " -> Observable<AlbumEntity>", "fullyQualifiedName": "loadAlbumOf(pageId: String, albumId: String?, fromIndex: Int, numberOfItems: Int) -> Observable<AlbumEntity>", "parameterSignature": "pageId: String, albumId: String?, fromIndex: Int, numberOfItems: Int", "parameterSignatureWithoutNames": "pageId: String, albumId: String?, fromIndex: Int, numberOfItems: Int", "inputTypes": "String, String?, Int, Int", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageId, albumId, fromIndex, numberOfItems", "call": "pageId: pageId, albumId: albumId, fromIndex: fromIndex, numberOfItems: numberOfItems", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageId"), name: "pageId", type: "String", range: CountableRange(214..<228), nameRange: CountableRange(214..<220)), CuckooGeneratorFramework.MethodParameter(label: Optional("albumId"), name: "albumId", type: "String?", range: CountableRange(230..<246), nameRange: CountableRange(230..<237)), CuckooGeneratorFramework.MethodParameter(label: Optional("fromIndex"), name: "fromIndex", type: "Int", range: CountableRange(275..<289), nameRange: CountableRange(275..<284)), CuckooGeneratorFramework.MethodParameter(label: Optional("numberOfItems"), name: "numberOfItems", type: "Int", range: CountableRange(291..<309), nameRange: CountableRange(291..<304))], "returnType": "Observable<AlbumEntity>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func loadAlbumOf(pageId: String, albumId: String?, fromIndex: Int, numberOfItems: Int)  -> Observable<AlbumEntity> {
        
            return cuckoo_manager.call("loadAlbumOf(pageId: String, albumId: String?, fromIndex: Int, numberOfItems: Int) -> Observable<AlbumEntity>",
                parameters: (pageId, albumId, fromIndex, numberOfItems),
                original: observed.map { o in
                    return { (args) -> Observable<AlbumEntity> in
                        let (pageId, albumId, fromIndex, numberOfItems) = args
                        return o.loadAlbumOf(pageId: pageId, albumId: albumId, fromIndex: fromIndex, numberOfItems: numberOfItems)
                    }
                })
        
    }
    
    // ["name": "loadAlbums", "returnSignature": " -> Observable<[AlbumEntity]>", "fullyQualifiedName": "loadAlbums(pageId: String) -> Observable<[AlbumEntity]>", "parameterSignature": "pageId: String", "parameterSignatureWithoutNames": "pageId: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageId", "call": "pageId: pageId", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageId"), name: "pageId", type: "String", range: CountableRange(358..<372), nameRange: CountableRange(358..<364))], "returnType": "Observable<[AlbumEntity]>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func loadAlbums(pageId: String)  -> Observable<[AlbumEntity]> {
        
            return cuckoo_manager.call("loadAlbums(pageId: String) -> Observable<[AlbumEntity]>",
                parameters: (pageId),
                original: observed.map { o in
                    return { (args) -> Observable<[AlbumEntity]> in
                        let (pageId) = args
                        return o.loadAlbums(pageId: pageId)
                    }
                })
        
    }
    
    // ["name": "loadNextAlbum", "returnSignature": " -> Observable<AlbumEntity>", "fullyQualifiedName": "loadNextAlbum(pageId: String, currentAlbumContentId: String, publishDate: String, isNextAlbum: Bool) -> Observable<AlbumEntity>", "parameterSignature": "pageId: String, currentAlbumContentId: String, publishDate: String, isNextAlbum: Bool", "parameterSignatureWithoutNames": "pageId: String, currentAlbumContentId: String, publishDate: String, isNextAlbum: Bool", "inputTypes": "String, String, String, Bool", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageId, currentAlbumContentId, publishDate, isNextAlbum", "call": "pageId: pageId, currentAlbumContentId: currentAlbumContentId, publishDate: publishDate, isNextAlbum: isNextAlbum", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageId"), name: "pageId", type: "String", range: CountableRange(423..<437), nameRange: CountableRange(423..<429)), CuckooGeneratorFramework.MethodParameter(label: Optional("currentAlbumContentId"), name: "currentAlbumContentId", type: "String", range: CountableRange(439..<468), nameRange: CountableRange(439..<460)), CuckooGeneratorFramework.MethodParameter(label: Optional("publishDate"), name: "publishDate", type: "String", range: CountableRange(478..<497), nameRange: CountableRange(478..<489)), CuckooGeneratorFramework.MethodParameter(label: Optional("isNextAlbum"), name: "isNextAlbum", type: "Bool", range: CountableRange(499..<516), nameRange: CountableRange(499..<510))], "returnType": "Observable<AlbumEntity>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func loadNextAlbum(pageId: String, currentAlbumContentId: String, publishDate: String, isNextAlbum: Bool)  -> Observable<AlbumEntity> {
        
            return cuckoo_manager.call("loadNextAlbum(pageId: String, currentAlbumContentId: String, publishDate: String, isNextAlbum: Bool) -> Observable<AlbumEntity>",
                parameters: (pageId, currentAlbumContentId, publishDate, isNextAlbum),
                original: observed.map { o in
                    return { (args) -> Observable<AlbumEntity> in
                        let (pageId, currentAlbumContentId, publishDate, isNextAlbum) = args
                        return o.loadNextAlbum(pageId: pageId, currentAlbumContentId: currentAlbumContentId, publishDate: publishDate, isNextAlbum: isNextAlbum)
                    }
                })
        
    }
    
    // ["name": "loadDescriptionOfPost", "returnSignature": " -> Observable<AlbumEntity>", "fullyQualifiedName": "loadDescriptionOfPost(pageId: String, postId: String, page: Int, pageSize: Int, damId: String) -> Observable<AlbumEntity>", "parameterSignature": "pageId: String, postId: String, page: Int, pageSize: Int, damId: String", "parameterSignatureWithoutNames": "pageId: String, postId: String, page: Int, pageSize: Int, damId: String", "inputTypes": "String, String, Int, Int, String", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "pageId, postId, page, pageSize, damId", "call": "pageId: pageId, postId: postId, page: page, pageSize: pageSize, damId: damId", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("pageId"), name: "pageId", type: "String", range: CountableRange(573..<587), nameRange: CountableRange(573..<579)), CuckooGeneratorFramework.MethodParameter(label: Optional("postId"), name: "postId", type: "String", range: CountableRange(589..<603), nameRange: CountableRange(589..<595)), CuckooGeneratorFramework.MethodParameter(label: Optional("page"), name: "page", type: "Int", range: CountableRange(615..<624), nameRange: CountableRange(615..<619)), CuckooGeneratorFramework.MethodParameter(label: Optional("pageSize"), name: "pageSize", type: "Int", range: CountableRange(626..<639), nameRange: CountableRange(626..<634)), CuckooGeneratorFramework.MethodParameter(label: Optional("damId"), name: "damId", type: "String", range: CountableRange(641..<654), nameRange: CountableRange(641..<646))], "returnType": "Observable<AlbumEntity>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func loadDescriptionOfPost(pageId: String, postId: String, page: Int, pageSize: Int, damId: String)  -> Observable<AlbumEntity> {
        
            return cuckoo_manager.call("loadDescriptionOfPost(pageId: String, postId: String, page: Int, pageSize: Int, damId: String) -> Observable<AlbumEntity>",
                parameters: (pageId, postId, page, pageSize, damId),
                original: observed.map { o in
                    return { (args) -> Observable<AlbumEntity> in
                        let (pageId, postId, page, pageSize, damId) = args
                        return o.loadDescriptionOfPost(pageId: pageId, postId: postId, page: page, pageSize: pageSize, damId: damId)
                    }
                })
        
    }
    

    struct __StubbingProxy_PageAlbumApi: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func loadAlbumOf<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(pageId: M1, albumId: M2, fromIndex: M3, numberOfItems: M4) -> Cuckoo.StubFunction<(String, String?, Int, Int), Observable<AlbumEntity>> where M1.MatchedType == String, M2.MatchedType == String?, M3.MatchedType == Int, M4.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(String, String?, Int, Int)>] = [wrap(matchable: pageId) { $0.0 }, wrap(matchable: albumId) { $0.1 }, wrap(matchable: fromIndex) { $0.2 }, wrap(matchable: numberOfItems) { $0.3 }]
            return .init(stub: cuckoo_manager.createStub("loadAlbumOf(pageId: String, albumId: String?, fromIndex: Int, numberOfItems: Int) -> Observable<AlbumEntity>", parameterMatchers: matchers))
        }
        
        func loadAlbums<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.StubFunction<(String), Observable<[AlbumEntity]>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return .init(stub: cuckoo_manager.createStub("loadAlbums(pageId: String) -> Observable<[AlbumEntity]>", parameterMatchers: matchers))
        }
        
        func loadNextAlbum<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(pageId: M1, currentAlbumContentId: M2, publishDate: M3, isNextAlbum: M4) -> Cuckoo.StubFunction<(String, String, String, Bool), Observable<AlbumEntity>> where M1.MatchedType == String, M2.MatchedType == String, M3.MatchedType == String, M4.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(String, String, String, Bool)>] = [wrap(matchable: pageId) { $0.0 }, wrap(matchable: currentAlbumContentId) { $0.1 }, wrap(matchable: publishDate) { $0.2 }, wrap(matchable: isNextAlbum) { $0.3 }]
            return .init(stub: cuckoo_manager.createStub("loadNextAlbum(pageId: String, currentAlbumContentId: String, publishDate: String, isNextAlbum: Bool) -> Observable<AlbumEntity>", parameterMatchers: matchers))
        }
        
        func loadDescriptionOfPost<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable>(pageId: M1, postId: M2, page: M3, pageSize: M4, damId: M5) -> Cuckoo.StubFunction<(String, String, Int, Int, String), Observable<AlbumEntity>> where M1.MatchedType == String, M2.MatchedType == String, M3.MatchedType == Int, M4.MatchedType == Int, M5.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String, Int, Int, String)>] = [wrap(matchable: pageId) { $0.0 }, wrap(matchable: postId) { $0.1 }, wrap(matchable: page) { $0.2 }, wrap(matchable: pageSize) { $0.3 }, wrap(matchable: damId) { $0.4 }]
            return .init(stub: cuckoo_manager.createStub("loadDescriptionOfPost(pageId: String, postId: String, page: Int, pageSize: Int, damId: String) -> Observable<AlbumEntity>", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_PageAlbumApi: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func loadAlbumOf<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(pageId: M1, albumId: M2, fromIndex: M3, numberOfItems: M4) -> Cuckoo.__DoNotUse<Observable<AlbumEntity>> where M1.MatchedType == String, M2.MatchedType == String?, M3.MatchedType == Int, M4.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(String, String?, Int, Int)>] = [wrap(matchable: pageId) { $0.0 }, wrap(matchable: albumId) { $0.1 }, wrap(matchable: fromIndex) { $0.2 }, wrap(matchable: numberOfItems) { $0.3 }]
            return cuckoo_manager.verify("loadAlbumOf(pageId: String, albumId: String?, fromIndex: Int, numberOfItems: Int) -> Observable<AlbumEntity>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func loadAlbums<M1: Cuckoo.Matchable>(pageId: M1) -> Cuckoo.__DoNotUse<Observable<[AlbumEntity]>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pageId) { $0 }]
            return cuckoo_manager.verify("loadAlbums(pageId: String) -> Observable<[AlbumEntity]>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func loadNextAlbum<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(pageId: M1, currentAlbumContentId: M2, publishDate: M3, isNextAlbum: M4) -> Cuckoo.__DoNotUse<Observable<AlbumEntity>> where M1.MatchedType == String, M2.MatchedType == String, M3.MatchedType == String, M4.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(String, String, String, Bool)>] = [wrap(matchable: pageId) { $0.0 }, wrap(matchable: currentAlbumContentId) { $0.1 }, wrap(matchable: publishDate) { $0.2 }, wrap(matchable: isNextAlbum) { $0.3 }]
            return cuckoo_manager.verify("loadNextAlbum(pageId: String, currentAlbumContentId: String, publishDate: String, isNextAlbum: Bool) -> Observable<AlbumEntity>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func loadDescriptionOfPost<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable>(pageId: M1, postId: M2, page: M3, pageSize: M4, damId: M5) -> Cuckoo.__DoNotUse<Observable<AlbumEntity>> where M1.MatchedType == String, M2.MatchedType == String, M3.MatchedType == Int, M4.MatchedType == Int, M5.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String, Int, Int, String)>] = [wrap(matchable: pageId) { $0.0 }, wrap(matchable: postId) { $0.1 }, wrap(matchable: page) { $0.2 }, wrap(matchable: pageSize) { $0.3 }, wrap(matchable: damId) { $0.4 }]
            return cuckoo_manager.verify("loadDescriptionOfPost(pageId: String, postId: String, page: Int, pageSize: Int, damId: String) -> Observable<AlbumEntity>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class PageAlbumApiStub: PageAlbumApi {
    

    

    
     func loadAlbumOf(pageId: String, albumId: String?, fromIndex: Int, numberOfItems: Int)  -> Observable<AlbumEntity> {
        return DefaultValueRegistry.defaultValue(for: Observable<AlbumEntity>.self)
    }
    
     func loadAlbums(pageId: String)  -> Observable<[AlbumEntity]> {
        return DefaultValueRegistry.defaultValue(for: Observable<[AlbumEntity]>.self)
    }
    
     func loadNextAlbum(pageId: String, currentAlbumContentId: String, publishDate: String, isNextAlbum: Bool)  -> Observable<AlbumEntity> {
        return DefaultValueRegistry.defaultValue(for: Observable<AlbumEntity>.self)
    }
    
     func loadDescriptionOfPost(pageId: String, postId: String, page: Int, pageSize: Int, damId: String)  -> Observable<AlbumEntity> {
        return DefaultValueRegistry.defaultValue(for: Observable<AlbumEntity>.self)
    }
    
}




// MARK: - Mocks generated from file: MBC/data/api/LanguageConfigApi.swift at 2018-03-17 12:42:56 +0000

//
//  LanguageConfigApi.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/18/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Cuckoo
@testable import MBC

import Foundation
import RxSwift

class MockLanguageConfigApi: LanguageConfigApi, Cuckoo.Mock {
    typealias MocksType = LanguageConfigApi
    typealias Stubbing = __StubbingProxy_LanguageConfigApi
    typealias Verification = __VerificationProxy_LanguageConfigApi
    let cuckoo_manager = Cuckoo.MockManager()

    private var observed: LanguageConfigApi?

    func spy(on victim: LanguageConfigApi) -> Self {
        observed = victim
        return self
    }

    

    

    
    // ["name": "getLanguageConfig", "returnSignature": " -> Observable<LanguageConfigListEntity>", "fullyQualifiedName": "getLanguageConfig(name: String) -> Observable<LanguageConfigListEntity>", "parameterSignature": "name: String", "parameterSignatureWithoutNames": "name: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "name", "call": "name: name", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("name"), name: "name", type: "String", range: CountableRange(230..<242), nameRange: CountableRange(230..<234))], "returnType": "Observable<LanguageConfigListEntity>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func getLanguageConfig(name: String)  -> Observable<LanguageConfigListEntity> {
        
            return cuckoo_manager.call("getLanguageConfig(name: String) -> Observable<LanguageConfigListEntity>",
                parameters: (name),
                original: observed.map { o in
                    return { (args) -> Observable<LanguageConfigListEntity> in
                        let (name) = args
                        return o.getLanguageConfig(name: name)
                    }
                })
        
    }
    
    // ["name": "getCityList", "returnSignature": " -> Observable<LanguageConfigListEntity>", "fullyQualifiedName": "getCityList(countryCode: String) -> Observable<LanguageConfigListEntity>", "parameterSignature": "countryCode: String", "parameterSignatureWithoutNames": "countryCode: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "countryCode", "call": "countryCode: countryCode", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("countryCode"), name: "countryCode", type: "String", range: CountableRange(305..<324), nameRange: CountableRange(305..<316))], "returnType": "Observable<LanguageConfigListEntity>", "isOptional": false, "stubFunction": "Cuckoo.StubFunction"]
     func getCityList(countryCode: String)  -> Observable<LanguageConfigListEntity> {
        
            return cuckoo_manager.call("getCityList(countryCode: String) -> Observable<LanguageConfigListEntity>",
                parameters: (countryCode),
                original: observed.map { o in
                    return { (args) -> Observable<LanguageConfigListEntity> in
                        let (countryCode) = args
                        return o.getCityList(countryCode: countryCode)
                    }
                })
        
    }
    

    struct __StubbingProxy_LanguageConfigApi: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager

        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func getLanguageConfig<M1: Cuckoo.Matchable>(name: M1) -> Cuckoo.StubFunction<(String), Observable<LanguageConfigListEntity>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: name) { $0 }]
            return .init(stub: cuckoo_manager.createStub("getLanguageConfig(name: String) -> Observable<LanguageConfigListEntity>", parameterMatchers: matchers))
        }
        
        func getCityList<M1: Cuckoo.Matchable>(countryCode: M1) -> Cuckoo.StubFunction<(String), Observable<LanguageConfigListEntity>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: countryCode) { $0 }]
            return .init(stub: cuckoo_manager.createStub("getCityList(countryCode: String) -> Observable<LanguageConfigListEntity>", parameterMatchers: matchers))
        }
        
    }


    struct __VerificationProxy_LanguageConfigApi: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation

        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }

        

        
        @discardableResult
        func getLanguageConfig<M1: Cuckoo.Matchable>(name: M1) -> Cuckoo.__DoNotUse<Observable<LanguageConfigListEntity>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: name) { $0 }]
            return cuckoo_manager.verify("getLanguageConfig(name: String) -> Observable<LanguageConfigListEntity>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func getCityList<M1: Cuckoo.Matchable>(countryCode: M1) -> Cuckoo.__DoNotUse<Observable<LanguageConfigListEntity>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: countryCode) { $0 }]
            return cuckoo_manager.verify("getCityList(countryCode: String) -> Observable<LanguageConfigListEntity>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }


}

 class LanguageConfigApiStub: LanguageConfigApi {
    

    

    
     func getLanguageConfig(name: String)  -> Observable<LanguageConfigListEntity> {
        return DefaultValueRegistry.defaultValue(for: Observable<LanguageConfigListEntity>.self)
    }
    
     func getCityList(countryCode: String)  -> Observable<LanguageConfigListEntity> {
        return DefaultValueRegistry.defaultValue(for: Observable<LanguageConfigListEntity>.self)
    }
    
}



