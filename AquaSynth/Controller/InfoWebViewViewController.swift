//
//  InfoWebViewViewController.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 12/26/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit
import WebKit

class InfoWebViewViewController: UIViewController {

    var webView: WKWebView!
    var urlString = ""
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setupActivityIndicator()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupActivityIndicator() {
        activityIndicator.layer.cornerRadius = 8.0
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    private func setupUI() {
        dismissButton.layer.cornerRadius = dismissButton.frame.width / 2
        dismissButton.layer.borderWidth = 0.25
        dismissButton.layer.borderColor = UIColor.gray.cgColor
    }
    
    private func setupWebView() {
        webView = WKWebView(frame: CGRect(x: 0, y: 60, width: view.frame.width, height: view.frame.height - 60))
        webView.navigationDelegate = self
        let request = URLRequest(url: URL(string: urlString)!)
        webView.load(request)
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
}

extension InfoWebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        view.addSubview(webView)
        activityIndicator.stopAnimating()
    }
}
