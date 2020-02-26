//
//  SearchBarContainerView.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/8/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import BadgeSwift
import Foundation
import MisterFusion
import UIKit
import RxSwift

class SearchBarContainerView: UIView {
    
    let searchBar: BaseSearchBar
    private let navBarItem: UINavigationItem!
    private let badgeTag = 101
    private var defaultTitleView: UIView!
    private var isFirstLoad = true
    private var searchBarMargin: CGFloat = 0
    private var magnifyImage: UIImageView?
    private var magnifyYConstraint: NSLayoutConstraint?
    
    var onShouldBeginSearching = PublishSubject<Void>()
    var onDidBeginSearching = PublishSubject<Void>()
    var onShouldEndSearching = PublishSubject<Void>()
    var onDidEndSearching = PublishSubject<String?>()
    var onDidCancelSearching = PublishSubject<Void>()
    var onTextDidChangeSearching = PublishSubject<(String)>()
    var onSearchButtonClicked = PublishSubject<(String?)>()
    
    init(customSearchBar: BaseSearchBar, navBarItem: UINavigationItem) {
        searchBar = customSearchBar
        self.navBarItem = navBarItem
        super.init(frame: Constants.DeviceMetric.searchDefaultFrame)
        if searchBar.isEditing { frame = Constants.DeviceMetric.searchExpandedFrame }
        
        setupSearchBar()
        setUpSearchBarButtons()
        
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        searchBar = BaseSearchBar()
        navBarItem = UINavigationItem()
        
        super.init(coder: aDecoder)
        addSubview(searchBar)
    }
    
    // MARK: Public functions
    var showsCancelButton: Bool = false {
        didSet {
            searchBar.showsCancelButton = showsCancelButton
            if showsCancelButton {
                navBarItem.leftBarButtonItem = nil
                navBarItem.leftBarButtonItems = []
                navBarItem.rightBarButtonItem = nil
                navBarItem.rightBarButtonItems = []
            } else {
                setUpSearchBarButtons()
            }
        }
    }
    
    func hide() {
        navBarItem.leftBarButtonItem = nil
        navBarItem.leftBarButtonItems = []
        navBarItem.rightBarButtonItem = nil
        navBarItem.rightBarButtonItems = []
        
        removeFromSuperview()
        navBarItem.titleView = defaultTitleView
    }
    
    func show() {
        navBarItem.titleView = self
        setUpSearchBarButtons()
    }
    
    func didBeginEditing() {
        showsCancelButton = true
    }
    
    func didEndEditing() {
        showsCancelButton = false
    }
    
    // TO BE UPDATED THE DEFAULT NUMBER
    var badgeNumber: Int = 0 {
        didSet {
            guard
                let notifButton = navBarItem.rightBarButtonItem,
                let subviews = notifButton.customView?.subviews
            else { return }
            
            let badges = subviews.filter { $0.tag == badgeTag && $0 is BadgeSwift }
            if let badge = badges.first {
                // swiftlint:disable force_cast
                let badgeSwift = badge as! BadgeSwift
                badgeSwift.text = "\(badgeNumber)"
                badgeSwift.isHidden = badgeNumber == 0
            }
        }
    }
	
	func setSearchText(text: String) {
		searchBar.text = text
		showsCancelButton = true
		
		if let cancelButton = searchBar.cancelButton { cancelButton.isEnabled = true }
	}
	
    // MARK: Private functions
    private func setupSearchBar() {
        defaultTitleView = navBarItem.titleView
        
        addSubview(searchBar)
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage.imageWithColor(color: Colors.dark.color())
        
        searchBar.searchBarStyle = .prominent
        searchBar.isTranslucent = false
        searchBar.tintColor = Colors.white.color()
        searchBar.barTintColor = Colors.white.color(alpha: 0.2)
        searchBar.backgroundColor = UIColor.clear
        searchBar.showsCancelButton = false
    }
    
    private func setUpSearchBarButtons() {
        let rightBarButton = UIButton(type: .custom)
        let bellBtnWidth = Constants.DeviceMetric.navBarButtonWidthBell
        rightBarButton.frame = CGRect(x: 0, y: 0, width: bellBtnWidth, height: bellBtnWidth)
        rightBarButton.setImage(R.image.iconNavigationBell(), for: .normal)
        let rightBoundsView = UIView(frame: rightBarButton.frame)
        rightBoundsView.bounds = rightBoundsView.bounds.offsetBy(dx: Constants.DeviceMetric.navBarSearchBarMargin / 2,
                                                                 dy: 0)
        rightBoundsView.addSubview(rightBarButton)

        let rightButtonItem = UIBarButtonItem(customView: rightBoundsView)
        
        navBarItem.rightBarButtonItem = rightButtonItem
        
        let leftBarButton = UIButton(type: .custom)
        let mbcBtnWidth = Constants.DeviceMetric.navBarButtonWidthMBC
        leftBarButton.frame = CGRect(x: 0, y: 0, width: mbcBtnWidth, height: mbcBtnWidth)
        let leftBoundsView = UIView(frame: leftBarButton.frame)
        
        leftBoundsView.bounds = leftBoundsView.bounds.offsetBy(dx: -Constants.DeviceMetric.navBarSearchBarMargin / 2,
                                                               dy: 0)
        leftBoundsView.addSubview(leftBarButton)
        leftBarButton.setImage(R.image.iconNavigationMbc(), for: .normal)
        let leftButtonItem = UIBarButtonItem(customView: leftBoundsView)
        navBarItem.leftBarButtonItem = leftButtonItem
    }
}

extension SearchBarContainerView: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        self.onShouldBeginSearching.onNext(())
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard let customSearch = searchBar as? BaseSearchBar else { return }
        
        customSearch.isEditing = true
        customSearch.drawCustomSearchBar()
        self.didBeginEditing()
        self.onDidBeginSearching.onNext(())
    }
 
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.onShouldEndSearching.onNext(())
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.didEndEditing()
        self.onDidEndSearching.onNext(searchBar.text)
        
        guard let customSearch = searchBar as? BaseSearchBar else { return }
        
        customSearch.isEditing = false
        customSearch.drawCustomSearchBar()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.didEndEditing()
        self.onDidCancelSearching.onNext(())
        searchBar.resignFirstResponder()
        
        guard let customSearch = searchBar as? BaseSearchBar else { return }
        
        customSearch.isEditing = false
        customSearch.drawCustomSearchBar()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.onTextDidChangeSearching.onNext((searchText))
        
        guard let customSearch = searchBar as? BaseSearchBar else { return }
        customSearch.drawCustomSearchBar()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        ///// JUST TO HIDE KEYBOARD /// WILL BE UPDATED LATER
        self.onSearchButtonClicked.onNext((searchBar.text))
        searchBar.resignFirstResponder()
        self.badgeNumber = Int(arc4random_uniform(15))
    }
}
