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
import AudioKit

class OnboardingViewController: UIViewController, PaperOnboardingDelegate, OnboardingContentViewDelegate{

    var finishButton: UIButton!
    var onboarding: PaperOnboarding!
    var players = [AVPlayer]()
    var imageView: UIImageView!
    var backgroundImageView: UIImageView!
    var soundMap = ResonanceSoundMap()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPaperOnboardingView()
        setupBackgroundImageView()
        setupFinishButton()
        setupImageView()
        animateImageView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AudioKit.stop()
        players.forEach { (player) in
            NotificationCenter.default.removeObserver(self, name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        }
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
        for attribute: NSLayoutAttribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding, attribute: attribute, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: 1, constant: 0)
            view.addConstraint(constraint)
        }
    }
    
    private func setupImageView() {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "iconNoBackground")
        imageView.contentMode = .scaleAspectFit
        onboarding.addSubview(imageView)
        let centerY = NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: onboarding, attribute: .centerY, multiplier: 1, constant: -100)
        let centerX = NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: onboarding, attribute: .centerX, multiplier: 1, constant: 0)
        centerY.isActive = true
        centerX.isActive = true
        view.addConstraints([centerY, centerX])
    }
    
    private func setupBackgroundImageView() {
        backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 50))
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.image = UIImage(named: "backgroundBlack")
        backgroundImageView.contentMode = .scaleAspectFit
        onboarding.insertSubview(backgroundImageView, at: 1)
    }
    
    private func setupFinishButton() {
        finishButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        finishButton.addTarget(self, action: #selector(finishOnboarding(_:)), for: .touchUpInside)
        finishButton.setTitle("Skip", for: .normal)
        finishButton.titleLabel?.font = UIFont(name: "Audiowide", size: 16.0) ?? UIFont.systemFont(ofSize: 12.0)
        finishButton.setTitleColor(UIColor.white, for: .normal)
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(finishButton)
        let top = NSLayoutConstraint(item: finishButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1.0, constant: 8)
        let trailing = NSLayoutConstraint(item: finishButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20)
        top.isActive = true
        trailing.isActive = true
        view.addConstraints([top, trailing])
    }
    
    private func animateImageView() {
        UIView.animate(withDuration: 15, animations: {
            self.backgroundImageView.center.x += 100
        }) { (finished) in
            if finished {
                self.animateBack()
            }
        }
    }
    
    private func animateBack() {
        UIView.animate(withDuration: 15, animations: {
            self.backgroundImageView.center.x -= 100
        }) { (finished) in
            if finished {
                self.animateImageView()
            }
        }
    }
    
    @objc func finishOnboarding(_ sender: UIButton) {
        players.forEach({ $0.pause() })
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.setHomeViewController()
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        soundMap.mixer.volume = 0
    }
}

extension OnboardingViewController {

    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo? {
        return nil
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        players.forEach({ $0.pause() })
        guard index != 0 else {
            imageView.isHidden = false
            return
        }
        playForIndex(index)
        imageView.isHidden =  true
        item.playerView?.layer.removeFromSuperlayer()
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
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(playerItemDidReachEnd(notification:)),
                                                   name: Notification.Name.AVPlayerItemDidPlayToEndTime,
                                                   object: player.currentItem)
        }
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        soundMap.mixer.volume = 1.0
        if index == 3 {
            finishButton.setTitle("Finish", for: .normal)
        } else {
            finishButton.setTitle("Skip", for: .normal)
        }
    }
    
    func playForIndex(_ index: Int) {
        switch index {
        case 0:
            break
        case 1:
            soundMap.playForFrequency(1, level: .noBowl)
        case 2:
            soundMap.playForFrequency(10, level: .still)
        case 3:
            soundMap.playForFrequency(11, level: .disturbed)
        default:
            break
        }
    }
    
    func getFilename(index: Int) -> String {
        switch index {
        case 0:
            return ""
        case 1:
            return "noBowl"
        case 2:
            return "still"
        case 3:
            return "disturbed"
        default:
            return  ""
        }
    }
}

extension OnboardingViewController: PaperOnboardingDataSource {
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let titleFont = UIFont(name: "Audiowide", size: 32.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
        let descriptionFont = UIFont(name: "Audiowide", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        let backgroundColor = UIColor.blue
        return [
            (PlayerView(frame: CGRect.zero, resource: ""),
             "AquaSynth",
             "A synthesizer that uses machine learning predictions as midi input. \n It is designed to be set up to read resonance patterns in a bowl of water",
             UIImage(named: "iconBackground")!,
             backgroundColor,
             UIColor.white, UIColor.white, titleFont,descriptionFont),

            (PlayerView(frame: CGRect.zero, resource: ""),
             "An Empty Scene",
             "No bowl of water will return only crickets 🦗🦗🦗.",
             UIImage(named: "iconBackground")!,
             backgroundColor,
             UIColor.white, UIColor.white, titleFont,descriptionFont),

            (PlayerView(frame: CGRect.zero, resource: ""),
             "Still Water",
             "Emits frequencies based on the calmness of the water",
             UIImage(named: "iconBackground")!,
             backgroundColor,
             UIColor.white, UIColor.white, titleFont,descriptionFont),
            
            (PlayerView(frame: CGRect.zero, resource: ""),
             "Rippling Water",
             "Emits a higher frequency and bends pitch depending of the level of agitation, and waves created in the water 🌊 🌊 🌊",
             UIImage(named: "iconBackground")!,
             backgroundColor,
             UIColor.white, UIColor.white, titleFont,descriptionFont)

            ][index]

    }
    
    func onboardingItemsCount() -> Int {
        return 4
    }

}
