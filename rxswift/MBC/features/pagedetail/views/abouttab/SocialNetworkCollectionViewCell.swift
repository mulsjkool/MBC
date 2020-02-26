//
//  SocialNetworkCollectionViewCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/28/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit

class SocialNetworkCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak private var button: UIButton!
    
    func bindData(socialNetwork: SocialNetwork) {
        button.setBackgroundImage(socialNetwork.socialNetworkName.image(), for: .normal)
        
        disposeBag.addDisposables([
            button.rx.tap.subscribe(onNext: { _ in
                UIApplication.shared.openSocialApp(socialNetwork: socialNetwork)
            })
        ])
    }
}
