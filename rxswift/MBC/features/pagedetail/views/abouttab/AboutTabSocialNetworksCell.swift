//
//  AboutTabSocialNetworksCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/15/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import MisterFusion
import RxSwift
import UIKit

class AboutTabSocialNetworksCell: BaseTableViewCell {
    @IBOutlet weak private var collectionView: UICollectionView!
    
    var socialNetworks = [SocialNetwork]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(R.nib.socialNetworkCollectionViewCell(),
                            forCellWithReuseIdentifier: R.reuseIdentifier.socialNetworkCollectionViewCell.identifier)
    }
    
    func bindData(socialNetworks: [SocialNetwork]) {
        self.socialNetworks = socialNetworks
        collectionView.reloadData()
    }
}

extension AboutTabSocialNetworksCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return socialNetworks.count
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
        // swiftlint:disable force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            R.reuseIdentifier.socialNetworkCollectionViewCell.identifier, for: indexPath)
            as! SocialNetworkCollectionViewCell
        cell.bindData(socialNetwork: socialNetworks[indexPath.row])
        return cell
    }
}
