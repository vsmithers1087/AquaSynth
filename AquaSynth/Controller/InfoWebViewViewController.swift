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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupUI() {
        dismissButton.layer.cornerRadius = dismissButton.frame.width / 2
        dismissButton.layer.borderWidth = 0.25
        dismissButton.layer.borderColor = UIColor.gray.cgColor
    }
    
    private func setupWebView() {
        webView = WKWebView(frame: CGRect(x: 0, y: 80, width: view.frame.width, height: view.frame.height - 80))
        view.addSubview(webView)
        let request = URLRequest(url: URL(string: urlString)!)
        webView.load(request)
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
}

extension InfoWebViewViewController {
    
}
