//
//  SchedulerAllChannelsInteractor.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 3/20/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol SchedulerAllChannelsInteractor {
    func getShedulersAllChannel(fromTime: Double, toTime: Double) -> Observable<[SchedulerOnChannel]>
    
    var onErrorLoadItems: Observable<Error> { get }
}
