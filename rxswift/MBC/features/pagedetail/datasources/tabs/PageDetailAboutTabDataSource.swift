//
//  PageDetailAboutTabDataSource.swift
//  MBC
//
//  Created by Tram Nguyen on 2/24/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

protocol PageDetailAboutTabDelegate: PageDetailTabDelegate {
    func navigateToPageDetail(feed: Feed)
}

class PageDetailAboutTabDataSource: PageDetailTabDataSource {
    
    private var aboutTabData: [[String: Any]]?
    
    weak var delegate: PageDetailAboutTabDelegate?
    
    var dummyCell: UITableViewCell {
        return Common.createDummyCellWith(title: "Cell for a of type: About tab - Invalid")
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    func getAboutTabData(infoComponents: [InfoComponent]?, pageAboutTab: PageAboutTab?) -> [[String: Any]] {
        if aboutTabData != nil {
            return aboutTabData!
        }
        
        var data = [[String: Any]]()
        
        if let infoComponents = infoComponents {
            let aboveMetadataComponents = infoComponents.filter({ $0.aboveMetadata })
            for component in aboveMetadataComponents {
                data.append([PageAboutRow.infoComponent.rawValue: component])
            }
        }
        
        if let pageAboutTab = pageAboutTab {
            if let metadata = pageAboutTab.metadata {
                data.append([PageAboutRow.metadata.rawValue: metadata])
            }
            
            if let about = pageAboutTab.about {
                data.append([PageAboutRow.about.rawValue: about])
            }
        }
        
        if let infoComponents = infoComponents {
            let belowMetadataComponents = infoComponents.filter({ !$0.aboveMetadata })
            for component in belowMetadataComponents {
                data.append([PageAboutRow.infoComponent.rawValue: component])
            }
        }
        
        if let pageAboutTab = pageAboutTab {
            if let location = pageAboutTab.location {
                data.append([PageAboutRow.location.rawValue: location])
            }
            
            if let socialNetworks = pageAboutTab.socialNetworks {
                data.append([PageAboutRow.socialNetworks.rawValue: socialNetworks])
            }
        }
        
        aboutTabData = data
        return data
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    func cellForIndexPath(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let aboutTabData = aboutTabData else { return dummyCell }
        let rowDict = aboutTabData[indexPath.row]
        if let rowKey = rowDict.keys.first, let row = PageAboutRow(rawValue: rowKey) {
            let value = rowDict[rowKey]
            switch row {
            case .metadata:
                if let cell = tableView.dequeueReusableCell(withIdentifier:
                    R.reuseIdentifier.aboutTabMetadataCell.identifier) as? AboutTabMetadataCell,
                    let metadata = value as? [[String: String]] {
                    cell.bindData(metadata: metadata)
                    return cell
                }
            case .location:
                if let cell = tableView.dequeueReusableCell(withIdentifier:
                    R.reuseIdentifier.aboutTabLocationCell.identifier) as? AboutTabLocationCell {
                    return cell
                }
            case .about:
                if let cell = tableView.dequeueReusableCell(withIdentifier:
                    R.reuseIdentifier.aboutTabAboutCell.identifier) as? AboutTabAboutCell,
                    let about = value as? PageInforAbout {
                    cell.bindData(pageInforAbout: about)
                    return cell
                }
            case .socialNetworks:
                if let cell = tableView.dequeueReusableCell(withIdentifier:
                    R.reuseIdentifier.aboutTabSocialNetworksCell.identifier) as? AboutTabSocialNetworksCell,
                    let socialNetworks = value as? [SocialNetwork] {
                    cell.bindData(socialNetworks: socialNetworks)
                    return cell
                }
            case .infoComponent:
                if let cell = tableView.dequeueReusableCell(withIdentifier:
                    R.reuseIdentifier.carouselTableViewCellid.identifier) as? CarouselTableViewCell,
                    let infoComponent = value as? InfoComponent {
                    cell.bindData(info: infoComponent, languageConfigList: delegate?.getLanguageConfigList())
                    cell.disposeBag.addDisposables([
                        cell.thumbnailTapped.subscribe(onNext: { [unowned self] feed, _ in
                            self.delegate?.navigateToPageDetail(feed: feed)
                        }),
                        cell.titleTapped.subscribe(onNext: { [unowned self] feed, _ in
                            self.delegate?.navigateToPageDetail(feed: feed)
                        })
                    ])
                    return cell
                }
                return dummyCell
            }
        }
        return dummyCell
    }
}
