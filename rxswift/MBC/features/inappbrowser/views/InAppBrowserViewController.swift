//
//  InAppBrowserViewController.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/17/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class InAppBrowserViewController: BaseViewController {
    
    @IBOutlet weak private var webView: UIWebView!
    
    var url: URL!
    var didLoadStaticPage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        webView.delegate = self
        addBackButton()
        
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }
}

extension InAppBrowserViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if didLoadStaticPage {
            guard let path = R.file.staticpagestyleCss.path() else { return }
            let document = "document.createElement('link');"
            let linkRel = "'stylesheet'; document.head.appendChild(link)"
            let javaScriptStr = "var link = \(document) link.href = '\(path)'; link.rel = \(linkRel)"
            webView.stringByEvaluatingJavaScript(from: javaScriptStr)
        }
    }
}
