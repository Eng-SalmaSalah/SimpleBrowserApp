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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "open page", style: .plain, target: self, action: #selector(openPage))
        //to load website in the webview , string is wrapped in url , url is wrapped in url request and the web view load the url request
    
        let url = URL(string: "https://www.hackingwithswift.com")!//we force unwarp the url because i have written it no string interpolation , otherwise we can use guard let
        let urlRequest = URLRequest(url: url)
        webView?.load(urlRequest)
        
        webView?.allowsBackForwardNavigationGestures = true // to allow back and forward using sliding
    }
    
    
    @objc func openPage() {
        let alertVC = UIAlertController(title: "Select Page", message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openSelectedPage))
        alertVC.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openSelectedPage))
        alertVC.addAction(UIAlertAction(title: "cancel", style: .cancel)) //to dismiss alert when cancel tapped,we don't add handler
        alertVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alertVC,animated: true)
    }
    
    func openSelectedPage(alertAction : UIAlertAction){
        let url = URL(string: "https://" + alertAction.title!)!
        //here there is 2 force unwraps , 1 for the title as alertAction may don't have title , the other is for the url as the url string may be invalid
        //we can do this in safer way (not urgent here):
        guard let actionTitle = alertAction.title else {return}
        guard let selectedUrl = URL(string: "https://" + actionTitle) else {return}
        let urlRequest = URLRequest(url: selectedUrl)
        webView?.load(urlRequest)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title //to set the title of vc with the website name
    }

}

