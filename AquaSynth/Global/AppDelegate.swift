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

    private func setOnboardingViewController() {
        let onBoardingViewController = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
        window?.rootViewController = onBoardingViewController
    }
}

