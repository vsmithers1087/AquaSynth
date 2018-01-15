//
//  ViewController.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 9/19/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var arrowButton: ArrowButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var backgroundWhite: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupArrowButton()
        animateImageView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }

    override func viewWillLayoutSubviews() {
        arrowButton.center.x = view.center.x
        arrowButton.center.y = view.center.y
    }
    
    private func setupUI() {
        infoButton.layer.cornerRadius = infoButton.frame.width / 2
        infoButton.layer.borderWidth = 1.5
        infoButton.layer.borderColor = UIColor.orange.cgColor
    }
    
    private func setupArrowButton() {
        arrowButton = ArrowButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view .addSubview(arrowButton)
        arrowButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    private func animateImageView() {
        UIView.animate(withDuration: 15, animations: {
            self.backgroundWhite.center.x += 100
        }) { (finished) in
            if finished {
                self.animateBack()
            }
        }
    }
    
    private func animateBack() {
        UIView.animate(withDuration: 15, animations: {
            self.backgroundWhite.center.x -= 100
        }) { (finished) in
            if finished {
                self.animateImageView()
            }
        }
    }

    
    @objc func buttonTapped(_ sender: ArrowButton) {
        performSegue(withIdentifier: "synthSession", sender: self)
    }
}

