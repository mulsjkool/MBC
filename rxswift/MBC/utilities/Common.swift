//
//  Common.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/29/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import MisterFusion
import TTTAttributedLabel
import THEOplayerSDK
import UIKit
import AVFoundation

func delay(_ delay: Double, closure:@escaping () -> Void) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
        execute: closure)
}

class Common {
    
    // MARK: Public functions
    static func generalAnimate(duration: Double = Constants.DefaultValue.animateDuration,
                               animation: @escaping () -> Void ) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut,
                       animations: animation)
    }
    
	static func formatDurationFrom(_ time: Int?) -> String {
		guard let duration = time else { return "" }
        let (h, m, s) = (duration / 3600, (duration % 3600) / 60, (duration % 3600) % 60)
        return h > 0 ? String(format: Constants.DefaultValue.videoRemainingTimeWithHour, h, m, s) :
            String(format: Constants.DefaultValue.videoRemainingTime, m, s)
    }
    
    static func fillGradientFor(view: UIView, size: CGSize? = nil, colors: [CGColor], locations: [NSNumber]) {
        let gradientView = CAGradientLayer()
        if let size = size {
            gradientView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        } else {
            gradientView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        }
        gradientView.colors = colors
        gradientView.locations = locations
        view.layer.insertSublayer(gradientView, at: 0)
    }
    
    static func setupDescriptionFor(label: TTTAttributedLabel, whenExpanding: Bool,
                                    maxLines: Int, linkColor: UIColor?, delegate: TTTAttributedLabelDelegate) {
        label.activeLinkAttributes = nil
        label.isUserInteractionEnabled = true
        label.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
        label.enabledTextCheckingTypes = NSTextCheckingResult.CheckingType.link.rawValue
        if whenExpanding {
            Common.setupTapEventFor(label: label, delegate: delegate)
            return
        }
        
        let color = linkColor ?? Colors.defaultAccentColor.color()
        
        let attText = label.attributedText!
        let labelWidth = label.bounds.size.width
        let numberOfLines = attText.getNumberOfLines(withConstraintWidth: labelWidth)
        if numberOfLines <= maxLines {
            Common.setupTapEventFor(label: label, delegate: delegate)
            return
        }
        
        label.linkAttributes = nil
        label.delegate = delegate
        
        let readMoreText = R.string.localizable.commonCardLinkReadMore().localized()
        
        // generate text with readmore
        var index = 1
        var truncatedText = attText.attributedSubstring(from: NSRange(location: 0, length: index))
        truncatedText = truncatedText.appendText(readMoreText)
        while truncatedText.getNumberOfLines(withConstraintWidth: labelWidth) <= maxLines {
            index += 1
            truncatedText = attText.attributedSubstring(from: NSRange(location: 0, length: index))
            truncatedText = truncatedText.appendText(readMoreText)
        }
        truncatedText = attText.attributedSubstring(from: NSRange(location: 0, length: index - 1))
        truncatedText = truncatedText.appendText(readMoreText)
        
        // Add More button's tap event
        label.attributedText = truncatedText
        let range = NSRange(location: truncatedText.length - readMoreText.length, length: readMoreText.length)
        label.addLink(to: Constants.DefaultValue.CustomUrlForMoreText, with: range)
        let postTextRange = NSRange(location: 0, length: truncatedText.length - readMoreText.length)
        label.addLink(to: Constants.DefaultValue.CustomUrlForPostText, with: postTextRange)
        
        let mutableAttributedText = NSMutableAttributedString(attributedString: truncatedText)
        mutableAttributedText.addAttribute(kCTForegroundColorAttributeName as NSAttributedStringKey,
                                           value: color, range: range)
        label.attributedText = mutableAttributedText
    }
    
    static func createLoadingPlaceHolderCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: Constants.DefaultValue.PlaceHolderLoadingCellId)
        let loadingHolderView = MBCLoadingPlaceHolderView(frame: CGRect(x: 0, y: 0,
                                                            width: Constants.DeviceMetric.screenWidth,
                                                            height: Constants.DefaultValue.PlaceHolderLoadingHeight))
        loadingHolderView.startShimmering()
        cell.contentView.addSubview(loadingHolderView)
        cell.selectionStyle = .none
        return cell
    }
    
    static func createLoadMoreCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: Constants.DefaultValue.LoadMoreCellId)
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.startAnimating()
        cell.contentView.addSubview(indicator)
        cell.separatorInset = UIEdgeInsets(top: 0, left: Constants.DeviceMetric.screenWidth, bottom: 0, right: 0)
        cell.backgroundColor = UIColor.clear
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.mf.addConstraints(
            indicator.centerX |==| cell.contentView.centerX,
            indicator.centerY |==| cell.contentView.centerY
        )
        
        return cell
    }
    
    static func createDummyCellWith(title: String) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = Colors.defaultBg.color(alpha: 0.5)
        cell.textLabel?.text = title
        return cell
    }
    
    static func shouldResumeAnimation(mediaHeight: CGFloat, yOrdinateToMedia: CGFloat,
                                      viewPortHeight: CGFloat) -> Bool {
        var visibleHeight: CGFloat
        if yOrdinateToMedia >= 0 {
            visibleHeight = mediaHeight
            // truncated bottom
            if yOrdinateToMedia + mediaHeight > viewPortHeight { visibleHeight = viewPortHeight - yOrdinateToMedia }
        } else {
            visibleHeight = mediaHeight + yOrdinateToMedia
            if visibleHeight > viewPortHeight { visibleHeight = viewPortHeight }
        }
        
        return visibleHeight >= mediaHeight * Constants.DefaultValue.mediaContentRatioToPlay
    }
    
    static func setAnimationFor(cell: BaseTableViewCell, viewPort: UIView,
								isAVideoPlaying: Bool = false, overlapHeight: CGFloat = 0)
							-> (isVideo: Bool, shouldResume: Bool) {
        let yOrdinate = cell.convert(cell.bounds, to: viewPort).origin.y
        let viewHeight = viewPort.frame.size.height - overlapHeight
        return cell.resumeOrPauseAnimation(yOrdinate: yOrdinate,
                                           viewPortHeight: viewHeight, isAVideoPlaying: isAVideoPlaying)
    }
    
    static func setAnimationFor(viewController: BaseViewController, viewPort: UIView,
                                isAVideoPlaying: Bool = false) -> (isVideo: Bool, shouldResume: Bool) {
        let yOrdinate = viewController.view.convert(viewController.view.bounds, to: viewPort).origin.y
        let viewHeight = viewPort.frame.size.height
        return viewController.resumeOrPauseAnimation(yOrdinate: yOrdinate,
                                           viewPortHeight: viewHeight, isAVideoPlaying: isAVideoPlaying)
    }
    
    static func repeatCall(times: Int = 5, withDelay: Double = 0.5, repeated: @escaping (() -> Void)) {
        if times <= 0 { return }
        repeated()
        DispatchQueue.main.asyncAfter(deadline: .now() + withDelay) {
            self.repeatCall(times: times - 1, withDelay: withDelay, repeated: repeated)
        }
    }
    
    static func setStatusBarColor(_ color: UIColor) {
        if let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = color
        }
    }
    
    static func resetVideoPlayingStatusFor(table: UITableView) {
        let visibleCells = table.visibleCells
        for cell in visibleCells where cell is BaseCardTableViewCell {
            guard let cardCell = cell as? BaseCardTableViewCell, let theVideo = cardCell.video,
                theVideo.hasEnded.value else { continue }
            theVideo.hasEnded.value = false
            theVideo.currentTime.value = 0
        }
    }
    
    static func videoTimeFor(duration: Double) -> String {
        let intValue = Int(duration)
        let mintues = intValue / 60
        let seconds = intValue % 60
        return String(format: Constants.DefaultValue.videoRemainingTime, mintues, seconds)
    }
    
    static func topViewControllerWithRootViewController(rootViewController: UIViewController!) -> UIViewController? {
        if rootViewController == nil { return nil }
        if rootViewController is UITabBarController {
            return topViewControllerWithRootViewController(
                rootViewController: (rootViewController as? UITabBarController)?.selectedViewController)
        } else if rootViewController is UINavigationController {
            return topViewControllerWithRootViewController(
                rootViewController: (rootViewController as? UINavigationController)?.visibleViewController)
        } else if rootViewController.presentedViewController != nil {
            return topViewControllerWithRootViewController(
                rootViewController: rootViewController.presentedViewController)
        }
        return rootViewController
    }
    
    static func getContentPageTypeFromFeed(feed: Feed?) -> ContentPageType {
        guard let obj = feed, let feedType = FeedType(rawValue: obj.type) else { return .postText }
        
        func postContentType(feed: Feed) -> ContentPageType {
            guard let sType = obj.subType, let feedSubType = FeedSubType(rawValue: sType) else { return .postText }
            switch feedSubType {
            case .text:
                return .postText
            case .image:
                return .postImage
            case .video:
                return .postVideo
            case .embed:
                return .postEmbed
            case .episode:
                return .postEpisode
            }
        }
        
        switch feedType {
        case .article:
            return .article
        case .bundle:
            return .bundle
        case .app:
            return .app
        case .post:
            return postContentType(feed: obj)
        default:
            return .postText
        }
    }
    
    static func heightOfWebViewContent(webView: UIWebView) -> CGFloat? {
        if let heightStr = webView.stringByEvaluatingJavaScript(from: "document.body.scrollHeight;"),
            let height = NumberFormatter().number(from: heightStr),
            let widthStr = webView.stringByEvaluatingJavaScript(from: "document.body.scrollWidth;"),
            let width = NumberFormatter().number(from: widthStr) {
            
            let newWidth = Constants.DeviceMetric.screenSize.width -
                2 * Constants.DefaultValue.defaultMargin
            let newHeight = newWidth * CGFloat(height.floatValue) / CGFloat(width.floatValue)
            return newHeight
        }
        return nil
    }
    
    static func fetchFeed(entity: FeedEntity?) -> Feed? {
        guard let entity = entity, let feedType = FeedType(rawValue: entity.type) else { return nil }
        
        switch feedType {
        case .post:
            return Post(entity: entity)
        case .page:
            return Page(entity: entity)
        case .article:
            return Article(entity: entity)
        case .app:
            return App(entity: entity)
        case .bundle:
            return BundleContent(entity: entity)
        case .playlist:
            return Playlist(entity: entity)
        default:
            return nil
        }
    }
    
    static func setupSearchBar(searchBar: BaseSearchBar, navigationItem: UINavigationItem) -> SearchBarContainerView {
        searchBar.placeholder = R.string.localizable.commonSearchBarPlaceholder().localized()
        let searchBarContainer = SearchBarContainerView(customSearchBar: searchBar, navBarItem: navigationItem)
        navigationItem.titleView = searchBarContainer
        return searchBarContainer
    }
    
    static func setupNavigationBar(_ navigationBar: UINavigationBar?) {
        UINavigationBar.appearance().tintColor = Colors.white.color()
        UINavigationBar.appearance().barTintColor = Colors.dark.color()
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        UINavigationBar.appearance().backIndicatorImage = R.image.iconNavigationArrowBack()
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = R.image.iconNavigationArrowBack()
        navigationBar?.barStyle = .black
    }
	
	static func convertDurationToSeconds(data: String?) -> Int {
		guard let time = data else { return 0 }
		let subTimes = time.components(separatedBy: Constants.DefaultValue.TimeSeparator).map { Double($0) }
		var duration: Double = 0
		if subTimes.count == 1, let second = subTimes[0] {
			duration = second
		} else if subTimes.count == 2, let second = subTimes[1], let minute = subTimes[0] {
			duration = second + minute * 60
		} else if subTimes.count == 3, let second = subTimes[2], let minute = subTimes[1], let hour = subTimes[0] {
			duration = second + minute * 60 + hour * 3600
		}
		return Int(duration)
	}
    
    static func setCustomSideMenuAnimation(toReset: Bool = true) {
        guard let sideMenu = Constants.Singleton.sideMenuController?.sideMenuManager else { return }
        sideMenu.menuAnimationDismissDuration = toReset ? Constants.DefaultValue.sideMenuAnimationTime :
            Constants.DefaultValue.sideMenuShortAnimationTime
    }
    
    static func getPhotoAlbumItemWith() -> CGFloat {
        let paddingLeftAndRight: CGFloat = 24
        
        return (Constants.DeviceMetric.screenWidth - paddingLeftAndRight) /
            CGFloat(Constants.DefaultValue.numberOfItemPhotoDefaullAlbumInLine)
    }
    
    static func getPhotoAlbumItemHeight() -> CGFloat {
        return (Common.getPhotoAlbumItemWith() * Constants.DefaultValue.photoDefaultAlbumItemHeight) /
            Constants.DefaultValue.photoDefaultAlbumItemWidth
    }
    
    static func getCustomAlbumItemWith() -> CGFloat {
        let paddingLeftAndRight: CGFloat = 24
        return (Constants.DeviceMetric.screenWidth - paddingLeftAndRight) /
            CGFloat(Constants.DefaultValue.numberOfItemCustomAlbumInLine)
    }
    
    static func getCustomAlbumItemHeight() -> CGFloat {
        return (Common.getPhotoAlbumItemWith() * Constants.DefaultValue.customAlbumItemDefaultHeight) /
            Constants.DefaultValue.customAlbumItemDefaultWidth
    }
    
    static func shouldBypassAnimation() -> Bool {
        return !Constants.Singleton.isiPad && Constants.Singleton.isLandscape
    }
    
    // MARK: PRIVATE FUNCTIONS
    static private func setupTapEventFor(label: TTTAttributedLabel, delegate: TTTAttributedLabelDelegate) {
        label.delegate = delegate
        label.linkAttributes = nil
        let range = NSRange(location: 0, length: label.attributedText.length)
        label.addLink(to: Constants.DefaultValue.CustomUrlForPostText, with: range)
    }
}
