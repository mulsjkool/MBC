//
//  SearchSuggestionTableViewController.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/26/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class SearchSuggestionTableViewController: UITableViewController {
    
    var disposeBag = DisposeBag()
    private var viewModel = SearchSuggestionViewModel(interactor: Components.searchInteractor())
    private var searchText: String = ""
    
    private let heightRowCell: CGFloat = 73.0
    private let heightHeaderCell: CGFloat = 30.0
    private let heightFooterCell: CGFloat = 47.0
    
    var onCellClicked = PublishSubject<SearchSuggestion>()
    var onFooterCellClicked = PublishSubject<String>()
    var onDeleteHistoriesClicked = PublishSubject<Void>()
    var onShowHistoriesClicked = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindEvents()
    }

    func getGetSearchSuggestion(searchText: String) {
        self.searchText = searchText
        if self.searchText.isEmpty {
            viewModel.setArraySearchSuggestion(array: [SearchSuggestion]())
            self.tableView.reloadData()
        } else {
            viewModel.getGetSearchSuggestion(searchText: searchText)
        }
    }

    // MARK: - Private functions
    
    private func setupUI() {
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.rowHeight = heightRowCell
        tableView.backgroundColor = Colors.defaultBg.color()
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(R.nib.searchSuggestionCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.searchSuggestionCellId.identifier)
        tableView.register(R.nib.searchSuggestionFooterCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.searchSuggestionFooterCellId.identifier)
        tableView.register(R.nib.searchSuggestionHeaderCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.searchSuggestionHeaderCellId.identifier)
    }
    
    // MARK: - Events
    
    private func bindEvents() {
        disposeBag.addDisposables([
            viewModel.onFinishGetSearchSuggestion.subscribe(onNext: { [unowned self] _ in
                self.tableView.reloadData()
            })
        ])
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //This function is removed with current version of app
//        if viewModel.arraySearchSuggestion.isEmpty {
//            return CGFloat.leastNormalMagnitude
//        } else { return heightHeaderCell }
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if viewModel.arraySearchSuggestion.isEmpty {
            return CGFloat.leastNormalMagnitude
        } else { return heightFooterCell }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arraySearchSuggestion.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.searchSuggestionCellId.identifier)
            as? SearchSuggestionCell {
            let item = viewModel.arraySearchSuggestion[indexPath.row]
            cell.bindData(searchSuggestion: item)
            cell.disposeBag.addDisposables([
                cell.didTapCell.subscribe(onNext: { [unowned self] item in
                    self.onCellClicked.onNext(item)
                })
            ])
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //This function is removed with current version of app
//        if !viewModel.arraySearchSuggestion.isEmpty {
//            if let cell = tableView.dequeueReusableCell(withIdentifier:
//                R.reuseIdentifier.searchSuggestionHeaderCellId.identifier) as? SearchSuggestionHeaderCell {
//                cell.disposeBag.addDisposables([
//                    cell.onDeleteButtonClicked.subscribe(onNext: { [unowned self] _ in
//                        self.onDeleteHistoriesClicked.onNext(())
//                    }),
//                    cell.onHistoriesButtonClicked.subscribe(onNext: { [unowned self] _ in
//                        self.onShowHistoriesClicked.onNext(())
//                    })
//                ])
//                return cell
//            }
//        }
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if !viewModel.arraySearchSuggestion.isEmpty {
            if let cell = tableView.dequeueReusableCell(withIdentifier:
                R.reuseIdentifier.searchSuggestionFooterCellId.identifier) as? SearchSuggestionFooterCell {
                cell.bindData(searchText: self.searchText)
                cell.disposeBag.addDisposables([
                    cell.didTapCell.subscribe(onNext: { [unowned self] searchText in
                        self.onFooterCellClicked.onNext(searchText)
                    })
                ])
                return cell
            }
        }
        return UIView()
    }
}
