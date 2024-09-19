//
//  ProductCardHeaderReusableView.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 6.08.2024.
//

import UIKit

class HomeModuleProductCardHeaderReusableView: UICollectionReusableView {
    
    @IBOutlet weak var counterContainer: UIView!
    @IBOutlet weak var counterFirst: UILabel!
    @IBOutlet weak var counterSecond: UILabel!
    @IBOutlet weak var counterThird: UILabel!
    
    private var timer: Timer?
    private var hours = 12
    private var minutes = 0
    private var seconds = 0
    
    static let headerIdentifier = "HomeModuleProductCardHeaderReusableView"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let counters = [counterContainer, counterFirst, counterSecond, counterThird]
        counters.forEach { $0?.layer.cornerRadius = 10; $0?.layer.masksToBounds = true }
        
        startTimer()
    }
    
    private func startTimer() {
        updateLabels()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
    
    @objc private func updateCountdown() {
        if seconds > 0 {
            seconds -= 1
        } else if minutes > 0 {
            minutes -= 1
            seconds = 59
        } else if hours > 0 {
            hours -= 1
            minutes = 59
            seconds = 59
        } else {
            timer?.invalidate()
            return
        }
        
        animateLabelChange()
        updateLabels()
    }
    
    private func updateLabels() {
        counterFirst.text = String(format: "%02d", hours)
        counterSecond.text = String(format: "%02d", minutes)
        counterThird.text = String(format: "%02d", seconds)
    }
    
    private func animateLabelChange() {
        UIView.transition(with: counterFirst, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.counterFirst.text = String(format: "%02d", self.hours)
        }, completion: nil)
        
        UIView.transition(with: counterSecond, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.counterSecond.text = String(format: "%02d", self.minutes)
        }, completion: nil)
        
        UIView.transition(with: counterThird, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.counterThird.text = String(format: "%02d", self.seconds)
        }, completion: nil)
    }
}
