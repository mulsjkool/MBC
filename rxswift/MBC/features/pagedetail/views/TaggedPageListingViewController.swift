//
//  TaggedPageListingViewController.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/22/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class TaggedPageListingViewController: BaseViewController {

    @IBOutlet weak private var tableView: UITableView!
    
    var authorList: [Author] = [Author]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindEvents()
    }
    
    // MARK: Private functions
    private func bindEvents() {
//        disposeBag.addDisposables([
//            closeButton.rx.tap.subscribe(onNext: { [unowned self] _ in
//                self.dismiss(animated: true, completion: nil)
//            })
//        ])
    }
    
    private func setupUI() {
        title = R.string.localizable.taggedPageListingTitle()
        addCloseButton()
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(R.nib.taggedPageListingCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.taggedPageListingCell.identifier)
    }
}

extension TaggedPageListingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.taggedPageListingCell.identifier) as? TaggedPageListingCell {
            cell.bindData(author: authorList[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let author = authorList[indexPath.row]
        navigator?.pushPageDetail(pageUrl: author.universalUrl, pageId: author.authorId)
    }
}
