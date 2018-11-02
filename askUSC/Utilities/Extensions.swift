//
//  Extensions.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/15/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit
import SideMenu

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
    // THIS WILL CAUSE A CRASH IF THE USER: Logs in -> Logs out -> Logs in -> Tries to open side menu
    // Use UIWindow.set instead
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
    func isViewControllerInStack(vc: UIViewController.Type) -> Bool {
        let viewControllers = SharedInfo.currentNavController.viewControllers
        var isInStack = false
        viewControllers.forEach { (VC) in
            if VC.isMember(of: vc) {
                isInStack = true
            }
        }
        return isInStack
    }
}

extension UIWindow {
    
    func setWithAnimation(rootViewController newRootViewController: UIViewController, with animation: CATransitionType) {
        let transition = CATransition()
        transition.type = animation
        set(rootViewController: newRootViewController, withTransition: transition)
        SharedInfo.currentRootViewController = newRootViewController
    }
    
    func setWithAnimationWithNav(rootViewController newRootViewController: UIViewController, with animation: CATransitionType) {
        let transition = CATransition()
        transition.type = animation
        let navC = UINavigationController(rootViewController: newRootViewController)
        set(rootViewController: navC, withTransition: transition)
        SharedInfo.currentRootViewController = newRootViewController
        SharedInfo.currentNavController = navC
    }
    
    // Fix for http://stackoverflow.com/a/27153956/849645
    func set(rootViewController newRootViewController: UIViewController, withTransition transition: CATransition? = nil) {
        
        let previousViewController = rootViewController
        
        if let transition = transition {
            // Add the transition
            layer.add(transition, forKey: kCATransition)
        }
        
        rootViewController = newRootViewController
        
        // Update status bar appearance using the new view controllers appearance - animate if needed
        if UIView.areAnimationsEnabled {
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                newRootViewController.setNeedsStatusBarAppearanceUpdate()
            }
        } else {
            newRootViewController.setNeedsStatusBarAppearanceUpdate()
        }
        
        /// The presenting view controllers view doesn't get removed from the window as its currently transistioning and presenting a view controller
        if let transitionViewClass = NSClassFromString("UITransitionView") {
            for subview in subviews where subview.isKind(of: transitionViewClass) {
                subview.removeFromSuperview()
            }
        }
        if let previousViewController = previousViewController {
            // Allow the view controller to be deallocated
            previousViewController.dismiss(animated: false) {
                // Remove the root view in case its still showing
                previousViewController.view.removeFromSuperview()
            }
        }
    }

}

extension SideMenuManager {
    // Action called when user taps on any of the cells
    func dismissSideMenuAndSwitchRootTo(ViewController: UIViewController) {
        SideMenuManager.default.menuLeftNavigationController?.dismiss(animated: true, completion: {
            UIApplication.shared.keyWindow?.setWithAnimationWithNav(rootViewController: ViewController, with: .moveIn)
        })
    }
    
}

extension Formatter {
    // Date formatter
    static let YYYYMMDD_Format: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
        return formatter
    }()
}
