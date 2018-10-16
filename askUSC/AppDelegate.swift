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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    // MARK: Google Sign-in function
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
        } else if !user.profile.email.contains("usc.edu") {
            print("Not USC email!")
            GIDSignIn.sharedInstance()?.signOut()
        } else {
            CoreInformation.shared.setUserID(ID: user.userID)
            CoreInformation.shared.setIDToken(token: user.authentication.idToken)
            CoreInformation.shared.setFullName(name: user.profile.name)
            CoreInformation.shared.setName(setFirst: true, name: user.profile.givenName)
            CoreInformation.shared.setName(setFirst: false, name: user.profile.familyName)
            CoreInformation.shared.setEmail(email: user.profile.email)
            print(CoreInformation.shared.getFullName())
            window?.rootViewController = HomeViewController()
        }
    }
    
    // MARK: What to do when user disconnects from Google session
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("User disconnected")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return (GIDSignIn.sharedInstance()?.handle(url as URL?, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation]))!
    }

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // MARK: Injection
        #if DEBUG
        Bundle(path: "/Applications/InjectionX.app/Contents/Resources/iOSInjection.bundle")?.load()
        #endif
        
        // MARK: Making a new window for the application since Storyboard isn't used.
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            let loginVC = LoginViewController()
            window.rootViewController = loginVC
            window.makeKeyAndVisible()
        }
        
        // MARK: Enabling IQKeyboard
        IQKeyboardManager.shared.enable = true
        
        // MARK: Google Sign-in
        GIDSignIn.sharedInstance()?.clientID = "415870574344-tlm5a0l0pjlaqvi3pdhrnmq0j070a0kv.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        

        
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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

