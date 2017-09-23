//
//  EdgeFilter.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 9/23/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit

class EdgeFilter {
    
    class func filterCIConvolution9Vertical(image: CIImage) -> CIImage {
        let weightsMatrix = CIVector(values: [-2,-1,0,0,0,0,0,1,2], count: 9)
        
        let edgeResult = image.applyingFilter("CIConvolution9Vertical",
                                              parameters: [kCIInputWeightsKey: weightsMatrix]).applyingFilter("CIConvolution9Horizontal",
                                                                                                              parameters: [kCIInputWeightsKey: weightsMatrix])
        let colorKernel = CIColorKernel(
            source: "kernel vec4 xyz(__sample pixel) " +
            "{ return vec4(pixel.rgb, 1.0); }")
        
        guard let final = colorKernel?.apply(extent: (edgeResult.extent), arguments: [edgeResult]) else { fatalError("Can't apply extent")}
        return final
    }
}
