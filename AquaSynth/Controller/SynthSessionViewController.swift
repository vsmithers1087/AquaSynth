//
//  SynthSessionViewController.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 9/20/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit

class SynthSessionViewController: UIViewController, FrameExtractable {
    
    var deviceOrientation = DeviceTypeOrientation.none
    var framesCount = 0
    
    let frameExtractor = FrameExtractor()
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var frameImageView: UIImageView!
    @IBOutlet weak var frameImageViewTop: NSLayoutConstraint!
    @IBOutlet weak var frameImageViewLeading: NSLayoutConstraint!
    @IBOutlet weak var frequencyResultHeight: NSLayoutConstraint!
    @IBOutlet weak var frequencyResultWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frameExtractor.delegate = self
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
    
    func capturedFrame(image: UIImage) {
        frameImageView.image = image
        framesCount += 1
        let predictionQueue = DispatchQueue(label: "predictionQueue")
        predictionQueue.async {
//            if let prediction = self.predictionService.predict(image: image) {
//                guard self.framesCount > 5 else { return }
//                DispatchQueue.main.async {
//                    self.label.text = prediction.label
//                    self.textView.text = "\(prediction.prob)"
//                }
//            }
        }
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
