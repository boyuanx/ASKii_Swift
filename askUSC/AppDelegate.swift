//
//  AppDelegate.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/14/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import Valet
import UIWindowTransitions
import SideMenu

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    // MARK: Keychain
    let keychain = Valet.valet(with: Identifier(nonEmpty: "askUSC")!, accessibility: .whenUnlocked)
    
    // MARK: Google Sign-in function
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
        } else if !user.profile.email.contains("usc.edu") {
            print("Not USC email!")
            GIDSignIn.sharedInstance()?.signOut()
        } else {
            // Setting CoreInformation
            CoreInformation.shared.setUserID(ID: user.userID)
            CoreInformation.shared.setIDToken(token: user.authentication.idToken)
            CoreInformation.shared.setFullName(name: user.profile.name)
            CoreInformation.shared.setName(setFirst: true, name: user.profile.givenName)
            CoreInformation.shared.setName(setFirst: false, name: user.profile.familyName)
            CoreInformation.shared.setEmail(email: user.profile.email)
            print(CoreInformation.shared.getFullName())
            
            // Saving the access token to keychain.
            // Note: Strictly speaking, only the idToken is needed to be sent to the server since the server will contact Google and verify the token. Then the server can get all of the profile information. These are stored only for convenience.
            // See: https://developers.google.com/identity/sign-in/ios/backend-auth
            keychain.set(string: user.userID, forKey: "userID")
            keychain.set(string: user.authentication.idToken, forKey: "idToken")
            keychain.set(string: user.profile.name, forKey: "fullName")
            keychain.set(string: user.profile.givenName, forKey: "firstName")
            keychain.set(string: user.profile.familyName, forKey: "lastName")
            keychain.set(string: user.profile.email, forKey: "email")
            // Setting root controller to HomeViewController wrapped inside a UINavigationController, forever leaving the login screen behind!
            // MARK: Side Menu init
            sideMenuInit()
            homeVC = ProfileViewController()
            navigationController = UINavigationController(rootViewController: homeVC!)
            window?.setWithAnimation(rootViewController: navigationController!, with: .push)
            SharedInfo.currentRootViewController = homeVC!
            SharedInfo.currentNavController = navigationController!
            window?.makeKeyAndVisible()
        }
    }
    
    // MARK: What to do when user disconnects from Google session
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("User disconnected")
        keychain.removeObject(forKey: "idToken")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return (GIDSignIn.sharedInstance()?.handle(url as URL?, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation]))!
    }
    
    // MARK: Side Menu setup
    func sideMenuInit() {
        sideMenuNavController = UISideMenuNavigationController(rootViewController: SideMenuTableViewController())
        SideMenuManager.default.menuLeftNavigationController = sideMenuNavController
        SideMenuManager.default.menuFadeStatusBar = false
    }
    
    var window: UIWindow?
    var sideMenuNavController: UISideMenuNavigationController?
    var navigationController: UINavigationController?
    var homeVC: ProfileViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // MARK: Register attributed string styles
        StringStyleRegistry.shared.register()
        
        // MARK: Enabling IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        
        // MARK: Google Sign-in configuration
        GIDSignIn.sharedInstance()?.clientID = "415870574344-tlm5a0l0pjlaqvi3pdhrnmq0j070a0kv.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        
        // MARK: Making a new window for the application since Storyboard isn't used.
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            // If the user is already signed in, skip the login screen.
            if (GIDSignIn.sharedInstance()?.hasAuthInKeychain())! {
                GIDSignIn.sharedInstance()?.signInSilently()
            } else {
                window.rootViewController = LoginViewController()
                window.makeKeyAndVisible()
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if let window = window {
            // If the user is already signed in, skip the login screen.
            if (GIDSignIn.sharedInstance()?.hasAuthInKeychain())! {
                //GIDSignIn.sharedInstance()?.signInSilently()
            } else {
                window.setWithAnimation(rootViewController: LoginViewController(), with: .fade)
                window.makeKeyAndVisible()
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

