//
//  SynthSessionViewController.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 9/20/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit

class SynthSessionViewController: UIViewController {
    
    var deviceOrientation = DeviceTypeOrientation.none
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var frameImageView: UIImageView!
    @IBOutlet weak var frameImageViewTop: NSLayoutConstraint!
    @IBOutlet weak var frameImageViewLeading: NSLayoutConstraint!
    @IBOutlet weak var frequencyResultHeight: NSLayoutConstraint!
    @IBOutlet weak var frequencyResultWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setupForOrientation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupUI() {
        dismissButton.layer.cornerRadius = dismissButton.frame.width / 2
        dismissButton.layer.borderWidth = 0.25
        dismissButton.layer.borderColor = UIColor.gray.cgColor
        setupForOrientation()
    }
    
    private func setupForOrientation() {
        deviceOrientation = UIDevice.getDeviceOrientation()
        if deviceOrientation == .iPhoneLandscape {
            frameImageViewLeading.constant = view.frame.width / 2
            frameImageViewTop.constant = 0
            frequencyResultWidth.constant = view.frame.width / 2
            frequencyResultHeight.constant = view.frame.height - 100
        } else {
            frameImageViewLeading.constant = 0
            frameImageViewTop.constant = view.frame.height / 2
            frequencyResultWidth.constant = view.frame.width
            frequencyResultHeight.constant = view.frame.height / 2
        }
        view.layoutSubviews()
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
