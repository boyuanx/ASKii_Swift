//
//  GlobalLinearProgressBar.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/25/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit
import LinearProgressBarMaterial

class GlobalLinearProgressBar {
    
    static var shared = GlobalLinearProgressBar()
    let bar = LinearProgressBar()

    private init() {
        bar.heightForLinearBar = 1
        bar.progressBarColor = UIColor.white
        bar.backgroundProgressBarColor = SharedInfo.USC_redColor
    }
    
    func start() {
        bar.startAnimation()
    }
    
    func stop() {
        bar.stopAnimation()
    }
    
}
