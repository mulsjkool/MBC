//
//  AirTimeCell.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 3/15/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class AirTimeCell: BaseTableViewCell {
    @IBOutlet weak private var thumbnailImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var statusLabel: UILabel!
    @IBOutlet weak private var statusView: UIView!
    @IBOutlet weak private var thumbnailButton: UIButton!
    @IBOutlet weak private var addButton: UIButton!
    
    let didTapThumbnail = PublishSubject<Schedule>()
    let didTapAdd = PublishSubject<Schedule>()
    
    private var item: Schedule!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.handleGifReuse()
    }
    
    func bindData(item: Schedule) {
        self.item = item
        bindThumbnail(strURL: item.channel?.logo)
        bindTitleLabel(item: item)
        bindStatusLabel(strText: item.channel?.title)
    }
    
    private func bindThumbnail(strURL: String?) {
        thumbnailImageView.setSquareImage(imageUrl: strURL, gifSupport: true)
    }
    
    private func bindTitleLabel(item: Schedule) {
        var day = item.startTime.toDateString(format: Constants.DateFormater.DayOfWeek)
        guard let type = DayOfWeeks(rawValue: day) else { return }
        day = type.localizedContentType()
        let time = item.startTime.toDateString(format: Constants.DateFormater.OnlyTime12h)
        if item.daily {
            titleLabel.text = R.string.localizable.commonDaily(time.trimAllSpace())
        } else {
            let str = day + " " + time.trimAllSpace()
            titleLabel.text = str
        }
        
    }
    
    private func bindStatusLabel(strText: String?) {
        guard let str = strText, !str.isEmpty else {
            return statusView.isHidden = true
        }
        
        statusView.isHidden = false
        statusLabel.text = str
    }
    
    override func resumeOrPauseAnimation(yOrdinate: CGFloat,
                                         viewPortHeight: CGFloat,
                                         isAVideoPlaying: Bool = false) -> (isVideo: Bool, shouldResume: Bool) {
        let gifHeight = thumbnailImageView.frame.size.height
        let yOrdinateToGif = yOrdinate + thumbnailImageView.convert(thumbnailImageView.bounds, to: self).origin.y
        
        let shouldResume = Common.shouldResumeAnimation(mediaHeight: gifHeight,
                                                        yOrdinateToMedia: yOrdinateToGif,
                                                        viewPortHeight: viewPortHeight)
        shouldResume ? thumbnailImageView.resumeGifAnimation() : thumbnailImageView.pauseGifAnimation()
        return (isVideo: false, shouldResume: false) /// TODO: To be updated
    }
    
    // MARK: - Action
    
    @IBAction func thumbnailButtonClicked(_ sender: Any) {
        self.didTapThumbnail.onNext(self.item)
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        self.didTapAdd.onNext(self.item)
    }
}
