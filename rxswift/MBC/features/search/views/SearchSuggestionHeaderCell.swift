//
//  SearchSuggestionHeaderCell.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/28/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class SearchSuggestionHeaderCell: BaseTableViewCell {
    @IBOutlet weak private var deleteButton: UIButton!
    @IBOutlet weak private var historiesButton: UIButton!
    
    var onDeleteButtonClicked = PublishSubject<Void>()
    var onHistoriesButtonClicked = PublishSubject<Void>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        deleteButton.setTitle(R.string.localizable.searchSuggestionDeleteTitle(), for: .normal)
        historiesButton.setTitle(R.string.localizable.searchSuggestionHistoryTitle(), for: .normal)
    }
    
    // MARK: - Action
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        self.onDeleteButtonClicked.onNext(())
    }
    
    @IBAction func historiesButtonClicked(_ sender: Any) {
        self.onHistoriesButtonClicked.onNext(())
    }
}
