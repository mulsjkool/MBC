//
//  RadioChannelView.swift
//  MBC
//
//  Created by Tri Vo on 3/14/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

class RadioChannelViewModel: BaseViewModel {
	
	private var interactor: PageDetailInteractor!
	private var pageDetail: PageDetail!
	private var subChannelsTitle = [String]()
	private var subSchedules = [Schedule]()
	private var subSchedulesTitle = [String]()
	var currentSubChannel: RadioSubChannel?
	
	var onDidLoadItems: Observable<ItemList>! /// finish loading a round
	var onWillStartGetListItem = PublishSubject<Void>()
	var onWillStopGetListItem = PublishSubject<Void>()
	var changedSubChannel = PublishSubject<RadioSubChannel>()
	private var startLoadItemsOnDemand = PublishSubject<Void>()
	
	var headerColor = Colors.defaultBg.color()
	var accentColor = Colors.defaultAccentColor.color()
	
	init(interactor: PageDetailInteractor, pageDetail: PageDetail) {
		super.init()
		self.interactor = interactor
		self.pageDetail = pageDetail
		setDefaultSubChannel()
		setHeaderColor()
		setAccentColor()
		injectAds()
		getSubChannels()
		setUpRxForGetItems()
	}
	
	// MARK: - Private method
	private func setDefaultSubChannel() {
		guard let subChannels = pageDetail.radioSubChannels else { return }
		currentSubChannel = subChannels.first(where: { $0.isDefault })
	}
	
	private func setHeaderColor() {
		guard let strHeaderColor = pageDetail.pageSettings.headerColor, !strHeaderColor.isEmpty else { return }
		headerColor = UIColor(rgba: strHeaderColor)
	}
	
	private func setAccentColor() {
		guard let strAccentColor = pageDetail.pageSettings.accentColor, !strAccentColor.isEmpty else { return }
		accentColor = UIColor(rgba: strAccentColor)
	}
	
	private func injectAds() {
		guard let subChannels = pageDetail.radioSubChannels else { return }
		subChannels.forEach { item in
			if let radioFeeds = item.feedChannel, !radioFeeds.isEmpty {
				if radioFeeds.first(where: { $0.type == .ads }) != nil { return }
				item.feedChannel?.insert(RadioFeed(type: .ads), at: 1)
			}
		}
	}
	
	private func getSubChannels() {
		guard let channels = pageDetail.radioSubChannels else { return }
		channels.forEach { item in self.subChannelsTitle.append(item.channelTitle) }
	}
	
	private func getSubPrograms(items: ItemList) {
		items.list.forEach {
			if let item = $0 as? SchedulersOnDay {
				item.list.forEach {
					self.subSchedules.append($0)
					let startTime = $0.startTime.toDateString(format: Constants.DateFormater.OnlyTime12h)
					let title = $0.channelTitle
					self.subSchedulesTitle.append(R.string.localizable.radioSchedulerFormatSchedule(startTime, title))
				}
			}
		}
	}
	
	private func setUpRxForGetItems() {
		onDidLoadItems = startLoadItemsOnDemand
			.do(onNext: { [unowned self] _ in
				self.onWillStartGetListItem.onNext(())
			})
			.flatMap { [unowned self] _ -> Observable<ItemList> in
				let fromDate = Date().startOfDay
				if let toDate = Date.addDaysFrom(currentDate: fromDate,
												 count: 0)?.endOfDay {
					return self.interactor.getSchedulerFrom(channelId: self.pageDetail.entityId,
															fromTime: fromDate.milliseconds,
															toTime: toDate.milliseconds)
											.catchError { _ -> Observable<ItemList> in
													self.onWillStopGetListItem.onNext(())
													return Observable.empty()
											}
				}
				return Observable.empty()
			}
			.do(onNext: { [unowned self] items in
				if items.list.isEmpty {
					self.onWillStopGetListItem.onNext(())
				}
			})
			.do(onNext: { [unowned self] itemList in
				self.getSubPrograms(items: itemList)
			})
	}
	
	// MARK: - Sub Schedule
	func getSchedulesIdFrom(_ index: Int) -> String? {
		if index < 0 || index > subSchedules.count - 1 { return nil }
		return subSchedules[index].channelId
	}
	
	func listSubSchedules() -> [String] {
		return subSchedulesTitle
	}
	
	// MARK: - Sub channel
	func titleChannel() -> String {
		return pageDetail.title
	}
	
	func indexCurrentChannel() -> Int? {
		guard let subChannels = pageDetail.radioSubChannels, let channel = currentSubChannel else { return nil }
		return subChannels.index(where: { channel.id == $0.id })
	}
	
	func logoChannel() -> String {
		return pageDetail.logoThumbnail
	}
	
	func updateCurrentChannel(index: Int) {
		guard let subChanel = pageDetail.radioSubChannels else { return }
		currentSubChannel = subChanel[index]
		changedSubChannel.onNext(subChanel[index])
	}
	
	func listSubChannels() -> [String] {
		return subChannelsTitle
	}
	
	// MARK: - Feed of sub channel
	func amountFeedOfCurrentChannel() -> Int {
		guard let feedChannel = currentSubChannel?.feedChannel else { return 0 }
		return feedChannel.count
	}
	
	func feedOfCurrentChannel(index: Int) -> RadioFeed? {
		guard let feedChannel = currentSubChannel?.feedChannel else { return nil }
		return feedChannel[index]
	}
	
	// MARK: - Video live streaming
	func liveStreamLink() -> String {
		guard let currentSubChannel = currentSubChannel, currentSubChannel.isVideo else { return "" }
		return currentSubChannel.liveStream
	}
	
	func socialNetworks() -> [SocialNetwork] {
		return pageDetail.socialNetworks ?? []
	}
	
	func getScheduleOnDay() {
		startLoadItemsOnDemand.onNext(())
	}
}
