//
//  VideoFullscreenLoadingNextView.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 4/11/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import MisterFusion
import KDCircularProgress
import RxSwift

class VideoFullscreenLoadingNextView: BaseView {
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var videoTitleLabel: UILabel!
    @IBOutlet weak private var videoThumbnailImageView: UIImageView!
    @IBOutlet private weak var progressView: KDCircularProgress!
    private var progressColor = Colors.unselectedTabbarItem.color()
    var progressFinish = PublishSubject<Void>()
    private var video: Video?
    
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
        Bundle.main.loadNibNamed(R.nib.videoFullscreenLoadingNextView.name, owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.mf.addConstraints([
            self.top |==| containerView.top,
            self.left |==| containerView.left,
            self.bottom |==| containerView.bottom,
            self.right |==| containerView.right
        ])
    }
    
    private func configProgressView() {
        progressView.trackColor = UIColor.clear
        progressView.progressColors = [progressColor]
        progressView.trackThickness = 0.2
        progressView.progressThickness = 0.2
        progressView.angle = 0
    }
    
    private func showTitle() {
        guard let title = self.video?.title else {
            videoTitleLabel.text = ""
            return
        }
        videoTitleLabel.text = title
    }
    
    private func showThumbnail() {
        guard let url = self.video?.videoThumbnail else {
            videoThumbnailImageView.image = nil
            return
        }
        videoThumbnailImageView.setSquareImage(imageUrl: url)
    }
    
    // MARK: Public
    func bindData(video: Video) {
        self.video = video
        showTitle()
        showThumbnail()
    }
    
    func startUpdateProgess() {
        configProgressView()
        progressView.animate(toAngle: 360, duration: Components.instance.configurations.nextAlbumLoadingTime,
                             completion: { [weak self] _ in
                                self?.progressFinish.onNext(())
        })
    }

    // MARK: IBAction
    @IBAction func buttonReloadTouch() {
        
    }
    
    @IBAction func buttonCloseTouch() {
        
    }
}
