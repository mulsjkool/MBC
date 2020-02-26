//
//  AnalyticsServiceImpl.swift
//  MBC
//
//  Created by Tram Nguyen on 1/29/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import Firebase

class AnalyticsServiceImpl {

    private let percentInvisibleInViewport = CGFloat(0.2)
    private var loggedIDs: [String] = []
    private var dataLayer: [String: String] = [:]

    init(sessionService: SessionService) {
        _ = sessionService.currentUser.asObservable().subscribe(onNext: { user in
            Analytics.setUserID(user?.uid)
            if user?.uid == nil {
                self.loggedIDs = []
                self.dataLayer = [:]
            }
        })
    }

    var customTargeting: [String: String] {
        return dataLayer
    }
    
    func isNotLogged(id: String?) -> Bool {
        guard let id = id else { return true }
        return loggedIDs.contains(id) == false
    }
    
    private func setLogged(id: String?) {
        guard let id = id else { return }
        loggedIDs.append(id)
    }
    
    private func getTrackingObjects(cell: UITableViewCell) -> [IAnalyticsTrackingObject] {
        guard let trackingCell = cell as? IAnalyticsTrackingCell else {
            return []
        }
        
        guard isVisibleCell(cell: cell) else {
            return []
        }
        
        return trackingCell.getTrackingObjects()
    }
    
    private func isVisibleCell(cell: UITableViewCell) -> Bool {
        guard let rootView = UIApplication.shared.keyWindow?.rootViewController?.view else { return false }

        let screenHeight = UIScreen.main.bounds.height
        let cellBound = rootView.convert(cell.bounds, from: cell)
        let cellMinHeight = cellBound.height * percentInvisibleInViewport
        
        if cellBound.minX < 0 {
            return false
        }
        
        if cellBound.maxX > UIScreen.main.bounds.width {
            return false
        }

        if cellBound.minY > 0 {
            if cellBound.maxY - cellMinHeight <= screenHeight {
                return true
            }
        } else {
            if cellBound.height + cellBound.minY - cellMinHeight <= screenHeight {
                return true
            }
        }
        
        return false
    }

}

extension AnalyticsServiceImpl: AnalyticsService {

    func logEvent(trackingObject: IAnalyticsTrackingObject) {
        dataLayer += trackingObject.customTargeting

        guard isNotLogged(id: trackingObject.contendID) else { return }

        Analytics.logEvent(trackingObject.eventName, parameters: trackingObject.parameters)

        setLogged(id: trackingObject.contendID)
    }

    func logCells(visibleCells: [UITableViewCell]) {
        visibleCells.forEach { cell in
            getTrackingObjects(cell: cell).forEach({ obj in
                logEvent(trackingObject: obj)
            })
        }
    }

}
