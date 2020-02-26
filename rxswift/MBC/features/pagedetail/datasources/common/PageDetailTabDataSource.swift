//
//  PageDetailTabDataSource.swift
//  MBC
//
//  Created by Tram Nguyen on 2/24/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

protocol PageDetailTabDataSource {
    var dummyCell: UITableViewCell { get }
    
    func cellForIndexPath(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}
