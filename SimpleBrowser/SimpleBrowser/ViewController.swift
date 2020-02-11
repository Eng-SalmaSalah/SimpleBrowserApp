//
//  ViewController.swift
//  SimpleBrowser
//
//  Created by Salma Salah on 2/11/20.
//  Copyright © 2020 Salma Salah. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController,WKNavigationDelegate {
    
    var webView : WKWebView?
    
    override func loadView() {
        webView = WKWebView()
        webView?.navigationDelegate = self
        view = webView // to add the webview to the view of my vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //to load website in the webview , string is wrapped in url , url is wrapped in url request and the web view load the url request
    
        let url = URL(string: "https://www.hackingwithswift.com")!//we force unwarp the url because i have written it no string interpolation , otherwise we can use guard let
        let urlRequest = URLRequest(url: url)
        webView?.load(urlRequest)
        
        webView?.allowsBackForwardNavigationGestures = true // to allow back and forward using sliding
    }


}

