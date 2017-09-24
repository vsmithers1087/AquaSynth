//
//  SynthSessionViewController.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 9/20/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit

class SynthSessionViewController: UIViewController, FrameExtractable {
    
    var frameExtractor: FrameExtractor!
    var deviceOrientation = DeviceTypeOrientation.none
    var framesCount = 0

    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var frameImageView: UIImageView!
    @IBOutlet weak var frequencyResultView: FrequencyResultView!
    @IBOutlet weak var frameImageViewTop: NSLayoutConstraint!
    @IBOutlet weak var frameImageViewLeading: NSLayoutConstraint!
    @IBOutlet weak var frequencyResultViewBottom: NSLayoutConstraint!
    @IBOutlet weak var frequencyResultViewTrailing: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
    }
    
    private func setup() {
        frameExtractor = FrameExtractor()
        frameExtractor.delegate = self
    }
    
    private func setupUI() {
        dismissButton.layer.cornerRadius = dismissButton.frame.width / 2
        dismissButton.layer.borderWidth = 0.25
        dismissButton.layer.borderColor = UIColor.gray.cgColor
        frameImageView.layer.borderWidth = 3.0
        frameImageView.layer.borderColor = UIColor.orange.cgColor
        frequencyResultView.layer.borderWidth = 3.0
        frequencyResultView.layer.borderColor = UIColor.orange.cgColor
        setupForOrientation()
    }
    
    private func setupForOrientation() {
        deviceOrientation = UIDevice.getDeviceOrientation()
        if deviceOrientation == .iPhoneLandscape {
            frameImageViewLeading.constant = (view.frame.width / 2) + 8
            frameImageViewTop.constant = 60
            frequencyResultViewTrailing.constant = (view.frame.width / 2) + 8
            frequencyResultViewBottom.constant = 40
        } else {
            frameImageViewLeading.constant = 20
            frameImageViewTop.constant = (view.frame.height / 2)
            frequencyResultViewTrailing.constant = 20
            frequencyResultViewBottom.constant = (view.frame.height / 2)
        }
        frameExtractor.updateVideoOrientationForRotation()
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
