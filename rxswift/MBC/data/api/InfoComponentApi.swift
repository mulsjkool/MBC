//
//  InfoComponentApi.swift
//  MBC
//
//  Created by Dung Nguyen on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol InfoComponentApi {
    func getInfoComponentById(pageId: String) -> Observable<[InfoComponentEntity]>
}
