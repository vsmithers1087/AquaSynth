//
//  AppDelegate.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 9/19/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setOnboardingViewController()
        return true
    }
    
    func setHomeViewController() {
        let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        window?.rootViewController = homeViewController
    }

    func setOnboardingViewController() {
        
        guard !UserDefaults.standard.bool(forKey: "OnboardingViewed") else {
            setHomeViewController()
            return
        }
        
        let onBoardingViewController = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
        window?.rootViewController = onBoardingViewController
        UserDefaults.standard.set(true, forKey: "OnboardingViewed")
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if window?.rootViewController is OnboardingViewController {
            return .portrait
        } else {
            return .all
        }
    }
    
}

