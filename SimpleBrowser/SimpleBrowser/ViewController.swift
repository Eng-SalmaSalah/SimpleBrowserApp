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
    
    var webView : WKWebView!
    var progressView : UIProgressView!
    var webSites = ["hackingwithswift.com","apple.com"] //that is better to use this list to show to user and to check that user opened one of the allowe websites
    var webSiteToLoad : String?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView // to add the webview to the view of my vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "open page", style: .plain, target: self, action: #selector(openPage))
        //to load website in the webview , string is wrapped in url , url is wrapped in url request and the web view load the url request
        
        //to add bar buttons to the toolbar items
        
        //for the progress view , we will create the view and wrap it in bar btn so we can add it to the toolbar
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressBarBtn = UIBarButtonItem(customView: progressView)
        
        let refreshBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action:#selector(webView.reload))
        
        let spacing = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let backBtn = UIBarButtonItem(title: "back", style: .plain, target: webView, action:#selector (webView.goBack))
        let forwardBtn = UIBarButtonItem(title: "forward", style: .plain, target: webView, action: #selector(webView.goForward))
        toolbarItems = [progressBarBtn,spacing,backBtn,forwardBtn,refreshBtn]
        navigationController?.isToolbarHidden = false
        

        //we need to add observer to the progress of loading webview , as when the progress changes the progress bar changes we will do this bye KVO (key value observer)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        //keypath : represent the value we want to observe
        //options : what notification (observeing) is on (here it happens when new value is set)
        //context : if we need to send extra info with the notification , it is nil almost all time
    
        var url = URL(string: "https://" + webSites[0])!
        //to open the selected website in the table view if the user selected one from the tablevc:
        if let selectedWebSite = webSiteToLoad{
            url = URL(string: "https://" + selectedWebSite)!
        }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        
        webView.allowsBackForwardNavigationGestures = true // to allow back and forward using sliding
    }
    
    
    @objc func openPage() {
        let alertVC = UIAlertController(title: "Select Page", message: nil, preferredStyle: .actionSheet)
//        alertVC.addAction(UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openSelectedPage))
//        alertVC.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openSelectedPage))
        for webSite in webSites{
            alertVC.addAction(UIAlertAction(title: webSite, style: .default, handler: openSelectedPage))
        }
        alertVC.addAction(UIAlertAction(title: "cancel", style: .cancel)) //to dismiss alert when cancel tapped,we don't add handler
        alertVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alertVC,animated: true)
    }
    
    func openSelectedPage(alertAction : UIAlertAction){
  //      let url = URL(string: "https://" + alertAction.title!)!
        //here there is 2 force unwraps , 1 for the title as alertAction may don't have title , the other is for the url as the url string may be invalid
        //we can do this in safer way (not urgent here):
        guard let actionTitle = alertAction.title else {return}
        guard let selectedUrl = URL(string: "https://" + actionTitle) else {return}
        let urlRequest = URLRequest(url: selectedUrl)
        webView.load(urlRequest)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title //to set the title of vc with the website name
    }
    
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url

        if let host = url?.host {
            for website in webSites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }

        decisionHandler(.cancel)
        // to let user know :
        showAlertIfWebsiteNotAllowed(blockedWebsite: url?.host ?? "")
        
    }
    
    func showAlertIfWebsiteNotAllowed(blockedWebsite : String){
        var alertMsg = ""
        if blockedWebsite != ""{
            alertMsg = "\(blockedWebsite) is blocked"
        }else{
            alertMsg = "this website is blocked"
        }
        
        let alertVC = UIAlertController(title: "We are sorry", message: alertMsg, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "ok", style: .default, handler:dismissViewIfWebsiteBlocked))
        present(alertVC,animated: true)
    }
    
    func dismissViewIfWebsiteBlocked(alertAction : UIAlertAction){
        navigationController?.popViewController(animated: true)
    }
    
    //method that is called when value changes
  
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // if keyPath == "estimatedProgress" or:
        if keyPath == #keyPath(WKWebView.estimatedProgress){
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

}

