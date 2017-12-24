//
//  ViewController.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 9/19/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var infoButton: UIButton!
    var arrowButton: ArrowButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupArrowButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    }
    
    private func setupUI() {
        infoButton.layer.cornerRadius = infoButton.frame.width / 2
        infoButton.layer.borderWidth = 1.5
        infoButton.layer.borderColor = UIColor.orange.cgColor
    }
    
    private func setupArrowButton() {
        arrowButton = ArrowButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view .addSubview(arrowButton)
        arrowButton.center.x = view.center.x
        arrowButton.center.y = view.center.y
        arrowButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func buttonTapped(_ sender: ArrowButton) {
        performSegue(withIdentifier: "synthSession", sender: self)
    }
}

