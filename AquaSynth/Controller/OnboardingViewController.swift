//
//  OnboardingViewController.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 12/18/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit
import Onboarding
import AVFoundation

class OnboardingViewController: UIViewController, PaperOnboardingDelegate, OnboardingContentViewDelegate{

    var finishButton: UIButton!
    var onboarding: PaperOnboarding!
    var players = [AVPlayer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPaperOnboardingView()
        setupFinishButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupPaperOnboardingView() {
        onboarding = PaperOnboarding(itemsCount: 4)
        onboarding.dataSource = self
        onboarding.delegate = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        // Add constraints
        for attribute: NSLayoutAttribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding, attribute: attribute, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: 1, constant: 0)
            view.addConstraint(constraint)
        }
    }
    
    private func setupFinishButton() {
        finishButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        finishButton.isHidden = true
        finishButton.addTarget(self, action: #selector(finishOnboarding(_:)), for: .touchUpInside)
        finishButton.setImage(UIImage(named: "play"), for: .normal)
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(finishButton)
        let bottom = NSLayoutConstraint(item: finishButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -30)
        let centerX = NSLayoutConstraint(item: finishButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: -8)
        bottom.isActive = true
        centerX.isActive = true
        view.addConstraints([bottom, centerX])
    }
    
    @objc func finishOnboarding(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.setHomeViewController()
    }
    
    func animateButton() {
        finishButton.isHidden = false
        UIView.animate(withDuration: 1.0) {
            self.finishButton.center.x += 75.0
        }
    }
}

extension OnboardingViewController {

    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo? {
        return nil
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        item.playerView?.layer.removeFromSuperlayer()
        players.forEach({ $0.pause() })
        if players.count < index - 1{
            players[index].play()
        } else if let url = Bundle.main.url(forResource: getFilename(index: index), withExtension: "mov"){
            let player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = CGRect(x: 0, y: 0, width: 275, height: 275)
            playerLayer.position = CGPoint(x: view.center.x, y: view.center.y - (view.frame.height / 3))
            item.layer.addSublayer(playerLayer)
            players.append(player)
            player.play()
        }
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 3 {
            animateButton()
        } else {
            finishButton.isHidden = true
        }
    }
    
    func getFilename(index: Int) -> String {
        switch index {
        case 0:
            return "noBackground"
        case 1:
            return "preview1"
        case 2:
            return "preview1"
        case 3:
            return "preview1"
        default:
            return  ""
        }
    }
}

extension OnboardingViewController: PaperOnboardingDataSource {
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let titleFont = UIFont(name: "Audiowide", size: 32.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
        let descriptionFont = UIFont(name: "Audiowide", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        
        return [
            (PlayerView(frame: CGRect.zero, resource: ""),
             "AquaSynth",
             "A synthesizer that uses machine learning predictions as midi input. \n It is designed to be setup to read resonance patterns in a bowl of water",
             UIImage(named: "iconBackground")!,
             UIColor(red:0.40, green:0.56, blue:0.71, alpha:1.00),
             UIColor.white, UIColor.white, titleFont,descriptionFont),

            (PlayerView(frame: CGRect.zero, resource: ""),
             "An Empty Scene",
             "No bowl of water will return only crickets 🦗🦗🦗.",
             UIImage(named: "iconBackground")!,
             UIColor(red:0.40, green:0.69, blue:0.71, alpha:1.00),
             UIColor.white, UIColor.white, titleFont,descriptionFont),

            (PlayerView(frame: CGRect.zero, resource: ""),
             "Still Water",
             "Emits frequencies based on the calmness of the water",
             UIImage(named: "iconBackground")!,
             UIColor(red:0.61, green:0.56, blue:0.74, alpha:1.00),
             UIColor.white, UIColor.white, titleFont,descriptionFont),
            
            (PlayerView(frame: CGRect.zero, resource: ""),
             "Rippling Water",
             "Emits frequiences depending of the level of agitation, and waves created in the water 🌊🌊🌊",
             UIImage(named: "iconBackground")!,
             UIColor(red:0.61, green:0.56, blue:0.74, alpha:1.00),
             UIColor.white, UIColor.white, titleFont,descriptionFont)

            ][index]

    }
    
    func onboardingItemsCount() -> Int {
        return 4
    }
    
    func onboardingPageItemColor(at index: Int) -> UIColor {
        return [UIColor.white, UIColor.red, UIColor.green, UIColor.orange][index]
    }
}
