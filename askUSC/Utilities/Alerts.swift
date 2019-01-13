//
//  Alerts.swift
//  askUSC
//
//  Created by Boyuan Xu on 11/16/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit
import SCLAlertView
import Valet

extension UIViewController {
    
    func generalFailureAlert(message: String?, completion: @escaping () -> Void) {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("I understand.") {
            completion()
        }
        if let message = message {
            alert.showError("Error", subTitle: message)
            
        } else {
            alert.showError("Error", subTitle: "Something went wrong.")
        }
    }
    
    func loginFailureAlert(message: String?, completion: @escaping () -> Void) {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("I'll try again") {
            completion()
        }
        if let message = message {
            alert.showError("Error", subTitle: message)
            
        } else {
            alert.showError("Error", subTitle: "Login has failed. Please try again.")
        }
    }
    
    func enrollSuccessAlert() {
        let alert = SCLAlertView()
        alert.showSuccess("Success!", subTitle: "You are now enrolled.")
    }
    
    func enrollDuplicateAlert() {
        let alert = SCLAlertView()
        alert.showNotice("Notice", subTitle: "You are already enrolled in this class.")
    }
    
    func classCodeFormatAlert(message: String?) {
        let alert = SCLAlertView()
        if let message = message {
            alert.showError("Error", subTitle: message)
        } else {
            alert.showError("Error", subTitle: "Enter a class code!")
        }
    }
    
    func classNotInSessionAlert(message: String?) {
        let alert = SCLAlertView()
        if let message = message {
            alert.showError("Error", subTitle: message)
        } else {
            alert.showError("Error", subTitle: "Class is not in session!")
        }
    }
    
    func checkInFailureAlert(message: String) {
        let alert = SCLAlertView()
        alert.showError("Error", subTitle: message)
    }
    
    func checkInSuccessAlert(message: String) {
        let alert = SCLAlertView()
        alert.showSuccess("Success", subTitle: message)
    }
    
    func refreshingClassAlert() -> SCLAlertView {
        let alert = SCLAlertView()
        alert.showWait("Notice", subTitle: "Please wait while your information is being updated. (Alpha testers: If this is taking too long, close the app and re-open it again.)")
        return alert
    }
    
    func dismissAlert(alert: SCLAlertView) {
        alert.hideView()
    }
    
    func IOErrorAlert(message: String) {
        let alert = SCLAlertView()
        alert.showError("Error", subTitle: message)
    }
    
    func unregisterSuccessAlert() {
        let alert = SCLAlertView()
        alert.showSuccess("Error", subTitle: "You are now unregistered from this class.")
    }
    
    func unregisterFailureAlert() {
        let alert = SCLAlertView()
        alert.showError("Error", subTitle: "Failed to unregister from this class.")
    }
    
    func clearCacheAlert() {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("Delete them all!", backgroundColor: SharedInfo.USC_redColor, textColor: UIColor.white, showTimeout: nil) {
            DiskManager.shared.deleteAllMessages()
            let myValet = Valet.valet(with: Identifier(nonEmpty: "checkIn")!, accessibility: .whenUnlocked)
            myValet.set(string: "0", forKey: "lastCheckedInClass")
        }
        alert.addButton("No, take me back.") {
            self.dismissAlert(alert: alert)
        }
        alert.showWarning("Warning", subTitle: "This action will delete all stored messages. This is currently a debug feature and will be improved in the future.")
    }
    
}
