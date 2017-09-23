//
//  UIImage.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 9/23/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit
import AVFoundation

extension UIImage {
    
    open static func toPixelBuffer(image: UIImage, dimension: Int ) -> CVPixelBuffer? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: dimension, height: dimension), true, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: dimension, height: dimension))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else { return nil }
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        context?.translateBy(x: 0, y: newImage.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        UIGraphicsPushContext(context!)
        newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        return pixelBuffer
    }
    
    open static func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer, filter: (CIImage) -> CIImage) -> UIImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let filtered = filter(ciImage)
        let ciContext = CIContext(options: nil)
        guard let cgImage = ciContext.createCGImage(filtered, from: filtered.extent) else {print("Can't get cgimage"); return nil}

        //get bits per component, bytes per row, colorspace, and bit map info of original image
        let bitsPerComponent = cgImage.bitsPerComponent
        let bytesPerRow = cgImage.bytesPerRow
        guard let colorSpace = cgImage.colorSpace else { print("can't get colorspace"); return nil }
        let bitmapInfo = cgImage.bitmapInfo
        
        //create context from dimensions, and compenent, bytes, colorspace and map info values from ciimage
        guard let context = CGContext.init(data: nil, width: 227, height: 227, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue, releaseCallback: nil, releaseInfo: nil) else { print("can't create context"); return nil}
        
        //set quality to high
        context.interpolationQuality = CGInterpolationQuality.high
        
        //create rect from new width and height, and draw to it with context
        let newRect = CGRect(origin: CGPoint.zero, size: CGSize(width: CGFloat(225), height: CGFloat(225)))
        context.draw(cgImage, in: newRect)
        
        //get the scaled image from the context, cast it back to CIImage and return.
        guard let scaledImage = context.makeImage() else { print("can't get scaled image"); return nil }
        //let returnImage = CIImage(cgImage: scaledImage)
        // guard let cgImage = context.createCGImage(filtered, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: scaledImage)
    }
}
