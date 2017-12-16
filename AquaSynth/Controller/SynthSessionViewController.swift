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
    let predictionService = AsynthPredictionService(dimension: 227)
    //let resonanceSoundMap = ResonanceSoundMap(predictionsPerNote: 1, wave: triangle)
    var framesCount = 0
    
    @IBOutlet weak var frequencyLabel: UILabel!
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
            frameImageViewLeading.constant = (view.frame.width / 2) + 4
            frameImageViewTop.constant = 60
            frequencyResultViewTrailing.constant = (view.frame.width / 2) + 4
            frequencyResultViewBottom.constant = 40
        } else {
            frameImageViewLeading.constant = 8
            frameImageViewTop.constant = (view.frame.height / 2)
            frequencyResultViewTrailing.constant = 8
            frequencyResultViewBottom.constant = (view.frame.height / 2)
        }
        frameExtractor.updateVideoOrientationForRotation()
        view.layoutSubviews()
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func capturedFrame(image: UIImage) {
        frameImageView.image = applyFinishingFilter(image: image)
        framesCount += 1
        let predictionQueue = DispatchQueue(label: "predictionQueue")
        predictionQueue.async {
            if let result = self.predictionService.predict(image: image) {
                guard self.framesCount > 5 else { return }
                DispatchQueue.main.async {
                    print(result.label.rawValue)
                    if self.framesCount % 25 == 0 {
                        //self.frequencyLabel.text = self.resonanceSoundMap.playForResult(result)
                    }
                }
            }
        }
    }
    
    private func applyFinishingFilter(image: UIImage) -> UIImage {
        let rVector = CIVector(x: 15 / 255, y: 15 / 255, z: 15 / 255)
        let gVector = CIVector(x: 153 / 255, y: 153 / 255, z: 153 / 255)
        let bVector = CIVector(x: 204 / 255, y: 204 / 255, z: 204 / 255)
        let matrixParameter = ["inputRVector": rVector, "inputGVector": gVector, "inputBVector": bVector]
        let ciImage = CIImage(image: image)!
        let filteredImage = ciImage.applyingFilter("CIColorMatrix", parameters: matrixParameter)
        return UIImage(ciImage: filteredImage)
    }
}
