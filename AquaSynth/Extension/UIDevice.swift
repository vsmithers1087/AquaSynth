//
//  UIDevice.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 9/21/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit

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
}
