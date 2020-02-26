//
//  ActivityCardView.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/21/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import UIKit
import MisterFusion
import TTTAttributedLabel

class ActivityCardView: BaseView {
    
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var textLabel: TTTAttributedLabel!
    @IBOutlet weak private var textLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private var textLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var separatorLineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var separatorLineView: UIView!
    
    private var activityCard: ActivityCard!
    private let textLabelTopMargin: CGFloat = 16
    private let separatorLineHeight: CGFloat = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    let authorPageTapped = PublishSubject<Author>()
    let taggedPageTapped = PublishSubject<[Author]>()
    
    private func commonInit() {
        Bundle.main.loadNibNamed(R.nib.activityCardView.name, owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.mf.addConstraints([
            self.top |==| containerView.top,
            self.left |==| containerView.left,
            self.bottom |==| containerView.bottom,
            self.right |==| containerView.right
        ])
        
        textLabel.linkAttributes = [NSAttributedStringKey.foregroundColor: Colors.dark.color(),
                                    NSAttributedStringKey.font: textLabel.font]
        textLabel.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
        textLabel.activeLinkAttributes = nil
        textLabel.delegate = self
    }
    
    func bindData(activityCard: ActivityCard) {
        self.activityCard = activityCard
        self.disposeBag = DisposeBag()
        guard let activityCardMessagePackage = activityCard.activityCardMessagePackage,
            let messageFormat = activityCardMessagePackage.messageFormat, !messageFormat.isEmpty,
            let argumentList = activityCardMessagePackage.argumentList,
            let argumentNameList = activityCardMessagePackage.argumentNameList else {
            textLabel.text = ""
            textLabelTopConstraint.constant = 0
            textLabelBottomConstraint.constant = 0
            separatorLineHeightConstraint.constant = 0
            return
        }
        var text = messageFormat
        for index in 0...(argumentList.count - 1) {
            text = text.replacingOccurrences(of: "{\(index)}", with: argumentList[index])
        }
        textLabel.text = text
        setupEvents(argumentList: argumentList, argumentNameList: argumentNameList)
        textLabelTopConstraint.constant = textLabelTopMargin
        textLabelBottomConstraint.constant = textLabelTopMargin
        separatorLineHeightConstraint.constant = separatorLineHeight
    }
    
    func getViewHeight() -> CGFloat {
        layoutIfNeeded()
        return separatorLineView.frame.origin.y + separatorLineView.frame.size.height
    }
    
    private func setupEvents(argumentList: [String], argumentNameList: [String]) {
        guard let text = textLabel.text else { return }
        for index in 0...(argumentList.count - 1) {
            if let range = text.range(of: argumentList[index]),
                let url = URL(string: argumentNameList[index]) {
                let nsRange = text.nsRange(from: range)
                textLabel.addLink(to: url, with: nsRange)
            }
        }
    }
}

extension ActivityCardView: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if let argument = ActivityCardArgument(rawValue: url.absoluteString) {
            switch argument {
            case .AUTHORPAGETITLE:
                if let authorPage = activityCard.authorPage {
                    authorPageTapped.onNext(authorPage)
                }
            case .COUNT, .TAGPAGETITLE:
                if let taggedPage = activityCard.taggedPageList {
                    taggedPageTapped.onNext(taggedPage)
                }
            default:
                return
            }
        }
    }
}
