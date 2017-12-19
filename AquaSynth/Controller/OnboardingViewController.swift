//
//  OnboardingViewController.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 12/18/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit
import Onboarding

class OnboardingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPaperOnboardingView()
    }

    private func setupPaperOnboardingView() {
        let onboarding = PaperOnboarding(itemsCount: 3)
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        // Add constraints
        for attribute: NSLayoutAttribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension OnboardingViewController: PaperOnboardingDelegate {
    
    func onboardingDidTransitonToIndex(_ index: Int) {}
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
        //    item.titleLabel?.backgroundColor = .redColor()
        //    item.descriptionLabel?.backgroundColor = .redColor()
        //    item.imageView = ...
    }
}

extension OnboardingViewController: PaperOnboardingDataSource {
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
        let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        //let itemInfo = OnboardingItemInfo(
        return [
            (UIImage(named: "IconBlack")!,
             "Hotels",
             "All hotels and hostels are sorted by hospitality rating",
             UIImage(named: "IconBlack")!,
             UIColor(red:0.40, green:0.56, blue:0.71, alpha:1.00),
             UIColor.white, UIColor.white, titleFont,descriptionFont),

            (UIImage(named: "IconBlack")!,
             "Banks",
             "We carefully verify all banks before add them into the app",
             UIImage(named: "IconBlack")!,
             UIColor(red:0.40, green:0.69, blue:0.71, alpha:1.00),
             UIColor.white, UIColor.white, titleFont,descriptionFont),

            (UIImage(named: "IconBlack")!,
             "Stores",
             "All local stores are categorized for your convenience",
             UIImage(named: "IconBlack")!,
             UIColor(red:0.61, green:0.56, blue:0.74, alpha:1.00),
             UIColor.white, UIColor.white, titleFont,descriptionFont)

            ][index]

    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardingPageItemColor(at index: Int) -> UIColor {
        return [UIColor.white, UIColor.red, UIColor.green][index]
    }
}
