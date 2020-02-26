//
//  PageMenu.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/4/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import BadgeSwift
import Foundation
import Kingfisher
import MisterFusion
import RxSwift
import UIKit

class PageMenu: UIScrollView {
    static let titleLabelTag = 100
    static let badgeLabelTag = 101
    
    static let iconWidth = CGFloat(24)
    static let iconHeightNormal = CGFloat(24)
    static let iconHeightShort = CGFloat(18)
    static let iconTopSpace = CGFloat(12)
    static let iconLeftSpace = CGFloat(24)
    
    static let titleHeight = CGFloat(24)
    static let titlePadding = CGFloat(5)
    
    // Subjects Declaration
    let selectedMenuItem = PublishSubject<PageMenuEnum>()
    
    private var aboutTabTitle: String?
    
    private var accentColor: UIColor!
    private var landingTab: PageMenuEnum!
    private var toShowItems: [PageMenuItem]!
    private var selectedItem: PageMenuItem! {
        didSet {
            if let oldV = oldValue, selectedItem.type == oldV.type { return }
            
            for item in toShowItems {
                let buttons = self.subviews
                    .filter { $0.tag == item.type.rawValue && $0 is UIButton }
                    .map { $0 as? UIButton }
                
                if let button = buttons.first {
                    setButtonSelected(button!, toBeSelected: selectedItem.type == item.type)
                }
            }
        }
    }
    
    static private let itemWidth = CGFloat(72)
    static private let itemHeight = CGFloat(67)

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(landingTab: PageMenuEnum, hiddenTabs: [PageMenuEnum],
                     accentColor: UIColor, showMenuTabs: Bool = true, aboutTabTitle: String?) {
        self.init(frame: showMenuTabs ? CGRect.zero :
            CGRect(x: 0, y: 0,
                   width: Constants.DeviceMetric.screenWidth,
                   height: PageMenu.itemHeight))
        isHidden = !showMenuTabs
        
        self.accentColor = accentColor
        self.landingTab = landingTab
        self.aboutTabTitle = aboutTabTitle
        
        initControl(hiddenItems: hiddenTabs)
    }
	
    // MARK: Private functions
    
    @objc
    private func didTapOnMenu(_ sender: UIButton) {
        let tag = sender.tag
        guard
            let itemType = PageMenuEnum(rawValue: tag)
            else { return }
        
        let item = toShowItems.filter { $0.type == itemType }
        if let selectedOne = item.first, selectedOne.type != selectedItem.type {
            print("Page Menu Clicked : \(String(describing: selectedOne.type.description))")
            selectedItem = selectedOne
            selectedMenuItem.onNext(selectedOne.type)
        }
    }
    
    private func initControl(hiddenItems: [PageMenuEnum]) {
        toShowItems = PageMenuEnum.allItems.filter { toShowItem in
            !hiddenItems.contains(where: { toShowItem.type == $0 })
        }
        
        /// Visibility
        if toShowItems.isEmpty {
            frame = CGRect.zero
            isHidden = true
            return
        }
        
        // Items rendering
        var i = 0
        var previousItem: UIButton!
        for item in toShowItems {
            let currentItem = buildMenuItem(item, atIndex: i)
            if i == 0 {
                self.addLayoutConstraints(currentItem.left |==| self.left)
            } else if previousItem != nil {
                self.addLayoutConstraints(currentItem.left |==| previousItem.right)
            }
            i += 1
            previousItem = currentItem
        }
        
        setLandingItemSelected()
        
        self.contentSize = CGSize(width: PageMenu.itemWidth * CGFloat(i), height: PageMenu.itemHeight)
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.setContentOffset(CGPoint(x: PageMenu.itemWidth * CGFloat(i), y: 0), animated: false)
        self.translatesAutoresizingMaskIntoConstraints = false
        let width = self.contentSize.width > Constants.DeviceMetric.screenWidth
            ? Constants.DeviceMetric.screenWidth
            : self.contentSize.width
        self.addLayoutConstraints( self.width |==| width )
    }
    
    private func setLandingItemSelected() {
        let items = PageMenuEnum.allItems.filter { $0.type == landingTab }
        if let firstItem = items.first {
            selectedItem = firstItem
        }
    }
    
    private func buildMenuItem(_ item: PageMenuItem, atIndex: Int) -> UIButton {
        let titleLabel = creatMenuLabel(item)
        let titleLabelWidth = titleLabel.text?.width(withConstrainedHeight: PageMenu.titleHeight, font: titleLabel.font)
        let actualMenuItemWWidth = (titleLabelWidth ?? 0) + PageMenu.titlePadding * 2
        let menuItemWidth = (actualMenuItemWWidth > PageMenu.itemWidth) ? actualMenuItemWWidth : PageMenu.itemWidth
        
        let menuItem = UIButton()
        menuItem.tag = item.type.rawValue
        self.addSubview(menuItem)
        menuItem.translatesAutoresizingMaskIntoConstraints = false
        self.addLayoutConstraints(
            menuItem.width |==| menuItemWidth,
            menuItem.height |==| PageMenu.itemHeight,
            menuItem.top |==| self.top
        )
        
        let iconView = UIImageView()
        if item.icon != nil {
            iconView.image = item.icon?.withRenderingMode(.alwaysTemplate)
        } else {
            iconView.image = R.image.iconNoLogo()?.withRenderingMode(.alwaysTemplate)
        }
        menuItem.addSubview(iconView)
        
        menuItem.addSubview(titleLabel)
		
        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
		
        var iconHeight = PageMenu.iconHeightNormal
        if item.type == .episodes || item.type == .videos {
           iconHeight = PageMenu.iconHeightShort
        }
        
        menuItem.mf.addConstraints(
            iconView.width |==| PageMenu.iconWidth,
            iconView.height |==| iconHeight,
            iconView.top |==| menuItem.safeArea.top |+| PageMenu.iconTopSpace,
            iconView.centerX |==| menuItem.safeArea.centerX,
            
            titleLabel.height |==| PageMenu.titleHeight,
            titleLabel.bottom |==| menuItem.safeArea.bottom |-| PageMenu.titlePadding,
            titleLabel.left |==| menuItem.safeArea.left |+| PageMenu.titlePadding,
            titleLabel.right |==| menuItem.safeArea.right |-| PageMenu.titlePadding,
            titleLabel.centerX |==| menuItem.safeArea.centerX
        )
        
        menuItem.addTarget(self, action: #selector(didTapOnMenu(_:)), for: UIControlEvents.touchDown)
        return menuItem
    }
    
    private func creatMenuLabel(_ item: PageMenuItem) -> UILabel {
        let titleLabel = UILabel()
        if item.type == .about {
            titleLabel.text = aboutTabTitle
        } else {
            titleLabel.text = item.name
        }
        titleLabel.font = Fonts.Primary.semiBold.toFontWith(size: 10)
        titleLabel.textAlignment = .center
        titleLabel.textColor = Colors.defaultText.color()
        titleLabel.tag = PageMenu.titleLabelTag
        
        return titleLabel
    }
	
    private func setButtonSelected(_ button: UIButton, toBeSelected: Bool) {
        let item = PageMenuEnum.allItems.filter { $0.type.rawValue == button.tag }
        if item.first == nil { return }
        
        let icons = button.subviews.filter { $0 is UIImageView }.map { $0 as? UIImageView }
        if let icon = icons.first {
            icon?.tintColor = toBeSelected ? accentColor : Colors.defaultText.color()
        }
        
        let titles = button.subviews.filter { $0 is UILabel && $0.tag == PageMenu.titleLabelTag }.map { $0 as? UILabel }
        if let title = titles.first {
			title?.textColor = toBeSelected ? accentColor : Colors.defaultText.color()
		}
    }
}
