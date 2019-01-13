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
    
    func initNavBarWithTintColor(withButtonColor buttonTintColor: UIColor) {
        navigationController?.navigationBar.tintColor = buttonTintColor
    }
    
    func initNavBar(withTitle title: String?, withTitleStyle titleStyle: String = StringStyles.name.rawValue, withClass classObj: Class?) {
        var navTitle = NSAttributedString()
        if let classObj = classObj {
            navTitle = classObj.className.set(style: titleStyle)!
        } else if let title = title {
            navTitle = title.set(style: titleStyle)!
        }
        let navLabel = UILabel()
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
    }
}

extension UIWindow {
    
    func setWithAnimation(rootViewController newRootViewController: UIViewController, with animation: CATransitionType?) {
        let transition = CATransition()
        if let animation = animation {
            transition.type = animation
        }
        set(rootViewController: newRootViewController, withTransition: transition)
        SharedInfo.currentRootViewController = newRootViewController
    }
    
    func setWithAnimationWithNav(rootViewController newRootViewController: UIViewController, with animation: CATransitionType?) {
        let transition = CATransition()
        if let animation = animation {
            transition.type = animation
        }
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
            UIApplication.shared.keyWindow?.setWithAnimationWithNav(rootViewController: ViewController, with: nil)
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
    
    struct Date {
        static let iso8601: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mmXXXXX"
            return formatter
        }()
        static let EEEEMMdyyyy: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "EEEE, MMM d, yyyy"
            return formatter
        }()
        static let EEEE: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "EEEE"
            return formatter
        }()
        static let HHmm: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "HH:mm"
            return formatter
        }()
        static let hmma: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "h:mm a"
            return formatter
        }()
    }
}

extension Date {
    var iso8601: String {
        return Formatter.Date.iso8601.string(from: self)
    }
    var EEEMMdyyyy: String {
        return Formatter.Date.EEEEMMdyyyy.string(from: self)
    }
    var EEEE: String {
        return Formatter.Date.EEEE.string(from: self)
    }
    var HHmm: String {
        return Formatter.Date.HHmm.string(from: self)
    }
    var hmma: String {
        return Formatter.Date.hmma.string(from: self)
    }
}

extension String {
    var iso8601: Date? {
        return Formatter.Date.iso8601.date(from: self)
    }
    var EEEEMMdyyyy: Date? {
        return Formatter.Date.EEEEMMdyyyy.date(from: self)
    }
    var EEEE: Date? {
        return Formatter.Date.EEEE.date(from: self)
    }
    var HHmm: Date? {
        return Formatter.Date.HHmm.date(from: self)
    }
    var hmma: Date? {
        return Formatter.Date.hmma.date(from: self)
    }
}

extension Class {
    
    func getDateStringWithFormat(format: String, isStartDate: Bool) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        formatter.timeZone = NSTimeZone.local
        if (isStartDate) {
            return formatter.string(from: start)
        } else {
            return formatter.string(from: end)
        }
    }
    
}

extension UIViewController {
    func sideMenuGestureSetup() {
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuFadeStatusBar = false
    }
    func startLinearProgressBar() {
        GlobalLinearProgressBar.shared.start()
    }
    func stopLinearProgressBar() {
        GlobalLinearProgressBar.shared.stop()
    }
}
