//
//  AppDelegate.swift
//  Eco
//
//  Created by Porcescu Artiom on 8/28/20.
//  Copyright © 2020 EcoHelpers. All rights reserved.
//


import UIKit
import Firebase
import IQKeyboardManagerSwift
import GoogleMaps
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance()?.clientID = "634641409460-d4rlqlsimpiggtdr173glafq242frtm4.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self

        IQKeyboardManager.shared.enable = true
        
        GMSServices.provideAPIKey("AIzaSyDOVe5PenIJ6E0cM2AH9u_ZXjOWv6kMKkM")
        
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if user != nil{
            print("User email: \(user.profile.email ?? "No email")")}
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool{
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

