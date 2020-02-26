//
//  TaggedPagesApi.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/21/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol TaggedPagesApi {
    func getTaggedPagesFrom(media: Media) -> Observable<[PageEntity]>
}
