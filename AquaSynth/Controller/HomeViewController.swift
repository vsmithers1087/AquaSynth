//
//  ViewController.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 9/19/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var aquaSynthLabelBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        aquaSynthLabelBottom.constant = view.frame.height / 4
    }
    
    private func setupUI() {
        playButton.layer.cornerRadius = playButton.frame.width / 2
        playButton.layer.borderWidth = 3.0
        playButton.layer.borderColor = UIColor.orange.cgColor
        
        infoButton.layer.cornerRadius = infoButton.frame.width / 2
        infoButton.layer.borderWidth = 1.5
        infoButton.layer.borderColor = UIColor.orange.cgColor
        aquaSynthLabelBottom.constant = view.frame.height / 6
    }
    
}

