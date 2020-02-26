//
//  TaggedPagesService.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/25/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol TaggedPagesService {
    func getTaggedPagesFrom(media: Media) -> Observable<Media>
}
