//
//  VideoTitleFullScreenView.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 2/6/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift
import MisterFusion
import TTTAttributedLabel

class VideoTitleFullScreenView: BaseView {
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var titleLabel: TTTAttributedLabel!
    @IBOutlet weak private var descritionLabel: TTTAttributedLabel!
    @IBOutlet weak private var titleBottomConstraint: NSLayoutConstraint!
    private let defaultTitleMarginBottom: CGFloat = 3.0
    
    private var title: String?
    private var descriptionString: String?
    let expandTitleView = PublishSubject<CGFloat>()
    var updateTitleHeight = PublishSubject<CGFloat>()
    private let fullScreenWidth: CGFloat = Constants.DeviceMetric.screenHeight - 2 *
        Constants.DefaultValue.defaultMargin
    
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
    func bindData(title: String?, description: String?) {
        disposeBag = DisposeBag()
        self.title = title
        self.descriptionString = description
        showTitle()
    }
    
    // MARK: Private
    private func commonInit() {
        Bundle.main.loadNibNamed(R.nib.videoTitleFullScreenView.name, owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.mf.addConstraints([
            self.top |==| containerView.top,
            self.left |==| containerView.left,
            self.bottom |==| containerView.bottom,
            self.right |==| containerView.right
        ])
    }
    
     func showTitle() {
        if let text = title {
            titleLabel.text = text
            Common.setupDescriptionFor(label: titleLabel, whenExpanding: false,
                                       maxLines: 1,
                                       linkColor: UIColor.white,
                                       delegate: self)
            let titleHeight = (titleLabel.text?.height(withConstrainedWidth: fullScreenWidth,
                                                             font: titleLabel.font))!
            updateTitleHeight.onNext(titleHeight)
            let tapGesture = UITapGestureRecognizer()
            titleLabel.addGestureRecognizer(tapGesture)
            disposeBag.addDisposables([
                tapGesture.rx.event.bind(onNext: { [unowned self] _ in
                    self.showFullTitleView()
                })
            ])
            
        }
        titleBottomConstraint.constant = 0
        descritionLabel.text = ""
    }
    
    private func expandCardTextLabel(label: TTTAttributedLabel!) {
        showFullTitleView()
    }
    
    private func showFullTitleView() {
        var titleHeight: CGFloat = 0
        if let text = title {
            titleLabel.numberOfLines = 0
            titleLabel.lineBreakMode = .byWordWrapping
            titleLabel.text = text
            titleHeight = (titleLabel.text?.height(withConstrainedWidth: fullScreenWidth,
                                                   font: titleLabel.font))! + defaultTitleMarginBottom
            titleBottomConstraint.constant = defaultTitleMarginBottom
           
        }
        if let text = descriptionString, !text.isEmpty {
            descritionLabel.numberOfLines = 0
            descritionLabel.lineBreakMode = .byWordWrapping
            descritionLabel.from(html: text)
            titleHeight += (descritionLabel.text?.height(withConstrainedWidth: fullScreenWidth,
                                                   font: descritionLabel.font))!
        }
        expandTitleView.onNext(titleHeight)
    }

}

extension VideoTitleFullScreenView: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        print("showFullTitleView")
        if url.absoluteString == Constants.DefaultValue.CustomUrlForMoreText.absoluteString {
            showFullTitleView()
        }
    }
}
