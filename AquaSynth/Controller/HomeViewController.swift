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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    private func setupUI() {
        playButton.layer.cornerRadius = playButton.frame.width / 2
        playButton.layer.borderWidth = 3.0
        playButton.layer.borderColor = UIColor.purple.cgColor
        
        infoButton.layer.cornerRadius = infoButton.frame.width / 2
        infoButton.layer.borderWidth = 1.5
        infoButton.layer.borderColor = UIColor.orange.cgColor
    }
    
}

