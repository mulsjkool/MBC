//
//  BaseCollectionViewCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/28/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import RxSwift
import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
