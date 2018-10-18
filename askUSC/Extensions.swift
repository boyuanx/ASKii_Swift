//
//  Extensions.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/15/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit

// Hex color codes
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UIViewController {
    func switchRootVC(target: UIViewController, navigation: Bool) {
        if (navigation) {
            let navC = UINavigationController(rootViewController: target)
            UIApplication.shared.keyWindow?.setRootViewController(navC)
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
        } else {
            UIApplication.shared.keyWindow?.setRootViewController(target)
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
        }
    }
}
