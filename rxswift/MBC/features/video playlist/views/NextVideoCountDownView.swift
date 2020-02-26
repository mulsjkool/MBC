//
//  NextVideoCountDownView.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 3/30/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import MisterFusion
import KDCircularProgress
import RxSwift

class NextVideoCountDownView: BaseView {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var progressView: KDCircularProgress!
    @IBOutlet private weak var countDownLabel: UILabel!
    private var progressColor = Colors.unselectedTabbarItem.color()
    private var countDownTimer: Timer?
    private var countIndex = Constants.DefaultValue.videoNextVideoCountDown
    var endCountDown = PublishSubject<Void>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: Public
    func startUpdateProgess() {
        if countDownTimer == nil {
            startCountDown()
        }
    }
    
    private func endUpdateProgress() {
        resetView()
        endCountDown.onNext(())
    }
    
    func resetView() {
        countDownTimer?.invalidate()
        countDownTimer = nil
        countDownLabel.text = "\(Constants.DefaultValue.videoNextVideoCountDown)"
        countIndex = Constants.DefaultValue.videoNextVideoCountDown
    }
    
    // MARK: Private
    private func commonInit() {
        Bundle.main.loadNibNamed(R.nib.nextVideoCountDownView.name, owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        self.mf.addConstraints([
            self.top |==| containerView.top,
            self.left |==| containerView.left,
            self.bottom |==| containerView.bottom,
            self.right |==| containerView.right
        ])
        disposeBag = DisposeBag()
    }
    
    private func configProgressView() {
        progressView.trackColor = UIColor.clear
        progressView.progressColors = [progressColor]
        progressView.trackThickness = 0.2
        progressView.progressThickness = 0.2
        progressView.angle = 0
        progressView.animate(toAngle: 360, duration: Double(Constants.DefaultValue.videoNextVideoCountDown),
                             completion: nil)
    }
    
    private func startCountDown() {
        countDownTimer = Timer.scheduledTimer(
            timeInterval: TimeInterval(1.0), target: self,
            selector: #selector(countDown),
            userInfo: nil, repeats: true)
        configProgressView()
    }
    
    @objc
    private func countDown() {
        if countIndex - 1 > 0 {
            countIndex -= 1
            DispatchQueue.main.async {
                self.countDownLabel.text = "\(self.countIndex)"
            }
        } else {
            self.endUpdateProgress()
        }
    }
}
