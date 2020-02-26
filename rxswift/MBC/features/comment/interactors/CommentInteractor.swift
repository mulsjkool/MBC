//
//  CommentInteractor.swift
//  MBC
//
//  Created by Tri Vo on 2/3/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

protocol CommentInteractor {
    func getComments(data: CommentSocial) -> Observable<[Comment]>
    func getCurrentUser() -> UserProfile?
}
