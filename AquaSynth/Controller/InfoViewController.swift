//
//  InfoViewController.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 9/20/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    var currentUrlString = ""
    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupUI() {
        dismissButton.layer.cornerRadius = dismissButton.frame.width / 2
        dismissButton.layer.borderWidth = 0.25
        dismissButton.layer.borderColor = UIColor.gray.cgColor
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let infoWebViewViewController = segue.destination as? InfoWebViewViewController {
            infoWebViewViewController.urlString = currentUrlString
        }
    }
    
    @IBAction func tripodTap(_ sender: UIButton) {
        currentUrlString = "https://www.amazon.com/Tripod-Kit-Universal-Adjustable-Microfiber/dp/B00EY2Q1AS"
        presentWebView()
    }
    
    @IBAction func bowlTap(_ sender: UIButton) {
        currentUrlString = "https://www.target.com/p/hammered-stainless-steel-serving-bowl-threshold-153/-/A-14911508"
        presentWebView()
    }
    
    @IBAction func introTap(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "OnboardingViewed")
        let appDelgate = UIApplication.shared.delegate as? AppDelegate
        appDelgate?.setOnboardingViewController()
    }
    
    @IBAction func walkThroughTap(_ sender: UIButton) {
        currentUrlString = "https://www.youtube.com/watch?v=MirHg3VFljI&feature=youtu.be"
        presentWebView()
    }
    
    private func presentWebView() {
        performSegue(withIdentifier: "infoWebView", sender: self)
    }
}
