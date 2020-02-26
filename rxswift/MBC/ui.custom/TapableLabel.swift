//
//  TapableLabel.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/4/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import UIKit

class TapableLabel: UILabel {
    
    var completionHandlers:[() -> Void] = []
    var ranges = [NSRange]()
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        self.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] range in
                for range in self.ranges {
                    if tapGesture.didTapAttributedTextInLabel(label: self, inRange: range) {
                        let completionHandler = self.completionHandlers[self.ranges.index(of: range)!]
                        completionHandler()
                        break
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func handleTapEvent(range: NSRange, completionHandler: @escaping () -> Void) {
        ranges.append(range)
        completionHandlers.append(completionHandler)
    }
    
    func resetClosures() {
        completionHandlers = []
        ranges = [NSRange]()
    }
}
