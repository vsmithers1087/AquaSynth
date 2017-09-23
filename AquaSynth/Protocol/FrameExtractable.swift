//
//  FrameExtractable.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 9/23/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit

protocol FrameExtractable: class {
    func captured(image: UIImage)
}
