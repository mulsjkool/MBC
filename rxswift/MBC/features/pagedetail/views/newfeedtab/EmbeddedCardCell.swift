//
//  EmbeddedCardCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/15/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import UIKit
import TTTAttributedLabel

class EmbeddedCardCell: BaseCardTableViewCell {
    @IBOutlet weak private var webView: EmbeddedWebView!
    @IBOutlet weak private var webViewHeightConstraint: NSLayoutConstraint!
    
    let didUpdateWebView = PublishSubject<Void>()
    let onStartInAppBrowser = PublishSubject<URL>()
    
    private var post: Post {
        return (feed as? Post)!
    }
    
    override func prepareForReuse() {
        webView.reset()
        super.prepareForReuse()
    }
    
    func bindData(post: Post, accentColor: UIColor?) {
        super.bindData(feed: post, accentColor: accentColor)
        bindDescription()
        bindEmbeddedContent()
    }
    
    internal override func bindDescription() {
        guard let desc = post.description else { return }
        let label = getDescriptionLabel()
        label.from(html: desc)
        Common.setupDescriptionFor(label: label, whenExpanding: post.isTextExpanded,
                                   maxLines: Constants.DefaultValue.numberOfLinesForEmbeddedDescription,
                                   linkColor: accentColor,
                                   delegate: self)
    }
    
    private func bindEmbeddedContent() {
        webView.disposeBag.addDisposables([
            webView.didUpdateViewHeight.subscribe(onNext: { [unowned self] viewHeight in
                if Int(viewHeight) != Int(self.post.embeddedViewHeight) {
                    self.post.embeddedViewHeight = viewHeight
                    self.webViewHeightConstraint.constant = viewHeight
                    self.layoutIfNeeded()
                    self.didUpdateWebView.onNext(())
                }
            }),
            webView.onStartInAppBrowser.subscribe(onNext: { [unowned self] url in
                self.onStartInAppBrowser.onNext(url)
            })
        ])
        
        webView.loadEmbeddedScript(embeddedScript: post.codeSnippet, currentHeight: post.embeddedViewHeight)
        if post.embeddedViewHeight == 0 {
            post.embeddedViewHeight = webView.viewHeight
        }
        webViewHeightConstraint.constant = post.embeddedViewHeight
    }
}
