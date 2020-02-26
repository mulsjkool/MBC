//
//  AppWhitePageTableViewCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 2/5/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class AppWhitePageTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak private var webView: UIWebView!
    @IBOutlet weak private var appPhototImageView: UIImageView!
    @IBOutlet weak private var appTypeLabel: UILabel!
    @IBOutlet weak private var authorNameLabel: UILabel!
    @IBOutlet weak private var webViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak private var likeCommentShareView: LikeCommentShareView!
	@IBOutlet weak private var appSubTypeLabel: UILabel!
	@IBOutlet weak private var authorNameLabelWidthConstraint: NSLayoutConstraint!
	
	private let usedWidth: CGFloat = 74.0
	
	let didChangeWebViewHeight = PublishSubject<Void>()
	var commentTapped: Observable<Likable> {
		return self.likeCommentShareView.commentTapped.asObservable()
	}
	
    var shareTapped: Observable<Likable> {
        return self.likeCommentShareView.shareTapped.asObservable()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        appTypeLabel.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .left : .right
        webView.backgroundColor = Colors.defaultBg.color()
        webView.scrollView.isScrollEnabled = false
        webView.delegate = self
    }
    
    func bindData(app: App) {
        if let appPhoto = app.photo {
            appPhototImageView.setImage(from: appPhoto, resolution: .ar16x16,
                                        gifSupport: true, placeholder: Constants.DefaultValue.defaulNoLogoImage)
        } else {
            appPhototImageView.image = Constants.DefaultValue.defaulNoLogoImage
        }
        bindType(subType: app.subType)
        layoutIfNeeded()
        authorNameLabelWidthConstraint.constant = Constants.DeviceMetric.screenWidth -
            usedWidth - appSubTypeLabel.frame.size.width - appTypeLabel.frame.size.width
        authorNameLabel.text = app.author?.name ?? ""
        bindAppScript(app: app)
		likeCommentShareView.feed = app
    }
    
    private func bindType(subType: String?) {
        appTypeLabel.text = R.string.localizable.cardTypeApp()
        let appSubType = AppSubType(rawValue: subType ?? "") ?? AppSubType.other
        appSubTypeLabel.text = appSubType.localizedContentType()
    }
    
    private func bindAppScript(app: App) {
        guard let code = app.code, !code.isEmpty,
            let whitePageUrl = app.whitePageUrl, !whitePageUrl.isEmpty else {
            hideWebView()
            return
        }
        
        let queryItems = [URLQueryItem(name: Constants.QueryString.whitePageIsMobile,
                                       value: Constants.QueryString.trueValue)] //mo=true: is for mobile
        let urlComps = NSURLComponents(string: Components.instance.configurations.websiteBaseURL + whitePageUrl)
        urlComps?.queryItems = queryItems

        guard let url = urlComps?.url else { return }
        webView.loadRequest(URLRequest(url: url))
    }
    
    private func hideWebView() {
        self.webViewHeightConstraint.constant = 0
        didChangeWebViewHeight.onNext(())
    }
    
    fileprivate func hideWebComponents() {
        let js = """
            jQuery('.header-container').hide();
            jQuery('.sticky-bar-bottom').hide();
            jQuery('.body-container').css('margin-top', 0);
        """
        webView.stringByEvaluatingJavaScript(from: js)
    }
}

extension AppWhitePageTableViewCell: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        hideWebComponents()
        
        if let height = Common.heightOfWebViewContent(webView: self.webView) {
            self.webViewHeightConstraint.constant = height
            layoutIfNeeded()
            didChangeWebViewHeight.onNext(())
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        hideWebComponents()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        hideWebView()
        print(error)
        hideWebComponents()
    }
}
