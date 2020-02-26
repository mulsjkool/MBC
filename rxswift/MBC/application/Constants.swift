//
//  Constants.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 11/30/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import UIKit
import SideMenu
import THEOplayerSDK

let defaultNotification = NotificationCenter.default

struct Constants {
    struct Singleton {
        // swiftlint:disable:next force_cast
        static let appDelegate = UIApplication.shared.delegate as! AppDelegate
        static let isiPad = UIDevice.current.model.hasPrefix("iPad")
        static var isAInlineVideoPlaying: Bool = false {
            didSet {
                playingTHEOplayer?.fullscreenOrientationCoupling = isAInlineVideoPlaying
            }
        }
        static var playingTHEOplayer: THEOplayer?
        static var sideMenuController: SideMenu.UISideMenuNavigationController? {
            get {
                return DefaultValue.shouldRightToLeft
                    ? SideMenuManager.default.menuRightNavigationController
                    : SideMenuManager.default.menuLeftNavigationController
            }
            set {
                DefaultValue.shouldRightToLeft
                    ? (SideMenuManager.default.menuRightNavigationController = newValue)
                    : (SideMenuManager.default.menuLeftNavigationController = newValue)
                
                SideMenuManager.default.menuPresentMode = .menuSlideIn
                SideMenuManager.default.menuAnimationFadeStrength = Ipad.sideMenuFadeStrength
                sideMenuController?.menuWidth = Ipad.sideMenuWidth
                Common.setupNavigationBar(sideMenuController?.navigationBar)
            }
        }
		static var lotemaParams: [AnyHashable: Any] = [:]
        static var isLandscape: Bool { return UIDevice.current.orientation.isLandscape }
    }

    struct MOATPartnerCode {
        static let theoPlayer = "dmsoplayerjsvideo672881926038"
        static let bannerAds = "mbcinappdisplay657060160820"
    }
    
    struct DeviceMetric {
        static let screenSize = UIScreen.main.bounds.size
        static let screenWidth = DeviceMetric.screenSize.width
        static let screenHeight = DeviceMetric.screenSize.height
        static let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        static let navBarHeight = UINavigationController().navigationBar.frame.size.height
        static let navBarButtonWidthMBC = CGFloat(24)
        static let navBarButtonWidthBell = CGFloat(20)
        static let navBarSearchBarMargin = CGFloat(8)
        static let navBarSearchBarHeight = CGFloat(24)
        static let tabbarHeight = UITabBarController().tabBar.frame.size.height
        static let displayViewHeightWithNavAndTabbar = DeviceMetric.screenHeight -
            DeviceMetric.statusBarHeight - DeviceMetric.navBarHeight - DeviceMetric.tabbarHeight
        
        static let searchDefaultFrame = CGRect(x: 0, y: 0,
                                               width: Constants.DeviceMetric.screenWidth
                                                - Constants.DeviceMetric.navBarButtonWidthMBC
                                                - Constants.DeviceMetric.navBarButtonWidthBell,
                                               height: Constants.DeviceMetric.navBarSearchBarHeight)
        static let searchExpandedFrame = CGRect(x: 0, y: 0,
                                                width: Constants.DeviceMetric.screenWidth,
                                                height: Constants.DeviceMetric.navBarSearchBarHeight)
    }

    struct DefaultValue {
        /// Strings
        static let SiteName = "MBC.net"
        static let DefaultAlbumName = "default-albums"
        static let MetadataSeparatorString = " • "
        static let separatorCharacter = "•"
        static let InforTabMetadataSeparatorString = "/"
        static let InforTabMetadataGenreSeparatorString = ","
        static let MetadataOccupationSeparatorString = " - "
        static let MetadataLinkedValueSeparatorString = "-"
        static let InterestSeparatorString = " ، "
        static let DotSeparatorString = " . "
		static let TimeSeparator = ":"
        static let UserProfileAddressSeparatorString = ", "
        static let CustomUrlForMoreText = URL(string: "TTTAttributedLabel.custom_url_for_more_text")!
        static let CustomUrlForPostText = URL(string: "TTTAttributedLabel.custom_url_for_post_text")!
        static let CustomUrlForCommentCount = URL(string: "TTTAttributedLabel.custom_url_for_comment_count")!
        static let campaignType = "campaign"
        static let LoadMoreCellId = "loadmoreCellId"
        static let PlaceHolderLoadingCellId = "placeHolderLoading"
        static let ImageExtension = "jpg"
        static let TheoVideoSourceType = "application/x-mpegurl"
        static let videoRemainingTime = "%02d:%02d"
        static let videoRemainingTimeWithHour = "%02d:%02d:%02d"
        static let videoNextVideoCountDown: Int = 5
		static var shouldRightToLeft: Bool {
			return Components.languageRepository.currentLanguageEnum() == LanguageEnum.arabic
		}
        static var totalDayForScheduler: Int = 7
        
        /// Values
        static let gradientExpandDescriptionColors: [CGColor] = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.64).cgColor, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor]
        static let gradientForVideoPlaylist: [CGColor] =  [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.9).cgColor, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor]
        static let gradientForVideoFullScreen: [CGColor] = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.41).cgColor, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.41).cgColor]
        static let gradientExpandDescriptionLocations: [NSNumber] =  [0.0, 0.41, 1.0]
        
        static let gradientBottomForSingleItem: [CGColor] = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor]
        static let gradientLocationBottomForSingleItem: [NSNumber] = [0, 1.0]
        static let gradientTopForSingleItem: [CGColor] = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor]
        static let gradientLocationTopForSingleItem: [NSNumber] = [0, 1.0]
        
        static let gradientBottomForBundleSingleItem: [CGColor] = [#colorLiteral(red: 0.4283788071, green: 0.4283788071, blue: 0.4283788071, alpha: 0).cgColor, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor]
        // swiftlint:disable:next identifier_name
        static let gradientLocationExpandBottomForSingleItem: [NSNumber] = [0.2, 0.8]
        // swiftlint:disable:next identifier_name
        static let gradientLocationBottomForBundleSingleItem: [NSNumber] = [0, 0.513, 1.0]
        static let gradientTopForBundleSingleItem: [CGColor] = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor, #colorLiteral(red: 0.4283788071, green: 0.4283788071, blue: 0.4283788071, alpha: 0).cgColor]
        static let gradientLocationTopForBundleSingleItem: [NSNumber] = [0, 0.46, 1.0]
        
        static let durationAfterViewDidLoad: TimeInterval = 0.3
        static let animateDuration: Double = 0.3
        static let searchBarDrawDelay: Double = 0.05
        static let animateDurationForNextVideo: Double = 1.0
        static let taggedViewItemSmallHeight: CGFloat = 60
        static let taggedViewItemFullHeight: CGFloat = 176
        static let taggedViewItemSmallWidth: CGFloat = 30
        static let taggedViewItemFullWidth: CGFloat = 80
        static let taggedViewHeightDefault: CGFloat = 45
        static let taggedViewHeightWhenShow: CGFloat = 132
        static let taggedViewCellInteritemSpacing: CGFloat = 16
        static let taggedCellHeight: CGFloat = 102
        static let headerCommentHeight: CGFloat = 50
		static let inputMessageHeightCell: CGFloat = 64
		static let loadMoreCommentHeightCell: CGFloat = 40
		static let defaultCommentPageSize: Int = 5
		static let commentPanelPageSize: Int = 8
        static let messagePadding: CGFloat = 32
        static let CardTextLabelHeight: CGFloat = 66
        static let CardTextLabelHeightForImagePost: CGFloat = 26
        static let PageCellHeight: CGFloat = 50 // default height of a cell in Page Detail Cell
		static let ratio9H16W = CGFloat(0.5626) // ratio h:w 9:16
		static let ratio16H16W: CGFloat = 1 // ratio h:w 16:16
        static let ratio27H40W: CGFloat = 27 / 40 // ratio h:w 27:40
        static let numberOfItemPhotoDefaullAlbumInLine: Int = 4
        static let numberOfItemCustomAlbumInLine: Int = 5
        static let photoDefaultAlbumItemHeight: CGFloat = 340
        static let photoDefaultAlbumItemWidth: CGFloat = 244
        
        static let customAlbumItemDefaultHeight: CGFloat = 309
        static let customAlbumItemDefaultWidth: CGFloat = 375
        
        static let numberOfLinesForTextDescription = 4
        static let numberOfLinesForImageDescription = 2
        static let numberOfLinesForAppTitle = 2
        static let PlaceHolderLoadingHeight = Constants.Singleton.isiPad ? CGFloat(232) : CGFloat(250)
        static let numberOfLinesForEmbeddedDescription = 2
        static let numberOfLinesForRelatedContentTitle = 2
        static let MaxMessageCharacter = 1000
        static let RemindViewWidth: CGFloat = 91
        // swiftlint:disable:next identifier_name
        static let numberOfLinesForFullScreenImageExpandedDescription = 8
        
        // For Bundle content
        static let maxNumberOfDisplayInPager = 8
        static let bundleCarouselCellOnPageStreamHeight: CGFloat = 185
        static let heightOfBundleSponsor: CGFloat = 40
        
        // For Ads
        static let AdsDomain = "/7229/MBC.net-PYCO/mobileapp"
		static let TeadsAdsPID = "90097"
		static let AmountPreviewedImage = 5
		
		// Search result menu
		static let searchMenuHeight: CGFloat = 48
		static let searchMenuPadding: CGFloat = 16
		static let tableSearchTopMargin: CGFloat = 64
        static let playlistSearchResultMargin: CGFloat = 92
        
        //
        static let defaultMargin: CGFloat = Constants.Singleton.isiPad ? 24.0 : 16.0
        static let defaultLabelLeftInset: CGFloat = 6.0
        static let defaultMarginTitle: CGFloat = 12.0

        static let defaultDateOfBirth = Date.dateFromString(string: "01-01-1990",
                                                            format: Constants.DateFormater.BirthDay)
        static let mediaContentRatioToPlay: CGFloat = 0.5
        static let gigyaErrorDomain = "gigyaErrorDomain"
        static let validTimeOfReqTokenInSeconds: Double = 60 * 60
        static let gifTag = 102
        static let estimatedTableRowHeight: CGFloat = 200.0
        static let estimatedAppFilterTableRowHeight: CGFloat = 50.0
        static let infinityNumber: Int = 10000
        static let maximumInfinityNumber: Int = 10000000
        static let tapEventThrottleIntevalTime: Double = 1.0
        static let inputSearchTextIntevalTime: Double = 1.0
        static let defaulNoLogoImage = R.image.iconNoLogo()
        static let defaultInterestViewHeight: CGFloat = 20
        static let defaultMarginInterestLabelTop: CGFloat = 10
        static let defaultMarginInterestLabelBottom: CGFloat = 8
        
        static let videoTimeDifference: Double = 0.3
        static let interestViewTopMargin: CGFloat = 16
        static let descriptionLineHeightMultiple: CGFloat = 1.79
        static let titleAndDescriptionLabelTopMargin: CGFloat = 16
        static let bundleCarouselImageViewBorderWidth: CGFloat = 4.0
        static let maxNumberOfBundleSingleItem: Int = 6
        static let defaultNumberOfRelatedContents: Int = 8
        
        static let sideMenuAnimationTime: Double = 0.35
        static let sideMenuShortAnimationTime: Double = 0.01
		
		// Star listing cell
		static let starListingHeightCell: CGFloat = 150.0
		static let bundleSearchHeightCell: CGFloat = 140.0
        
        // App
        static let addressUpdateApp = "itms://itunes.apple.com/vn/app/choozia/id1040041739?l=vi&mt=8"
        static let defaultRegion = "USA"
		
		// radio channel
		static let radioPickerViewHeight: CGFloat = 162
		static let radioFeedHeightCell: CGFloat = 168
		
        // Channel listing
        static let channelListingLoadMoreCellHeight: CGFloat = 70
        static let numberOfLoadingPlaceHolderCell: Int = 10
        
        // Air time
        static let timeTonightFrom21h00: Int = 21

        // Radio channel
        static let airTimeListingHeightCell: CGFloat = 57.0
		static let numberOfSocialPriority = 3
        
        //
        static let checkSchedulerShowTimeInterval: Double = 30.0
		static let paddingVideoLiveCellLeft: CGFloat = 10
		static let paddingVideoLiveCellTop: CGFloat = 16
		
        // episode
        static let shahibButtonImageMargin: CGFloat = 3
        static let shahibButtonTextMargin: CGFloat = 12
        
        // Notification
        static let notificationCategory = "NOTIFICATION_CATEGORY"
		
		// Banner Ads Cell
		static let paddingBannerAdsCellBottom: CGFloat = 24
		static let paddingBannerAdsCellTop: CGFloat = 40
        
        // Playlist Carousel
        static let interestLabelFont = Fonts.Primary.semiBold.toFontWith(size: 10)
        
        // Embedded Webview
        static let embeddedWebViewBaseUrl = URL(string: "https://google.com/")!
		
		static let loadMoreFont = Constants.Singleton.isiPad ? Fonts.Primary.semiBold.toFontWith(size: 12) :
																Fonts.Primary.regular.toFontWith(size: 12)
		static let sendCommentButtonWidth = Constants.Singleton.isiPad ? CGFloat(116) : CGFloat(58)
    }
    
    struct QueryString {
        static let whitePageIsMobile = "mo"
        static let trueValue = "true"
    }
    
    struct Scripting {
        static let eventPlayerTouched = "playerTouched"
    }
    
    struct DateFormater {
        static let StandardWithMilisecond = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        static let OnlyTime12h = "hh:mm a"
        static let FullDateDisplayWithTime = "dd/MM/yyyy - hh:mm a"
        static let YearOnly = "yyyy"
        static let DateMonthYear = "dd/MM/yyyy"
        static let BirthDay = "dd-MM-yyyy"
        static let BirthDayForAPI = "yyyy-MM-dd"
        static let DateMonth = "dd/MM"
        static let DayOfWeek = "EEE"
    }
    
    struct ConfigurationDataType {
        static let industries = "industries"
        static let subIndustries = "sub-industries"
        static let awardFilm = "awardTitleFilm"
        static let awardBeautyPageant = "awardTitleBeautyPageant"
        static let awardMusic = "awardTitleMusic"
        static let awardSport = "awardTitleSport"
        static let awardTelevision = "awardTitleTelevision"
        static let eventsSubType = "eventsSubTypes"
        static let occupations = "occupations"
        static let skillLevels = "skillLevels"
        static let sportTypes = "sportTypes"
        static let musicTypes = "musicTypes"
        static let countries = "countries"
        static let languages = "languages"
        static let regions = "regions"
        static let dialects = "dialects"
        static let genres = "genres"
        static let nationalities = "nationalities"
        static let subgenres = "subgenres"
    }
    
    static let localizationMappingDict = [
        "subIndustry": Constants.ConfigurationDataType.subIndustries,
        "industry": Constants.ConfigurationDataType.industries,
        PageAwardSubType.beautyPageant.rawValue: Constants.ConfigurationDataType.awardBeautyPageant,
        PageAwardSubType.sport.rawValue: Constants.ConfigurationDataType.awardSport,
        PageAwardSubType.music.rawValue: Constants.ConfigurationDataType.awardMusic,
        PageAwardSubType.film.rawValue: Constants.ConfigurationDataType.awardFilm,
        PageAwardSubType.television.rawValue: Constants.ConfigurationDataType.awardTelevision,
        PageType.events.rawValue: Constants.ConfigurationDataType.eventsSubType,
        "occupations": Constants.ConfigurationDataType.occupations,
        "skillLevel": Constants.ConfigurationDataType.skillLevels,
        "sportTypes": Constants.ConfigurationDataType.sportTypes,
        "sportType": Constants.ConfigurationDataType.sportTypes,
        "musicType": Constants.ConfigurationDataType.musicTypes,
        "hqCountry": Constants.ConfigurationDataType.countries,
        "language": Constants.ConfigurationDataType.languages,
        "nationalities": Constants.ConfigurationDataType.countries,
        "regionList": Constants.ConfigurationDataType.regions,
        "dialect": Constants.ConfigurationDataType.dialects,
        "genres": Constants.ConfigurationDataType.genres,
        "country": Constants.ConfigurationDataType.countries,
        "eventsSubTypes": Constants.ConfigurationDataType.eventsSubType
    ]
    
    struct ViewTag {
        static let videoTimeRemaining = 1001
        static let videoBigPlayImg = 1002
        static let videoUnmuteImg = 1003
        static let videoThumbImg = 1004
        static let fullscreenLandscape = 2000
    }
    
    struct ConfigurationSharingExtension {
        static let googlePlus = "com.google.GooglePlus.ShareExtension"
        static let whatsApp = "net.whatsapp.WhatsApp.ShareExtension"
    }
	
	struct UIControlKey {
		static let cancelButtonUISearchBar = "cancelButton"
        static let placeholderLabelUISearchBar = "_placeholderLabel"
        static let clearButtonUISearchBar = "_clearButton"
        static let searchField = "_searchField"
	}
    
    struct UIControlClassName {
        static let searchFieldEditor = "UIFieldEditor"
        static let searchAdaptorView = "_UITAMICAdaptorView"
        static let buttonBarStackView = "_UIButtonBarStackView"
        static let searchBarBackground = "UISearchBarBackground"
    }
	
	struct RadioHtmlTagName {
		static let title = ".video-title"
		static let image = ".video-image img"
		static let row = ".video-data-row"
		static let src = "src"
	}
    
    struct Ipad {
        static let sideMenuWidth = CGFloat(290)
        static let sideMenuFadeStrength = CGFloat(0.2) //opacity: 20%
    }
    
    struct ConfigurationAirTimeInformation {
        static let daily = "daily"
        static let weekly = "weekly"
    }
    
    struct ConfigurationGEOTargeting {
        static let country = "Country"
        static let region = "Region"
    }
    
    struct ExternalEndpoint {
        static let googleShortenerAPI =
        "https://www.googleapis.com/urlshortener/v1/url?key=AIzaSyCuD1cOT86LYMEXh6yuneZJHbGjFDNbgLA"
    }
}
