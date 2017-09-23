//
//  UIDevice.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 9/21/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit
import AVFoundation

public enum DeviceTypeOrientation {
    case iPhoneLandscape
    case iPhonePortrait
    case iPadLandscape
    case iPadPortrait
    case none
}

extension UIDevice {
    
    class func getDeviceOrientation() -> DeviceTypeOrientation {
        
        let isPhone = UIDevice.current.model.contains("Phone")
        let isPortrait = UIDevice.current.orientation.isPortrait
        
        if isPhone && isPortrait {
            return DeviceTypeOrientation.iPhonePortrait
        } else if isPhone {
            return DeviceTypeOrientation.iPhoneLandscape
        } else if !isPhone && isPortrait {
            return DeviceTypeOrientation.iPadPortrait
        }
        return DeviceTypeOrientation.iPadLandscape
    }
    
    class func mapOrientationForAVCaptureOrientation() -> AVCaptureVideoOrientation? {
        
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeRight
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default: return nil
        }
    }
}
