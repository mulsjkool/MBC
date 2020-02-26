//
//  RadioChannelViewController.swift
//  MBC
//
//  Created by Tri Vo on 3/14/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import Kingfisher

class RadioChannelViewController: BaseViewController {
	@IBOutlet weak private var containerHeaderView: UIView!
	@IBOutlet weak private var logoImageView: UIImageView!
	@IBOutlet weak private var playButton: UIButton!
	@IBOutlet weak private var muteButton: UIButton!
	@IBOutlet weak private var showTitleLabel: UILabel!
	@IBOutlet weak private var scheduleTitleLabel: UILabel!
	@IBOutlet weak private var channelNameLabel: UILabel!
	@IBOutlet weak private var subChannelNameLabel: UILabel!
	@IBOutlet weak private var topHeaderConstraint: NSLayoutConstraint!
	@IBOutlet weak private var controlPlayerView: SwiftyInnerShadowView!
	@IBOutlet weak private var radioSocialView: RadioSocialView!
	@IBOutlet weak private var feedTableView: UITableView!
	
	private let picker = LCPicker()
	private var viewModel: RadioChannelViewModel!
	private var audioPlayer: AudioPlayer!
	private var tapGesture: UITapGestureRecognizer!
	private var adsCells = [IndexPath: AdsContainer]() // caching ads
	
	private var playAudio: Bool = false {
		didSet { playButton.setImage(playAudio ? R.image.iconRadioPause() : R.image.iconRadioPlay(), for: .normal) }
	}
	
	private var mutedAudio: Bool = false {
		didSet { muteButton.setImage(mutedAudio ? R.image.iconVideoMute() : R.image.iconVideoUnmute(), for: .normal) }
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		if #available(iOS 11.0, *) { } else {
			topHeaderConstraint.constant += Constants.DeviceMetric.statusBarHeight
		}
		setupUI()
		setupTableView()
		bindEvent()
		updateUI(subChannel: viewModel.currentSubChannel)
		viewModel.getScheduleOnDay()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.isNavigationBarHidden = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.isNavigationBarHidden = false
	}
	
	private func setupUI() {
		showTitleLabel.text = R.string.localizable.radioSchedulerSubChanelTitle()
		scheduleTitleLabel.text = R.string.localizable.radioSchedulerSubScheduleTitle()
        logoImageView.image = Constants.DefaultValue.defaulNoLogoImage
        if !viewModel.logoChannel().isEmpty {
            logoImageView.kf.setImage(with: URL(string: viewModel.logoChannel()))
        }
		containerHeaderView.backgroundColor = viewModel.headerColor
		channelNameLabel.textColor = viewModel.accentColor
		channelNameLabel.text = viewModel.titleChannel()
		
		audioPlayer = AudioPlayer(parentView: self.view)
		
		controlPlayerView.shadowLayer.shadowRadius = 15
		controlPlayerView.shadowLayer.shadowOpacity = 0.5
		controlPlayerView.shadowLayer.shadowOffset = CGSize.zero
		controlPlayerView.shadowLayer.shadowColor = UIColor.black.cgColor
		
		radioSocialView.accentColor = viewModel.accentColor
		radioSocialView.bindData(data: viewModel.socialNetworks())
	}
	
	private func setupTableView() {
		feedTableView.dataSource = self
		feedTableView.delegate = self
		feedTableView.rowHeight = UITableViewAutomaticDimension
		feedTableView.backgroundColor = Colors.defaultBg.color()
		feedTableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
		feedTableView.showsVerticalScrollIndicator = false
		feedTableView.showsHorizontalScrollIndicator = false
		feedTableView.allowsSelection = false
		feedTableView.backgroundColor = Colors.defaultBg.color()
		feedTableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
		feedTableView.separatorStyle = .none
		feedTableView.register(R.nib.radioFeedViewCell(),
							   forCellReuseIdentifier: R.reuseIdentifier.radioFeedViewCell.identifier)
		feedTableView.register(R.nib.radioAdsViewCell(),
							   forCellReuseIdentifier: R.reuseIdentifier.radioAdsViewCell.identifier)
		feedTableView.register(R.nib.videoLiveStreamingCell(),
							   forCellReuseIdentifier: R.reuseIdentifier.videoLiveStreamingCell.identifier)
	}
	
	private func bindEvent() {
		disposeBag.addDisposables([
			viewModel.onDidLoadItems.subscribe(onNext: { _ in }),
			viewModel.changedSubChannel.subscribe(onNext: { [unowned self] subChannel in
				self.updateUI(subChannel: subChannel)
			}),
			radioSocialView.onSelectedItem.subscribe(onNext: { [unowned self] social in
				if let link = social.accountId, let url = URL(string: link) {
					self.openInAppBrowser(url: url)
				}
			})
		])
	}
	
	private func addGesture() {
		view.addGestureRecognizer(tapGesture)
	}
	
	private func removeGesture() {
		view.removeGestureRecognizer(tapGesture)
	}
	
	private func updateUI(subChannel: RadioSubChannel?) {
		guard let channel = subChannel else { return }
		adsCells.removeAll()
		showTitleLabel.text = channel.channelTitle
		subChannelNameLabel.text = channel.channelTitle
		controlPlayerView.isHidden = channel.isVideo
		if !channel.isVideo {
			stopVideoLiveStreaming()
            audioPlayer.setAudioSource(mediaId: channel.id, url: channel.liveStream)
		}
		channel.isVideo ? audioPlayer.pause() : audioPlayer.play()
		playAudio = !channel.isVideo
		feedTableView.reloadData()
	}
	
	private func stopVideoLiveStreaming() {
		feedTableView.visibleCells.forEach {
			if let cell = $0 as? VideoLiveStreamingCell { cell.inlinePlayer.videoWillTerminate() }
		}
	}
	
	// MARK: - Table cell
	private func radioFeedCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier:
			R.reuseIdentifier.radioFeedViewCell.identifier) as? RadioFeedViewCell else { return UITableViewCell() }
		cell.bindData(data: viewModel.feedOfCurrentChannel(index: indexPath.row),
					  titleColor: indexPath.row == 0 ? Colors.white.color() : viewModel.headerColor,
					  textColor: indexPath.row == 0 ? UIColor.white : UIColor.black,
					  bgColor: indexPath.row == 0 ? viewModel.headerColor : Colors.radioDefaultColor.color())
		return cell
	}
	
	private func radioAdsCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier:
			R.reuseIdentifier.radioAdsViewCell.identifier) as? RadioAdsViewCell else { return UITableViewCell() }
		if let ads = adsCells[indexPath] { // requested
			if let bannerAds = ads.getBannerAds() { cell.addAds(bannerAds) }
		} else { // send request
			adsCells[indexPath] = AdsContainer(index: indexPath)
			if let ads = adsCells[indexPath] {
				ads.requestAds(adsType: .banner, viewController: self)
				ads.disposeBag.addDisposables([
					ads.loadAdSuccess.subscribe(onNext: { [unowned self] row in
						if let index = row { self.feedTableView.reloadRows(at: [index], with: .fade) }
					}),

                    ads.onOpenSafari.subscribe(onNext: { [weak self] urlString in
                        self?.openInAppBrowser(url: URL(string: urlString)!)
                    })
				])
			}
		}
		return cell
	}
	
	private func videoLiveCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier:
			R.reuseIdentifier.videoLiveStreamingCell.identifier) as? VideoLiveStreamingCell else {
				return UITableViewCell() }
		let video = Video(title: nil, rawFile: nil, duration: nil, url: viewModel.liveStreamLink(), videoThumbnail: nil)
		cell.bindData(videoItem: video, accentColor: nil)
		cell.playVideo(true)
		return cell
	}
	
	// MARK: - Public meathod
	func bindData(pageDetail: PageDetail) {
		viewModel = RadioChannelViewModel(interactor: Components.pageDetailInteractor(), pageDetail: pageDetail)
	}
	
	// MARK: - Action method
	@IBAction func closeTapped(_ sender: Any) {
		audioPlayer.audioWillTerminate()
		stopVideoLiveStreaming()
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func muteTapped(_ sender: Any) {
		mutedAudio = !mutedAudio
		audioPlayer.muted = !mutedAudio
	}
	
	@IBAction func playTapped(_ sender: Any) {
		playAudio = !playAudio
        playAudio ? audioPlayer.play(click2play: true) : audioPlayer.pause()
	}
	
	@IBAction func selectedSubChannelTapped(_ sender: Any) {
		if viewModel.listSubChannels().isEmpty { return }
		picker.show(view: self.view, data: viewModel.listSubChannels(),
					selectedIndex: viewModel.indexCurrentChannel() ?? 0,
					changeHandler: { _ in },
					doneHandler: { [weak self] index in
			self?.viewModel.updateCurrentChannel(index: index)
		})
	}
	
	@IBAction func selectedProgramTapped(_ sender: Any) {
		if viewModel.listSubSchedules().isEmpty { return }
		picker.show(view: self.view, data: viewModel.listSubSchedules(),
					selectedIndex: 0,
					changeHandler: { _ in },
					doneHandler: { [weak self] index in
						if let channelId = self?.viewModel.getSchedulesIdFrom(index) {
							self?.navigator?.pushPageDetail(pageUrl: "", pageId: channelId)
						}
		})
	}
}

// MARK: - UITableViewDataSource
extension RadioChannelViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let currentSubChannel = viewModel.currentSubChannel else { return 0 }
		return currentSubChannel.isVideo ? 1 : viewModel.amountFeedOfCurrentChannel()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let currentSubChannel = viewModel.currentSubChannel, currentSubChannel.isVideo {
			return videoLiveCell(tableView, cellForRowAt: indexPath)
		}
		
		if let radioFeed = viewModel.feedOfCurrentChannel(index: indexPath.row), radioFeed.type == .ads {
			return radioAdsCell(tableView, cellForRowAt: indexPath)
		}
		return radioFeedCell(tableView, cellForRowAt: indexPath)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if let currentSubChannel = viewModel.currentSubChannel, currentSubChannel.isVideo {
			return (Constants.DeviceMetric.screenWidth - 2 * Constants.DefaultValue.paddingVideoLiveCellLeft) *
				Constants.DefaultValue.ratio9H16W + Constants.DefaultValue.paddingVideoLiveCellTop
		}
		
		if let radioFeed = viewModel.feedOfCurrentChannel(index: indexPath.row), radioFeed.type == .ads {
			if let adsCell = adsCells[indexPath], let cellHeight = adsCell.getBannerAds()?.bounds.height {
				return cellHeight + Constants.DefaultValue.paddingBannerAdsCellBottom
								+ Constants.DefaultValue.paddingBannerAdsCellTop
			}
			return 0
		}
		
		return Constants.DefaultValue.radioFeedHeightCell
	}
}
