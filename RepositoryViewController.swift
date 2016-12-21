//
//  RepositoryViewController.swift
//  GithubQuery
//
//  Created by leafy on 2016/12/21.
//  Copyright © 2016年 leafy. All rights reserved.
//

import UIKit
import WebKit

class RepositoryViewController: UIViewController {

    fileprivate var webView: WKWebView?
    fileprivate var urlRequest: URLRequest?
    fileprivate var progressView: UIProgressView?
    fileprivate var timer: Timer?
    var repository: Repository?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = repository?.name ?? ""
        view.backgroundColor = UIColor.white
        
        let configuration = WKWebViewConfiguration()
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView?.navigationDelegate = self
        webView?.backgroundColor = UIColor.white
        let url = URL(string: (repository?.html_url)!)
        urlRequest = URLRequest(url: url!)
        
        view.addSubview(webView!)
        
        progressView = UIProgressView(frame: CGRect(origin: view.bounds.origin, size: CGSize(width: view.bounds.width, height: 2.0)))
        progressView?.progress = 0
        view.addSubview(progressView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        _ = webView?.load(urlRequest!)
    }
    
    @objc fileprivate func updateProgress() {
        progressView?.progress = Float((webView?.estimatedProgress)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension RepositoryViewController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //        print("***Start webView: \(webView), navigation: \(navigation)")
        progressView?.isHidden = false
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //        print("***Finish webView: \(webView), navigation: \(navigation)")
        progressView?.isHidden = true
        timer?.invalidate()
        timer = nil
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        //        print("***Fail webView: \(webView), navigation: \(navigation)")
        progressView?.isHidden = true
        timer?.invalidate()
        timer = nil
    }
}
