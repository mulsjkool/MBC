//
//  EmbedHeaderCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 2/2/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

class EmbedHeaderCell: PostTextCell {
    
    @IBOutlet weak private var webView: EmbeddedWebView!
    @IBOutlet weak private var webViewHeightConstraint: NSLayoutConstraint!
    
    let didUpdateWebView = PublishSubject<Void>()
    let onStartInAppBrowser = PublishSubject<URL>()
    
    override func bindData(post: Post, accentColor: UIColor) {
        self.post = post
        super.bindData(post: post, accentColor: accentColor)
        bindEmbeddedContent()
    }
    
    override func prepareForReuse() {
        webView.reset()
        super.prepareForReuse()
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
