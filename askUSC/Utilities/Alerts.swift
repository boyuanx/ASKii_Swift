//
//  Alerts.swift
//  askUSC
//
//  Created by Boyuan Xu on 11/16/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit
import SCLAlertView

extension UIViewController {
    
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
    
    
}
