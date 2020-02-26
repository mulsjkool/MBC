//
//  PageHeaderViewController.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 11/30/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Kingfisher
import MisterFusion
import RxSwift
import UIKit

class PageHeaderViewController: BaseViewController {

    @IBOutlet weak private var coverImageView: UIImageView!
    @IBOutlet weak private var posterImageView: UIImageView!
    @IBOutlet weak private var pageTitleLabel: UILabel!
    @IBOutlet weak private var airtimeLabel: UILabel!
    @IBOutlet weak private var programBarView: UIView!
    @IBOutlet weak private var channelImageView: UIImageView!
    @IBOutlet weak private var followerNumberLabel: UILabel!
    @IBOutlet weak private var coverContainViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak private var inforContainViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var pageMenuView: UIView!
    @IBOutlet weak private var pageMenuViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var topMetadataLabel: UILabel!
    @IBOutlet weak private var bottomMetadataLabel: UILabel!
    @IBOutlet weak private var remindContainView: UIView!
    @IBOutlet weak private var likeContainView: UIView!
    @IBOutlet weak private var bottomView: UIView!
    @IBOutlet weak private var sponsorView: UIView!
	@IBOutlet weak private var sponsorViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var programBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var coverContainerView: UIView!
	@IBOutlet weak private var radioLiveStreamingView: UIView!
    @IBOutlet weak private var remindViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak private var btChannelPage: UIButton!
    @IBOutlet weak private var btPopupSchedule: UIButton!
    
    private var promoVideo: Video!
    private var inlinePlayer: InlineTHEOPlayer!
	private let adsContainer = AdsContainer()
    
    private let defaultLeftMargin: CGFloat = 16.0
    private let defaultProgramBarHeight: CGFloat = 48.0
    
    var viewModel: PageHeaderViewModel!
    let selectedMenuItem = PublishSubject<PageMenuEnum>()
    var lastSelectedMenu = PageMenuEnum.undefine
    
    let promoVideoTapped = PublishSubject<Video>()
    let coverPhotoTapped = PublishSubject<String>()
    let posterPhotoTapped = PublishSubject<String>()
    let didLayoutSubviews = PublishSubject<Void>()
    let didShowProgramBar = PublishSubject<Void>()
    
    let didbtChannelPageClicked = PublishSubject<String>()
    let didbtPopupScheduleClicked = PublishSubject<[Schedule]?>()
    
    var viewHeight: CGFloat {
        if showProgramBar() {
            programBarHeightConstraint.constant = defaultProgramBarHeight
        } else {
            programBarHeightConstraint.constant = 0
        }
        self.view.layoutIfNeeded()
        return programBarView.frame.origin.y + programBarHeightConstraint.constant
            + pageMenuViewHeightConstraint.constant + bottomView.frame.size.height
    }
    
    private var menu: PageMenu!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        didLayoutSubviews.onNext(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if inlinePlayer != nil, self.promoVideo != nil {
            inlinePlayer.video = self.promoVideo
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pauseVideosWhenLeaving()
    }
    
    func bindData() {
        bindCoverAndPoster()
        bindMenu()
        bindEvents()
        bindVideo()
		bindRadioStreaming()
        bindProgramBar()
    }
    
    func requestAds(universalAddress: String = "") {
		if adsContainer.getBannerAds() == nil {
			adsContainer.requestAds(adsType: .sponsored, viewController: self, universalUrl: universalAddress)
			adsContainer.disposeBag.addDisposables([
				adsContainer.loadAdSuccess.subscribe(onNext: { [unowned self] _ in
					self.addSponsoredAds()
                }),

                adsContainer.onOpenSafari.subscribe(onNext: { [weak self] urlString in
                    self?.openInAppBrowser(url: URL(string: urlString)!)
                })
			])
		}
    }
	
	private func addSponsoredAds() {
		if let adsView = adsContainer.getBannerAds() {
			sponsorViewHeightConstraint.constant = adsView.bounds.height
			adsView.translatesAutoresizingMaskIntoConstraints = false
			sponsorView.mf.addSubview(adsView, andConstraints: [
				adsView.centerX |==| sponsorView.centerX,
				adsView.top |==| sponsorView.top
			])
		}
	}
    
    func loadAvatarForChannel() {
        let objAirTime = viewModel.pageDetail?.airTimeInformation?.first(where: { $0.isDefaultRelationship == true })
        channelImageView.setSquareImage(imageUrl: objAirTime?.channel.logo)
        
        btPopupSchedule.isHidden = false
        if let array = viewModel.scheduledChannelList, array.isEmpty {
            btPopupSchedule.isHidden = true
        }
    }
    
    private func bindCoverAndPoster() {
        setHeightCoverAndPosterView()
        self.view.layoutIfNeeded()

        pageTitleLabel.text = viewModel.pageDetail?.title ?? ""
        topMetadataLabel.text = viewModel.pageDetail?.topMetadata ?? ""
        bottomMetadataLabel.text = viewModel.pageDetail?.bottomMetadata ?? ""
        
        // Apply header color
        if let headerColorValue = viewModel.pageDetail?.pageSettings.headerColor {
            let headerColor = UIColor(rgba: headerColorValue)
            view.backgroundColor = headerColor
        }
        
        // Apply accent color
        if let accentColorValue = viewModel.pageDetail?.pageSettings.accentColor {
            let accentColor = UIColor(rgba: accentColorValue)
            remindContainView.backgroundColor = accentColor
            // Like button: If not yet liked, apply accent color
//            likeContainView.backgroundColor = accentColor
        }
    }
    
    private func setHeightCoverAndPosterView() {
        var willDisplayCover = false
        var willDisplayPoster = false
        if let coverThumbnail = viewModel.pageDetail?.coverThumbnail {
            if coverThumbnail.canOpenURL() {
                willDisplayCover = true
                coverImageView.kf
                    .setImage(with: URL(string: coverThumbnail),
                              options: [.transition(.fade(0.25)), .forceTransition])
            } else if let type = viewModel.pageDetail?.subType, let subType = PageSubType(rawValue: type) {
                willDisplayCover = (subType == .radioChannel)
            }
        }
        
        if let posterThumbnail = viewModel.pageDetail?.posterThumbnail {
            if posterThumbnail.canOpenURL() {
                willDisplayPoster = true
                posterImageView.kf
                    .setImage(with: URL(string: posterThumbnail),
                              options: [.transition(.fade(0.25)), .forceTransition])
            }
        }
        if !Constants.Singleton.isiPad {
            // With Cover and Poster
            if !willDisplayCover || !willDisplayPoster {
                // With Cover / No Poster
                if willDisplayCover {
                    self.inforContainViewRightConstraint.constant = defaultLeftMargin
                }
                    // No Cover / With Poster
                else if willDisplayPoster {
                    self.coverContainViewLeftConstraint.constant = Constants.DeviceMetric.screenWidth
                }
                    // No Cover / No Poster
                else {
                    self.inforContainViewRightConstraint.constant = defaultLeftMargin
                    self.coverContainViewLeftConstraint.constant = Constants.DeviceMetric.screenWidth
                }
            }
        }
    }

    private func bindMenu() {
        let settings = viewModel.pageDetail?.pageSettings
        
        var landingTab = lastSelectedMenu == .undefine ? PageMenuEnum.newsfeed : lastSelectedMenu
        if
            lastSelectedMenu == .undefine,
            let selectLandingTab = settings?.selectLandingTab,
            let tab = PageMenuEnum.convertFrom(stringValue: selectLandingTab) {
            landingTab = tab
        }
        
        var hiddenTabs = [PageMenuEnum]()
        if let hiddenPages = settings?.hidePageTabs {
            for page in hiddenPages {
                if let hiddenTab = PageMenuEnum.convertFrom(stringValue: page) {
                    hiddenTabs.append(hiddenTab)
                }
            }
        }
        
        var accentColor = Colors.defaultAccentColor.color()
        if settings?.accentColor != nil { accentColor = UIColor(rgba: (settings?.accentColor!)!) }
        
        let toShowMenuTab = settings?.showMenuTabs ?? true
        
        menu = PageMenu(landingTab: landingTab,
                        hiddenTabs: hiddenTabs,
                        accentColor: accentColor,
                        showMenuTabs: toShowMenuTab,
                        aboutTabTitle: viewModel.pageDetail?.pageAboutTab.tabName)
        pageMenuView.addSubview(menu)
        pageMenuView.backgroundColor = UIColor.white
        
        if lastSelectedMenu == .undefine {
            menu.translatesAutoresizingMaskIntoConstraints = false
            pageMenuView.mf.addConstraints(
                menu.top |==| pageMenuView.safeArea.top,
                menu.centerX |==| pageMenuView.centerX,
                menu.bottom |==| pageMenuView.safeArea.bottom
            )
            lastSelectedMenu = landingTab
        }
        
        if !toShowMenuTab {
            pageMenuViewHeightConstraint.constant = 0
        }
    }
    
    private func bindEvents() {
        disposeBag.addDisposables([
            menu.selectedMenuItem.subscribe(onNext: { [weak self] item in
                self?.lastSelectedMenu = item
                self?.selectedMenuItem.onNext(item)
            })
        ])
        
        coverImageView.isUserInteractionEnabled = true
        let coverImageTapGesture = UITapGestureRecognizer()
        coverImageView.addGestureRecognizer(coverImageTapGesture)
        
        coverImageTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                if let coverThumbnail = self.viewModel.pageDetail?.coverThumbnail {
                    self.coverPhotoTapped.onNext(coverThumbnail)
                }
            })
            .disposed(by: disposeBag)
        
        posterImageView.isUserInteractionEnabled = true
        let posterImageTapGesture = UITapGestureRecognizer()
        posterImageView.addGestureRecognizer(posterImageTapGesture)
        
        posterImageTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                if let posterThumbnail = self.viewModel.pageDetail?.posterThumbnail {
                    self.posterPhotoTapped.onNext(posterThumbnail)
                }
            })
            .disposed(by: disposeBag)
    }
	
	private func bindRadioStreaming() {
		
		if let pageDetail = viewModel.pageDetail, let type = pageDetail.subType,
			let subType = PageSubType(rawValue: type), let accentColor = pageDetail.pageSettings.accentColor {
			radioLiveStreamingView.isHidden = !(subType == .radioChannel)
			radioLiveStreamingView.backgroundColor = UIColor(rgba: accentColor).withAlphaComponent(0.8)
			radioLiveStreamingView.layer.cornerRadius = radioLiveStreamingView.bounds.height / 2
			radioLiveStreamingView.layer.masksToBounds = false
			radioLiveStreamingView.layer.shadowRadius = 12
			radioLiveStreamingView.layer.shadowOpacity = 1.0
			radioLiveStreamingView.layer.shadowColor = Color.black.cgColor
			radioLiveStreamingView.layer.shadowOffset = CGSize.zero
		}
	}
    
    // MARK: - Action
    
    @IBAction func btChannelPageClicked(_ sender: Any) {
        guard let viewModel = self.viewModel, let pageDetail = viewModel.pageDetail else { return }
        guard let arrayAirTime = pageDetail.airTimeInformation, !arrayAirTime.isEmpty,
        let objAirTime = arrayAirTime.first(where: { $0.isDefaultRelationship == true }) else { return }
        self.didbtChannelPageClicked.onNext((objAirTime.channel.id))
    }
    
    @IBAction func btPopupScheduleClicked(_ sender: Any) {
        self.didbtPopupScheduleClicked.onNext((viewModel.scheduledChannelList))
    }
    
    @IBAction func liveStreamingTapped(_ sender: Any) {
        guard let pageDetail = viewModel.pageDetail else { return }
        showPopupRadioChannel(pageDetail: pageDetail)
    }
    
    // MARK: Program bar
    
    // swiftlint:disable:next cyclomatic_complexity
    private func bindProgramBar() {
        if !showProgramBar() { return }
        
        btPopupSchedule.isHidden = true
        self.didShowProgramBar.onNext(())
        
        guard let viewModel = self.viewModel, let pageDetail = viewModel.pageDetail else { return }
        guard let arrayAirTime = pageDetail.airTimeInformation, !arrayAirTime.isEmpty,
        let objAirTime = arrayAirTime.first(where: { $0.isDefaultRelationship == true }) else { return }
        
        airtimeLabel.text = ""
        if remindContainView.isHidden {
            remindViewWidthConstraint.constant = 0
        } else {
            remindViewWidthConstraint.constant = Constants.DefaultValue.RemindViewWidth
        }
        if objAirTime.interval == Constants.ConfigurationAirTimeInformation.daily {
            //Has a show is showing
            if isShowOnAir(obj: objAirTime) {
                airtimeLabel.text = R.string.localizable.commonNow()
                return
            }
            
            let startTime = Date.dateFromTimestamp(miniSecond: objAirTime.startTime)
            airtimeLabel.text = R.string.localizable.commonDaily(
                startTime.toDateString(format: Constants.DateFormater.OnlyTime12h))

            return
        }
        
        if objAirTime.interval == Constants.ConfigurationAirTimeInformation.weekly {
            airtimeLabel.text = objAirTime.displayStartTime
            guard let arrayRepeatOn = objAirTime.repeatOn, !arrayRepeatOn.isEmpty else { return }
            
            // Show is Scheduled more than three days in the week
            if arrayRepeatOn.count > 3 {
                let startTime = Date.dateFromTimestamp(miniSecond: objAirTime.startTime)
                let str = makeStringFromArrayMoreThan3Days(array: arrayRepeatOn,
                                        startTime: startTime.toDateString(format: Constants.DateFormater.OnlyTime12h))
                airtimeLabel.text = str
                return
            }
            
            // Show is Scheduled less than three days in the week
            var str = ""
            if arrayRepeatOn.count == 1 {
                let startTime = Date.dateFromTimestamp(miniSecond: objAirTime.startTime)
                str = startTime.toDateString(format: Constants.DateFormater.OnlyTime12h) + " "
                    + makeStringFromArrayLessThanOrEqual3Days(array: arrayRepeatOn)
            } else {
                let startTime = Date.dateFromTimestamp(miniSecond: objAirTime.startTime)
                let days = makeStringFromArrayLessThanOrEqual3Days(array: arrayRepeatOn)
                str = R.string.localizable.commonEvery(days,
                                                    startTime.toDateString(format: Constants.DateFormater.OnlyTime12h))
            }
            
            //Has a show on today
            if hasShowOnToday(array: arrayRepeatOn) {
                //Has a show is showing
                if isShowOnAir(obj: objAirTime) {
                    airtimeLabel.text = R.string.localizable.commonNow()
                    return
                }
                
                let startTime = Date.dateFromTimestamp(miniSecond: objAirTime.startTime)
                var str = ""
                if startTime.time.hour < Constants.DefaultValue.timeTonightFrom21h00 {
                    str = R.string.localizable.commonToday(
                        startTime.toDateString(format: Constants.DateFormater.OnlyTime12h))
                } else {
                    str = R.string.localizable.commonTonight(
                        startTime.toDateString(format: Constants.DateFormater.OnlyTime12h))
                }
                airtimeLabel.text = str
                return
            }
            
            //Has a show on tomorrow
            if hasShowOnTomorrow(array: arrayRepeatOn) {
                let startTime = Date.dateFromTimestamp(miniSecond: objAirTime.startTime)
                let str = R.string.localizable.commonTomorrow(
                    startTime.toDateString(format: Constants.DateFormater.OnlyTime12h))
                airtimeLabel.text = str
                return
            }
        
            airtimeLabel.text = str
        }
    }
    
    private func showProgramBar() -> Bool {
        //When page type != show, we don't show the program bar
        guard let viewModel = self.viewModel, let pageDetail = viewModel.pageDetail else { return false }
        let pageType = PageType(rawValue: pageDetail.type) ?? PageType.other
        if pageType != .show && pageType != .channel { return false }
        
        guard let arrayAirTime = pageDetail.airTimeInformation, !arrayAirTime.isEmpty,
        let objAirTime = arrayAirTime.first(where: { $0.isDefaultRelationship == true }) else { return false }
        
        let startDate = Date.dateFromTimestamp(miniSecond: objAirTime.startDate)
        let endDate = Date.dateFromTimestamp(miniSecond: objAirTime.endDate)
        let currentDate = Date()
        
        //When current time is not between star date and end date, we don't show the program bar
        if startDate.isGreaterThanDate(dateToCompare: currentDate) { return false }
        if endDate.isLessThanDate(dateToCompare: currentDate) { return false }
        
        return true
    }
    
    private func isShowOnAir(obj: AirTimeInformation) -> Bool {
        let startDate = Date.dateFromTimestamp(miniSecond: obj.startTime)
        let endDate = Date.dateFromTimestamp(miniSecond: obj.endTime)
        let currentDate = Date()
        
        //When start time, end time, current time are the same hour
        if startDate.hour == currentDate.hour && endDate.hour == currentDate.hour {
            if startDate.minute <= currentDate.minute && endDate.minute >= currentDate.hour {
                return true
            }
        }
        
        //When start time and end time are different hour, and start time or end time can equal current time
        if startDate.hour <= currentDate.hour && endDate.hour >= currentDate.hour {
            return true
        }
        
        return false
    }
    
    private func makeStringFromArrayLessThanOrEqual3Days(array: [RepeatOn]) -> String {
        if array.count == 1 {
            if let type = DayOfWeeks(rawValue: array[0].value) { return type.localizedContentType() }
            return ""
        }
        
        //Items count > 1 and <= 3
        var strTemp = ""
        var index = 0
        for item in array {
            if let type = DayOfWeeks(rawValue: item.value) {
                if index < array.count - 1 {
                    strTemp += type.localizedContentType() + " \(R.string.localizable.commonAnd()) "
                } else if index == array.count - 1 {
                    strTemp += type.localizedContentType()
                }
            }
            index += 1
        }
        return strTemp
    }
    
    private func makeStringFromArrayMoreThan3Days(array: [RepeatOn], startTime: String) -> String {
        if let objFirst = array.first, let objLast = array.last {
            if let beginDay = DayOfWeeks(rawValue: objFirst.value), let endDay = DayOfWeeks(rawValue: objLast.value) {
                let strTemp = R.string.localizable.commonFromTo(startTime, beginDay.localizedContentType(),
                                                                endDay.localizedContentType())
                return strTemp
            }
        }
        
        return ""
    }
    
    private func hasShowOnToday(array: [RepeatOn]) -> Bool {
        if array.first(where: { $0.value == Date().toDateString(format: Constants.DateFormater.DayOfWeek) }) != nil {
            return true
        }
        return false
    }
    
    private func hasShowOnTomorrow(array: [RepeatOn]) -> Bool {
        guard let currentDayType = DayOfWeeks(rawValue:
            Date().toDateString(format: Constants.DateFormater.DayOfWeek)) else { return false }
        for item in array {
            if let type = DayOfWeeks(rawValue: item.value) {
                if type.idContent() - currentDayType.idContent() == 1 { return true }
            }
        }
        return false
    }
    
    // MARK: Video
    
    func bindVideo() {
        guard let video = self.viewModel.pageDetail?.promoVideo else {
            coverImageView.isHidden = false
            return
        }
        coverContainViewLeftConstraint.constant = 0
        coverImageView.isHidden = true
        
        if inlinePlayer == nil {
            inlinePlayer = InlineTHEOPlayer(inlineOfView: coverContainerView)
            inlinePlayer.muted = true
            inlinePlayer.video = video
            inlinePlayer.isAudioHidden = true
            self.promoVideo = video
            inlinePlayer.theoPlayer.frame = CGRect(x: 0, y: 0,
                                                   width: coverContainerView.frame.size.width,
                                                   height: coverContainerView.frame.size.height)
            disposeBag.addDisposables([
                inlinePlayer.videoPlayerTapped.subscribe({ [unowned self] _ in
                    _ = self.playVideo(false)
                    self.promoVideoTapped.onNext(self.promoVideo)
                }),
                
                inlinePlayer.endVideoEvent.subscribe({ [unowned self] _ in
                    self.inlinePlayer.video.currentTime.value = 0
                    self.inlinePlayer.video.hasEnded.value = false
                    _ = self.playVideo(true)
                })
            ])
        }
        _ = playVideo(true)
    }
    
    func videoHasEnded() -> Bool {
        guard let viewModel = self.viewModel else { return true }
        guard let theVideo = viewModel.pageDetail?.promoVideo else { return true }
        return theVideo.hasEnded.value
    }
    
    private func playVideo(_ toPlay: Bool) -> Bool {
        guard inlinePlayer != nil, self.promoVideo != nil, !self.promoVideo.hasEnded.value
            else { return false }
        return inlinePlayer.resumePlaying(toResume: toPlay, autoNext: false)
    }
    
    override func resumeOrPauseAnimation(yOrdinate: CGFloat,
                                         viewPortHeight: CGFloat,
                                         isAVideoPlaying: Bool = false) -> (isVideo: Bool, shouldResume: Bool) {
        return updateVideoAutoPlay(yOrdinate: yOrdinate,
                                   viewPortHeight: viewPortHeight, isAVideoPlaying: isAVideoPlaying)
    }
    
    private func updateVideoAutoPlay(yOrdinate: CGFloat,
                                     viewPortHeight: CGFloat,
                                     isAVideoPlaying: Bool) -> (isVideo: Bool, shouldResume: Bool) {
        
        guard let viewModel = self.viewModel, viewModel.pageDetail?.promoVideo != nil else {
            return (isVideo: false, shouldResume: false)
        }
        
        if isAVideoPlaying {
            _ = playVideo(false)
            inlinePlayer.videoWillTerminate()
            return (isVideo: true, shouldResume: true)
        }

        let videoHeight = inlinePlayer.parentView.frame.size.height
        let yOrdinateToVideo = yOrdinate + self.view.convert(inlinePlayer.parentView.bounds, to: self.view).origin.y
                                         + self.sponsorViewHeightConstraint.constant
        let shouldResume = Common.shouldResumeAnimation(mediaHeight: videoHeight,
                                                        yOrdinateToMedia: yOrdinateToVideo,
                                                        viewPortHeight: viewPortHeight)
        if !shouldResume {
            inlinePlayer.video.hasEnded.value = false
            inlinePlayer.videoWillTerminate()
        }
        return (isVideo: true, shouldResume: playVideo(shouldResume))
    }
	
    func pauseVideosWhenLeaving() {
        if let inlinePlayer = inlinePlayer {
            inlinePlayer.resumePlaying(toResume: false, autoNext: false)
        }
    }
}
