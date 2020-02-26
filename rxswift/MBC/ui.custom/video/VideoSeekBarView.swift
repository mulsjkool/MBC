//
//  VideoSeekBarView.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 2/3/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import MisterFusion
import RxCocoa
import RxSwift

class VideoSeekBarView: BaseView {

    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var playingTimeLabel: UILabel!
    @IBOutlet weak private var lenghtTimeLabel: UILabel!
    @IBOutlet weak private var seekBarView: UIView!
    @IBOutlet weak private var timeSeekSlider: SeekTimeSlider!
    @IBOutlet weak private var progressiew: UIProgressView!
    
    var bufferProgress: Float! { didSet { progressiew.progress = bufferProgress } }
    
    var currentTime: Double! {
        didSet {
            updateSeekTime()
            seekedTime = currentTime
        }
    }
    
    var seekedTime: Double! { didSet { playingTimeLabel.text = Common.videoTimeFor(duration: seekedTime) } }
    var currentProgress: Float! { return timeSeekSlider.value }
    
    var videoDuration: Double! {
        didSet {
            updateSeekTime()
            lenghtTimeLabel.text = Common.videoTimeFor(duration: videoDuration)
        }
    }
    
    var timeSeekChanged: ControlProperty<Float> { return timeSeekSlider.rx.value }
    var touchExit: ControlEvent<()> { return timeSeekSlider.rx.controlEvent([.touchUpInside, .touchUpOutside]) }
    
    // MARK: Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: Private
    private func commonInit() {
        Bundle.main.loadNibNamed(R.nib.videoSeekBarView.name, owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        self.mf.addConstraints([
            self.top |==| containerView.top,
            self.left |==| containerView.left,
            self.bottom |==| containerView.bottom,
            self.right |==| containerView.right
        ])
        setupUI()
    }
    
    private func setupUI() {
        timeSeekSlider.value = 0
        timeSeekSlider.trackWidth = 4
        timeSeekSlider.setThumbImage(R.image.iconVideoThumb_slider(), for: .normal)
        timeSeekSlider.translatesAutoresizingMaskIntoConstraints = false
        timeSeekSlider.maximumTrackTintColor = UIColor.clear
        timeSeekSlider.minimumTrackTintColor = UIColor.white
        
        if Constants.DefaultValue.shouldRightToLeft {
            playingTimeLabel.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            lenghtTimeLabel.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
    }
    
    private func updateSeekTime() {
        guard currentTime != nil, videoDuration != nil, videoDuration > 0 else { return }
        timeSeekSlider.value = Float(currentTime / videoDuration)
    }
}
