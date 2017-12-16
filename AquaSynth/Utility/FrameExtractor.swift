//
//  FrameExtractor.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 9/23/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit
import AVFoundation

class FrameExtractor: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private var position = AVCaptureDevice.Position.back
    private let quality = AVCaptureSession.Preset.medium
    private var permissionGranted = false
    private let captureSessionQueue = DispatchQueue(label: "captureSessionQueue")
    private let context = CIContext()
    let captureSession = AVCaptureSession()
    weak var delegate: FrameExtractable?
    
    override init() {
        super.init()
        checkPermission()
        captureSessionQueue.async { [unowned self] in
            self.configureSession()
            self.captureSession.startRunning()
        }
    }
    
    // MARK: AVSession configuration
    private func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized:
            permissionGranted = true
            print("authoried")
        case .notDetermined:
            requestPermission()
            print("not determined")
        default:
            permissionGranted = false
            print("permission granted")
        }
    }
    
    private func requestPermission() {
        captureSessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [unowned self] granted in
            self.permissionGranted = granted
            self.captureSessionQueue.resume()
        }
    }
    
    private func configureSession() {
        guard permissionGranted else { return }
        captureSession.sessionPreset = quality
        guard let captureDevice = selectCaptureDevice() else { return }
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        guard captureSession.canAddInput(captureDeviceInput) else { return }
        captureSession.addInput(captureDeviceInput)
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer"))
        guard captureSession.canAddOutput(videoOutput) else { return }
        captureSession.addOutput(videoOutput)
        guard let connection = videoOutput.connection(with: AVFoundation.AVMediaType.video) else { return }
        guard connection.isVideoOrientationSupported else { return }
        guard connection.isVideoMirroringSupported else { return }
        if let orientation = UIDevice.mapOrientationForAVCaptureOrientation() {
            connection.videoOrientation = orientation
        }
        connection.isVideoMirrored = position == .front
    }
    
    private func selectCaptureDevice() -> AVCaptureDevice? {
        return AVCaptureDevice.devices().filter {
            ($0 as AnyObject).hasMediaType(AVMediaType.video) &&
                ($0 as AnyObject).position == position
            }.first
    }
 
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let image = UIImage.imageFromSampleBuffer(sampleBuffer: sampleBuffer, filter: EdgeFilter.filterCIConvolution9Vertical) else { fatalError("Could not convert image to sample buffer") }
        DispatchQueue.main.async { [unowned self] in
            self.delegate?.capturedFrame(image: image)
        }
    }
 
    func updateVideoOrientationForRotation() {
        if let orientation = UIDevice.mapOrientationForAVCaptureOrientation() {
            captureSession.outputs.forEach({ (output) in
                if output is AVCaptureVideoDataOutput {
                    guard let connection = output.connection(with: AVFoundation.AVMediaType.video) else { return }
                    connection.videoOrientation = orientation
                }
            })
        }
    }
}
