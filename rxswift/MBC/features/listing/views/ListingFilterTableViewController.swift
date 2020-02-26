//
//  ListingFilterTableViewController.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/14/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class ListingFilterTableViewController: UITableViewController {

    var viewModel = ListingFilterTableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private functions
    
    func setupUI() {
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0
        tableView.backgroundColor = Colors.white.color()
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(R.nib.contentFilterCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.contentFilterCellId.identifier)
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel.filter != nil) ? viewModel.filter!.getItemsForCurrentFilter().count : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.contentFilterCellId.identifier)
            as? ContentFilterCell {
            let text = (viewModel.filter != nil) ? viewModel.filter!.getItemsForCurrentFilter()[indexPath.row] : ""
            let isTextHighlighted = viewModel.filter!.getSelectedItemIndexForFilter(index:
                viewModel.filter!.activeFilterMode.rawValue) == indexPath.row
            cell.bindData(text: text, isTextHighlighted: isTextHighlighted)
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectRow(index: indexPath.row)
    }
}
