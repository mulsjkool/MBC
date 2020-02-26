//
//  EmbeddedWebView.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/15/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import SwiftSoup
import RxSwift

class EmbeddedWebView: UIWebView, UIGestureRecognizerDelegate, UIWebViewDelegate {
    private var embeddedScript = ""
    private var isTapping = false
    private var shouldUpdateViewHeight = false
    
    var viewHeight: CGFloat = 0
    var disposeBag = DisposeBag()
    
    let didUpdateViewHeight = PublishSubject<CGFloat>()
    let onStartInAppBrowser = PublishSubject<URL>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.backgroundColor = UIColor.clear
        scrollView.isScrollEnabled = false
        isOpaque = false
        backgroundColor = UIColor.clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action:
            #selector(EmbeddedWebView.webViewTapped(sender:)))
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func webViewTapped(sender: UITapGestureRecognizer) {
        perform(#selector(EmbeddedWebView.finishTapping), with: nil, afterDelay: 2.0)
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        isTapping = true
        return true
    }
    
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith
        otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    private static let htmlFields = (
        iframe: "iframe",
        width: "width",
        height: "height",
        src: "src",
        blockquote: "blockquote",
        classAtt: "class",
        style: "style"
    )
    
    func reset() {
        stopLoading()
        delegate = nil
        disposeBag = DisposeBag()
    }
    
    func loadEmbeddedScript(embeddedScript: String?, currentHeight: CGFloat) {
        guard let embeddedScript = embeddedScript, !embeddedScript.isEmpty else {
            viewHeight = 0
            resetZoomScale()
            return
        }
        self.embeddedScript = embeddedScript
        viewHeight = currentHeight
        if viewHeight == 0 {
            viewHeight = Constants.DeviceMetric.screenSize.width - 2 * Constants.DefaultValue.defaultMargin
            viewHeight *= Constants.DefaultValue.ratio9H16W
            resetZoomScale()
        }
        
        guard let data = embeddedScript.data(using: .utf8) else {
            viewHeight = 0
            resetZoomScale()
            return
        }
        delegate = self
        self.load(data, mimeType: "text/html", textEncodingName: "UTF-8",
                  baseURL: Constants.DefaultValue.embeddedWebViewBaseUrl)
    }
    
    private let twitter = "twitter"
    private let instagram = "instagram"
    private let twitterVideo = "twitter-video"
    
    private func isTwitterVideoEmbeddedScript() -> Bool {
        var isTwitterVideo = false
        let fields = EmbeddedWebView.htmlFields
        do {
            let doc: Document = try SwiftSoup.parse(embeddedScript)
            if let elements = try? doc.select(fields.blockquote),
                let blockquote = elements.first(),
                let classStr = try? blockquote.attr(fields.classAtt) {
                if classStr.range(of: twitterVideo) != nil {
                    isTwitterVideo = true
                }
            }
        } catch Exception.Error(_, let message) {
            print(message)
        } catch {
            print("error")
        }
        return isTwitterVideo
    }
    
    private let twitterPlayingVideo = "twitter.com/i/videos/tweet"
    
    private func isRequestPlayingTwitterVideo(url: URL) -> Bool {
        return (url.absoluteString.range(of: twitterPlayingVideo) != nil) ? true : false
    }
    
    private func resetZoomScale() {
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 1
        scrollView.zoomScale = 1
    }
    
    private func updateViewHeight() {
        let contentSize = scrollView.contentSize
        if contentSize.width == 0 {
            resetZoomScale()
            return
        }
        let viewSize = bounds.size
        let rw = viewSize.width / contentSize.width
        scrollView.minimumZoomScale = rw
        scrollView.maximumZoomScale = rw
        scrollView.zoomScale = rw
        viewHeight = rw * contentSize.height
        didUpdateViewHeight.onNext(viewHeight)
    }

    @objc
    private func finishTapping() {
        isTapping = false
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        updateViewHeight()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        updateViewHeight()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest,
                 navigationType: UIWebViewNavigationType) -> Bool {
        if isTapping {
            if let url = request.url, !url.absoluteString.isEmpty {
                if isTwitterVideoEmbeddedScript() && isRequestPlayingTwitterVideo(url: url) {
                    perform(#selector(finishTapping), with: nil, afterDelay: 2.0)
                    return true
                } else {
                    if url.absoluteString.verifyUrl()
                        && url.absoluteString != Constants.DefaultValue.embeddedWebViewBaseUrl.absoluteString {
                        onStartInAppBrowser.onNext(url)
                        perform(#selector(finishTapping), with: nil, afterDelay: 2.0)
                        return false
                    }
                }
            }
        }
        return true
    }
}
