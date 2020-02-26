//
//  ArticleEmbeddedCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/16/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class ArticleEmbeddedCell: ArticleParagraphTextCell {
    
    @IBOutlet weak private var webView: EmbeddedWebView!
    @IBOutlet weak private var webViewHeightConstraint: NSLayoutConstraint!
    
    let didUpdateWebView = PublishSubject<Void>()
    let onStartInAppBrowser = PublishSubject<URL>()
    
    override func prepareForReuse() {
        webView.reset()
        super.prepareForReuse()
    }
    
    override func bindData(paragraph: Paragraph, numberOfItem: Int, paragraphViewOption: ParagraphViewOptionEnum) {
        super.bindData(paragraph: paragraph, numberOfItem: numberOfItem, paragraphViewOption: paragraphViewOption)
        bindEmbedded()
    }
    
    private func bindEmbedded() {
        webView.disposeBag.addDisposables([
            webView.didUpdateViewHeight.subscribe(onNext: { [unowned self] viewHeight in
                if Int(viewHeight) != Int(self.paragraph.embeddedViewHeight) {
                    self.paragraph.embeddedViewHeight = viewHeight
                    self.webViewHeightConstraint.constant = viewHeight
                    self.layoutIfNeeded()
                    self.didUpdateWebView.onNext(())
                }
            }),
            webView.onStartInAppBrowser.subscribe(onNext: { [unowned self] url in
                self.onStartInAppBrowser.onNext(url)
            })
        ])
        
        webView.loadEmbeddedScript(embeddedScript: paragraph.codeSnippet, currentHeight: paragraph.embeddedViewHeight)
        if paragraph.embeddedViewHeight == 0 {
            paragraph.embeddedViewHeight = webView.viewHeight
        }
        webViewHeightConstraint.constant = paragraph.embeddedViewHeight
    }
}
