//
//  TimestampAndContentTypeView.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/16/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import UIKit
import MisterFusion

class TimestampAndContentTypeView: BaseView {

    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var timestampLabel: UILabel!
    @IBOutlet weak private var contentTypeLabel: UILabel!
    @IBOutlet weak private var contentSubTypeLabel: UILabel!
    @IBOutlet weak private var seperatorContentType: UILabel!
    @IBOutlet weak private var seperatorContentSubType: UILabel!
    private let separatorCharater = Constants.DefaultValue.separatorCharacter
    let timestampTapped = PublishSubject<Void>()
    
    // MARK: Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: Public
    
    func bindTimestamp(date: Date?) {
        timestampLabel.text = (date != nil) ? date!.getCardTimestamp() : ""
        timestampLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        timestampLabel.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.timestampTapped.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    func bindContentType(type: String?, subType: String?) {
        seperatorContentSubType.isHidden = true
        contentTypeLabel.text = ""
        if let theType = type, let fType = FeedType(rawValue: theType) {
            if fType == .app, let sType = subType {
                let appSubType = AppSubType(rawValue: sType) ?? AppSubType.other
                showContentTypeAndSubType(contentType: R.string.localizable.cardTypeApp(),
                                          contentSubType: appSubType.localizedContentType())
            } else {
                contentTypeLabel.text = fType.localizedContentType(subType: subType ?? "")
                
            }
        } else if let theSubtype = subType, let fsubType = FeedSubType(rawValue: theSubtype) {
            showOnlyContentType(content: fsubType.localizedContentType())
        }
        if contentSubTypeLabel.text == "" {
            seperatorContentSubType.isHidden = true
        }
        if contentTypeLabel.text == "" {
            seperatorContentType.isHidden = true
        }
        layoutIfNeeded()
    }
    
    func bindContentTypeForAppCard(type: String?, subType: String?) {
        seperatorContentSubType.isHidden = true
        contentTypeLabel.text = ""
        contentSubTypeLabel.text = ""
        guard let theType = type, let fType = FeedType(rawValue: theType) else { return }
        if fType == .app, let sType = subType {
            let appSubType = AppSubType(rawValue: sType) ?? AppSubType.other
            showContentTypeAndSubType(contentType: R.string.localizable.cardTypeApp(),
                                      contentSubType: appSubType.localizedContentType())
        } else {
            contentTypeLabel.text = fType.localizedContentType(subType: subType ?? "")
        }
        if contentSubTypeLabel.text == "" {
            seperatorContentSubType.isHidden = true
        }
        if contentTypeLabel.text == "" {
            seperatorContentType.isHidden = true
        }
        layoutIfNeeded()
    }
    
    func applyColor(color: UIColor) {
        timestampLabel.textColor = color
        contentTypeLabel.textColor = color
        seperatorContentSubType.textColor = color
        seperatorContentType.textColor = color
        contentSubTypeLabel.textColor = color
    }
    
    // MARK: private
    private func commonInit() {
        Bundle.main.loadNibNamed(R.nib.timestampAndContentTypeView.name, owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        self.mf.addConstraints([
            self.top |==| containerView.top,
            self.left |==| containerView.left,
            self.bottom |==| containerView.bottom,
            self.right |==| containerView.right
        ])
    }
    
    private func showContentTypeAndSubType(contentType: String, contentSubType: String) {
        seperatorContentType.text = separatorCharater
        seperatorContentSubType.text = separatorCharater
        contentTypeLabel.text = contentType
        contentSubTypeLabel.text = contentSubType
        seperatorContentSubType.isHidden = false
    }
    
    private func showOnlyContentType(content: String) {
        seperatorContentSubType.text = ""
        contentSubTypeLabel.text = ""
        seperatorContentType.text = separatorCharater
        contentTypeLabel.text = content
        seperatorContentSubType.isHidden = true
    }
}
