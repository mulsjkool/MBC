//
//  Components.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 11/24/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class Components {

    // MARK: Public

    static let instance = Components()

    static var networkingService: NetworkingService {
        return instance.internalNetworkingService
    }

    static var analyticsService: AnalyticsService {
        return instance.internalAnalyticsService
    }
    
    static var languageConfigService: LanguageConfigService {
        return instance.internalLanguageConfigService
    }
    
    static var authenticationService: AuthenticationService {
        return instance.internalAuthenticationService
    }
    
    static var facebookConnectionService: FacebookConnectionService {
        return instance.internalFacebookConnectionService
    }
    
    static var userSocialService: UserSocialService {
        return instance.internalUserSocialService
    }

    static var pageApi: PageApi {
        return instance.pageApi
    }

    static var pageDetailApi: PageDetailApi {
        return instance.pageDetailApi
    }
    
    static var streamApi: StreamApi {
        return instance.streamApi
    }
    
    static var pageAlbumApi: PageAlbumApi {
        return instance.pageAlbumApi
    }
    
    static var config: Configurations {
        return instance.configurations
    }
    
    static var userSocialApi: UserSocialApi {
        return instance.userSocialApi
    }

    static var sessionService: SessionService {
        return instance.internalSessionService
    }
    
    static var taggedPagesService: TaggedPagesService {
        return instance.taggedPagesService
    }
    
    static var userProfileService: UserProfileService {
        return instance.internalUserProfileService
    }
    
    static var upgradeVersionService: AppUpgradeService {
        return instance.appUpgradeVersionService
    }
    
    static var commentApi: CommentApi {
        return instance.commentApi
    }
    
    static var contentPageApi: ContentPageApi {
        return instance.contentPageApi
    }
    
    static var infoComponentApi: InfoComponentApi {
        return instance.infoComponentApi
    }
    
    static var relatedContentApi: RelatedContentApi {
        return instance.relatedContentApi
    }
    
    static var formApi: FormApi {
        return instance.formApi
    }
    
    static var externalApi: ExternalApi {
        return instance.externalApi
    }
    
    //----------------------------------------------------------------------------------------------
    // MARK: Common */

    lazy var configurations: Configurations = {
        let path = Bundle.main.path(forResource: "configuration", ofType: "plist")!
        let dictionary = NSDictionary(contentsOfFile: path)!
        return Configurations(dictionary: dictionary)
    }()

    private lazy var apiClient: ApiClient = {
        return ApiClientImpl(baseUrl: self.configurations.apiBaseUrl,
                             networkingService: self.internalNetworkingService,
                             sessionService: self.internalSessionService)
    }()

    //----------------------------------------------------------------------------------------------
    // MARK: Begin Services */
    private var internalNetworkingService: NetworkingService = {
        return NetworkingServiceImpl()
    }()

    private lazy var internalAnalyticsService: AnalyticsService = {
        return AnalyticsServiceImpl(sessionService: self.internalSessionService)
    }()
    
    private lazy var internalLanguageConfigService: LanguageConfigService = {
        return LanguageConfigServiceImpl(languageConfigApi: self.languageConfigApi,
                                         languageConfigRepository: self.languageConfigRepository)
    }()
    
    private lazy var internalAuthenticationService: AuthenticationService = {
        return AuthenticationServiceImpl(signinApi: self.signinApi,
                                         userProfileApi: self.userProfileApi,
                                         remoteNotificationApi: self.remoteNotificationApi)
    }()
    
    private lazy var internalFacebookConnectionService: FacebookConnectionService = {
        return FacebookConnectionServiceImpl()
    }()
    
    private lazy var internalUserSocialService: UserSocialService = {
        return UserSocialServiceImpl(userSocialApi: self.userSocialApi, commentApi: self.commentApi)
    }()

    private lazy var internalSessionService: SessionService = {
        return SessionServiceImpl(sessionRepository: Components.sessionRepository)
    }()
    
    private lazy var taggedPagesService: TaggedPagesService = {
        return TaggedPagesServiceImpl(taggedApi: self.taggedPagesApi)
    }()
    
    private lazy var internalUserProfileService: UserProfileService = {
        return UserProfileServiceImpl(authenticationService: self.internalAuthenticationService,
                                      userProfileApi: self.userProfileApi)
    }()
    
    private lazy var appUpgradeVersionService: AppUpgradeService = {
        return AppUpgradeServiceImpl(appVersionApi: self.appVersionApi)
    }()
    
    //----------------------------------------------------------------------------------------------
    // MARK: Begin Repository */
    
    static var languageRepository: LanguageRepository = {
        return LanguageRepositoryImpl(userDefaults: UserDefaults.standard)
    }()
    
    private lazy var pageDetailRepository: PageDetailRepository = {
        return PageDetailRepositoryImpl(expireTime: self.configurations.cacheExpiredTime)
    }()
    
    private lazy var streamRepository: StreamRepository = {
        return StreamRepositoryImpl(expireTime: self.configurations.cacheExpiredTime)
    }()
    
    private lazy var pageAlbumRepository: PageAlbumRepository = {
        return PageAlbumRepositoryImpl(expireTime: self.configurations.cacheExpiredTime)
    }()
    
    private lazy var appTabRepository: AppTabRepository = {
        return AppTabRepositoryImpl(expireTime: self.configurations.cacheExpiredTime)
    }()
    
    private lazy var languageConfigRepository: LanguageConfigRepository = {
        return LanguageConfigRepositoryImpl(expireTime: self.configurations.langugeConfigCacheExpiredTime)
    }()
    
    static var sessionRepository: SessionRepository = {
        return SessionRepositoryImpl(userDefaults: UserDefaults.standard)
    }()
    
    private lazy var videoPlaylistRepository: VideoPlayListRepository = {
        return VideoPlayListRepositoryImpl(expireTime: self.configurations.cacheExpiredTime)
    }()
    
    private lazy var contentPageRepository: ContentPageRepository = {
        return ContentPageRepositoryImpl(expireTime: self.configurations.cacheExpiredTime)
    }()
    
    private lazy var starPageListingRepository: StarPageListingRepository = {
        return StarPageListingRepositoryImpl(expireTime: self.configurations.cacheExpiredTime)
    }()
    
    private lazy var infoComponentRepository: InfoComponentsRepository = {
        return InfoComponentsRepositoryImpl(expireTime: self.configurations.cacheExpiredTime)
    }()
    
    private lazy var channelRepository: ChannelRepository = {
        return ChannelRepositoryImpl(expireTime: self.configurations.cacheExpiredTime)
    }()
    
    private lazy var showListingRepository: ShowListingRepository = {
        return ShowListingRepositoryImpl(expireTime: self.configurations.cacheExpiredTime)
    }()
    
    private lazy var episodeRepository: EpisodeRepository = {
        return EpisodeRepositoryImpl(expireTime: self.configurations.cacheExpiredTime)
    }()
    
    //----------------------------------------------------------------------------------------------
    // MARK: Api */

    private lazy var pageApi: PageApi = {
        return PageApiImpl(apiClient: self.apiClient,
                           jsonTransformer: self.listPageJsonTransformer.transform)
    }()

    private lazy var pageDetailApi: PageDetailApi = {
        return PageDetailApiImpl(apiClient: self.apiClient,
                                 jsonTransformer: self.pageDetailJsonTransformer.transform)
    }()
    
    private lazy var streamApi: StreamApi = {
        return StreamApiImpl(apiClient: self.apiClient,
                             streamTransformer: self.streamJsonTransformer.transform,
                             homeStreamTransformer: self.homeStreamJsonTransformer.transform,
							 searchResultJsonTransformer: self.searchResultJsonTransformer.transform)
    }()
    
    private lazy var pageAlbumApi: PageAlbumApi = {
        return PageAlbumApiImpl(apiClient: self.apiClient,
                             transformer: self.pageAlbumJsonTransformer.transform)
    }()
    
    private lazy var languageConfigApi: LanguageConfigApi = {
        return LanguageConfigApiImpl(apiClient: self.apiClient,
                                     jsonTransformer: self.languageConfigListJsonTransformer.transform)
    }()
    
    private lazy var userSocialApi: UserSocialApi = {
        return UserSocialApiImpl(apiClient: self.apiClient, jsonTransformer: self.emptyJsonTransformer.transform)
    }()

    private lazy var signinApi: SigninApi = {
        return SigninApiImpl(apiClient: self.apiClient, jsonTransformer: self.signinJsonTransformer.transform)
    }()
	
	private lazy var appApi: AppApi = {
		return AppApiImpl(apiClient: self.apiClient, transformer: self.pageAppJsonTransformer.transform)
	}()
    
    private lazy var filterContentApi: FilterContentApi = {
        return FilterContentApiImpl(apiClient: self.apiClient,
                                    jsonTransformer: self.filterContentJsonTransformer.transform)
    }()
    
    private lazy var appListingApi: AppListingApi = {
        return AppListingApiImpl(apiClient: self.apiClient, jsonTransformer: self.listAppJsonTransformer.transform)
    }()
    
    private lazy var taggedPagesApi: TaggedPagesApi = {
        return TaggedPagesApiImpl(apiClient: self.apiClient, jsonTransformer: self.listPageJsonTransformer.transform)
    }()
    
    private lazy var videoApi: VideoApi = {
        return VideoApiImpl(apiClient: self.apiClient,
                            videoPlaylistTransformer: self.videoPlaylistTransformer.transform,
                            videoCustomPlaylistTransformer: self.listVideoPlaylistTransformer.transform)
    }()
    
    private lazy var commentApi: CommentApi = {
        return CommentApiImpl(apiClient: self.apiClient,
                              commentsTransformer: self.listCommentJsonTransformer.transform,
                              sendCommentTransformer: self.commentJsonTransformer.transform)
    }()
    
    private lazy var contentPageApi: ContentPageApi = {
        return ContentPageApiImpl(apiClient: self.apiClient,
                                  contentPageJsonTransformer: self.contentPageJsonTransformer.transform,
                                  feedJsonTransformer: self.feedJsonTransformer.transform)
    }()

    private lazy var userProfileApi: UserProfileApi = {
        return UserProfileApiImpl(apiClient: self.apiClient, jsonTransformer: self.userJsonTransformer.transform)
    }()
    
    private lazy var starPageListingApi: StarPageListingApi = {
        return StarPageListingApiImpl(apiClient: self.apiClient,
                                      jsonTransformer: self.listStarJsonTransformer.transform)
    }()
    
    private lazy var relatedContentApi: RelatedContentApi = {
        return RelatedContentApiImpl(apiClient: self.apiClient,
                                     jsonTransformer: self.listFeedJsonTransformer.transform)
    }()
    
    private lazy var searchSuggestionApi: SearchSuggestionApi = {
        return SearchSuggestionApiImpl(apiClient: self.apiClient,
                                       jsonTransformer: self.listSearchSuggestionJsonTransformer.transform)
    }()
    
    private lazy var appVersionApi: AppVersionApi = {
        return AppVersionApiImpl(apiClient: self.apiClient,
                                 jsonTransformer: self.appVersionJsonTransformer.transform)
    }()
    
    private lazy var remoteNotificationApi: RemoteNotificationApi = {
        return RemoteNotificationApiImpl(apiClient: self.apiClient,
                                 jsonTransformer: self.remoteNotificationJsonTransformer.transform)
    }()
    
    private lazy var infoComponentApi: InfoComponentApi = {
        return InfoComponentApiImpl(apiClient: self.apiClient,
                                    jsonTransformer: self.listInfoComponentJsonTransformer.transform)
    }()

    private lazy var schedulerApi: SchedulerApi = {
       return SchedulerApiImpl(apiClient: self.apiClient,
                               listScheduleJsontransformer: self.listScheduleJsonTransformer.transform)
    }()

    private lazy var channelListingApi: ChannelListingApi = {
        return ChannelListingApiImpl(apiClient: self.apiClient,
                                     jsonTransformer: self.listChannelJsonTransformer.transform)
    }()
    
    private lazy var showListingApi: ShowListingApi = {
        return ShowListingApiImpl(apiClient: self.apiClient,
                                  jsonTransformer: self.listShowJsonTransformer.transform)
    }()
    
    private lazy var episodeApi: EpisodeApi = {
        return EpisodeApiImpl(apiClient: self.apiClient,
                              jsonTransformer: self.episodeTabJsonTransformer.transform)
    }()
        
    private lazy var scheduledChannelsApi: ScheduledChannelsApi = {
        return ScheduledChannelsApiImpl(apiClient: self.apiClient,
                                        jsonTransformer: self.listScheduledChannelsJsonTransfomer.transform)
    }()
    
    private lazy var formApi: FormApi = {
        return FormApiImpl(apiClient: self.apiClient, jsonTransformer: self.emptyJsonTransformer.transform)
    }()
    
    private lazy var externalApi: ExternalApi = {
        return ExternalApiImpl()
    }()
    
    //----------------------------------------------------------------------------------------------
    // MARK: Transformer */
    private lazy var emptyJsonTransformer: EmptyJsonTransformer = {
        return EmptyJsonTransformer()
    }()
    
    private lazy var listPageJsonTransformer: ListPageJsonTransformer = {
        return ListPageJsonTransformer(pageJsonTransformer: self.pageJsonTransformer)
    }()

    private lazy var pageJsonTransformer: PageJsonTransformer = {
        return PageJsonTransformer()
    }()

    private lazy var pageDetailJsonTransformer: PageDetailJsonTransformer = {
        return PageDetailJsonTransformer(
            pageInforJsonTransformer: self.pageInforJsonTransformer,
            pageSettingJsonTransformer: self.pageSettingJsonTransformer,
            pageMetadataJsonTransformer: self.pageMetadataJsonTransformer,
            feedJsonTransformer: self.feedJsonTransformer)
    }()

    private lazy var pageInforJsonTransformer: PageInforJsonTransformer = {
        return PageInforJsonTransformer(paragraphImageTransformer: self.paragraphImageTransformer,
                                        videoJsonTransformer: self.videoJsonTransformer)
    }()

    private lazy var pageSettingJsonTransformer: PageSettingJsonTransformer = {
        return PageSettingJsonTransformer()
    }()

    private lazy var pageMetadataJsonTransformer: PageMetadataJsonTransformer = {
        return PageMetadataJsonTransformer(airTimeInformationJsonTransformer: self.airTimeInformationJsonTransformer,
										   listFrequencyChannelJsonTransformer: listFrequencyChannelJsonTransformer,
										   listSocialNetworkJsonTransformer: listSocialNetworkJsonTransformer,
										   listRadioSubChannelJsonTransformer: listRadioSubChannelJsonTransformer)
    }()
    
    private lazy var streamJsonTransformer: StreamJsonTransformer = {
        return StreamJsonTransformer(listFeedJsonTransformer: self.listFeedJsonTransformer)
    }()
    
    private lazy var listFeedJsonTransformer: ListFeedJsonTransformer = {
        return ListFeedJsonTransformer(feedJsonTransformer: self.feedJsonTransformer)
    }()
    
    private lazy var feedJsonTransformer: FeedJsonTransformer = {
        return FeedJsonTransformer(listParagraphJsonTransformer: self.listParagraphJsonTransformer,
                                   listInterestJsonTransformer: self.listInterestJsonTransformer,
                                   authorJsonTransformer: self.authorJsonTransformer,
                                   pageJsonTransformer: self.pageJsonTransformer,
                                   relatedContentJsonTransformer: self.relatedContentJsonTransformer,
                                   propertiesJsonTransformer: self.propertiesJsonTrasform,
                                   activityCardJsonTransformer: self.activityCardJsonTransformer,
                                   bundleItemJsonTransformer: self.bundleItemJsonTransformer,
                                   videoJsonTransformer: self.videoJsonTransformer)
    }()
    
    private lazy var listParagraphJsonTransformer: ListParagraphJsonTransformer = {
        return ListParagraphJsonTransformer(paragraphTransformer: self.paragraphTransformer)
    }()
    
    private lazy var paragraphTransformer: ParagraphTransformer = {
        return ParagraphTransformer(paragraphImageTransformer: self.paragraphImageTransformer,
                                    mediaJsonTransformer: self.mediaJsonTransformer,
                                    videoJsonTransformer: self.videoJsonTransformer)
    }()
        
    private lazy var paragraphImageTransformer: ParagraphImageTransformer = {
        return ParagraphImageTransformer()
    }()
    
    private lazy var listInterestJsonTransformer: ListInterestJsonTransformer = {
        return ListInterestJsonTransformer(interestJsonTransformer: self.interestJsonTransformer)
    }()
    
    private lazy var interestJsonTransformer: InterestJsonTransformer = {
        return InterestJsonTransformer()
    }()
    
    private lazy var authorJsonTransformer: AuthorJsonTransformer = {
        return AuthorJsonTransformer()
    }()
    
    private lazy var pageAlbumJsonTransformer: PageAlbumJsonTransformer = {
       return PageAlbumJsonTransformer(listMediaJsonTransformer: self.listMediaJsonTransformer,
                                       mediaJsonTransformer: self.mediaJsonTransformer)
    }()
    
    private lazy var listMediaJsonTransformer: ListMediaJsonTransformer = {
        return ListMediaJsonTransformer(mediaJsonTransformer: self.mediaJsonTransformer)
    }()
    
    private lazy var mediaJsonTransformer: MediaJsonTransformer = {
        return MediaJsonTransformer()
    }()
    
    private lazy var languageConfigDataJsonTransformer: LanguageConfigDataJsonTransformer = {
        return LanguageConfigDataJsonTransformer()
    }()
    
    private lazy var languageConfigJsonTransformer: LanguageConfigJsonTransformer = {
        return LanguageConfigJsonTransformer(languageConfigDataJsonTransformer: self.languageConfigDataJsonTransformer)
    }()
    
    private lazy var languageConfigListJsonTransformer: LanguageConfigListJsonTransformer = {
        return LanguageConfigListJsonTransformer(languageConfigJsonTransformer: self.languageConfigJsonTransformer)
    }()

    private lazy var homeStreamJsonTransformer: HomeStreamJsonTransformer = {
        return HomeStreamJsonTransformer(listCampaignJsonTransformer: self.listCampaignJsonTransformer)
    }()
    
    private lazy var listCampaignJsonTransformer: ListCampaignJsonTransformer = {
        return ListCampaignJsonTransformer(campaignJsonTransformer: self.campaignJsonTransformer)
    }()
    
    private lazy var campaignJsonTransformer: CampaignJsonTransformer = {
        return CampaignJsonTransformer(headerJsonTransformer: self.headerJsonTransformer,
                                       listParagraphJsonTransformer: self.listParagraphJsonTransformer,
                                       listInterestJsonTransformer: self.listInterestJsonTransformer,
                                       authorJsonTransformer: self.authorJsonTransformer,
                                       pageJsonTransformer: self.pageJsonTransformer,
                                       relatedContentJsonTransformer: self.relatedContentJsonTransformer,
                                       propertiesJsonTransformer: self.propertiesJsonTrasform,
                                       activityCardJsonTransformer: self.activityCardJsonTransformer,
                                       bundleItemJsonTransformer: self.bundleItemJsonTransformer,
                                       videoJsonTransformer: self.videoJsonTransformer)
    }()
    
    private lazy var contentPageJsonTransformer: ContentPageJsonTransformer = {
        return ContentPageJsonTransformer(feedJsonTransformer: self.feedJsonTransformer,
                                          pageDetailJsonTransformer: self.contentPagePageDetailJsonTransformer,
                                          videoTransformer: self.videoJsonTransformer)
    }()
    
    private lazy var contentPagePageDetailJsonTransformer: ContentPagePageDetailJsonTransformer = {
        return ContentPagePageDetailJsonTransformer(
            pageInforJsonTransformer: self.pageInforJsonTransformer,
            pageSettingJsonTransformer: self.pageSettingJsonTransformer,
            pageMetadataJsonTransformer: self.pageMetadataJsonTransformer,
            feedJsonTransformer: self.feedJsonTransformer)
    }()
    
    private lazy var userJsonTransformer: UserJsonTransformer = {
        return UserJsonTransformer()
    }()
    
    private lazy var signinJsonTransformer: SigninJsonTransformer = {
        return SigninJsonTransformer()
    }()

	private lazy var listAppPageJsonTransformer: ListAppPageJsonTransformer = {
		return ListAppPageJsonTransformer(feedJsonTransformer: self.feedJsonTransformer)
	}()
	
	private lazy var propertiesJsonTrasform: PropertiesJsonTransformer = {
		return PropertiesJsonTransformer()
	}()
	
	private lazy var pageAppJsonTransformer: PageAppJsonTransformer = {
		return PageAppJsonTransformer(listAppPageJsonTransformer: self.listAppPageJsonTransformer)
	}()
    
    private lazy var headerJsonTransformer: HeaderJsonTransformer = {
        return HeaderJsonTransformer(genreJsonTransformer: self.genreJsonTransformer)
    }()
    
    private lazy var genreJsonTransformer: GenreJsonTransformer = {
        return GenreJsonTransformer()
    }()
    
    private lazy var videoJsonTransformer: VideoJsonTransformer = {
        return VideoJsonTransformer(authorJsonTranformer: self.authorJsonTransformer)
    }()
    
    private lazy var videoPlaylistTransformer: VideoPlaylistTransformer = {
        return VideoPlaylistTransformer(videoJsonTransformer: self.videoJsonTransformer,
                                        listInterestJsonTransformer: self.listInterestJsonTransformer)
    }()
    
    private lazy var listVideoPlaylistTransformer: ListVideoPlaylistTransformer = {
        return ListVideoPlaylistTransformer(videoPlaylistTransformer: videoPlaylistTransformer)
    }()
    
    private lazy var commentJsonTransformer: CommentJsonTransformer = {
        return CommentJsonTransformer(authorJsonTransformer: self.authorJsonTransformer)
    }()
    
    private lazy var listCommentJsonTransformer: ListCommentJsonTransformer = {
        return ListCommentJsonTransformer(commentJsonTransformer: commentJsonTransformer)
    }()
    
    private lazy var listInfoComponentJsonTransformer: ListInfoComponetJsonTransformer = {
        return ListInfoComponetJsonTransformer(componentJsonTransformer: infoComponentJsonTransformer)
    }()
    
    private lazy var filterAuthorJsonTransformer: FilterAuthorJsonTransformer = {
        return FilterAuthorJsonTransformer()
    }()
    
    private lazy var mapSubTypeJsonTransformer: MapSubTypeJsonTransformer = {
        return MapSubTypeJsonTransformer()
    }()
    
    private lazy var filterMonthOfBirthJsonTransformer: FilterMonthOfBirthJsonTransformer = {
        return FilterMonthOfBirthJsonTransformer()
    }()
    
    private lazy var filterOccupationJsonTransformer: FilterOccupationJsonTransformer = {
        return FilterOccupationJsonTransformer()
    }()
    
    private lazy var filterSubTypeJsonTransformer: FilterSubTypeJsonTransformer = {
        return FilterSubTypeJsonTransformer(mapSubTypeJsonTransformer: self.mapSubTypeJsonTransformer)
    }()
    
    private lazy var filterContentJsonTransformer: FilterContentJsonTransformer = {
        return FilterContentJsonTransformer(filterAuthorJsonTransformer: self.filterAuthorJsonTransformer,
                                            filterSubTypeJsonTransformer: self.filterSubTypeJsonTransformer,
                                            filterMonthOfBirthJsonTransformer: self.filterMonthOfBirthJsonTransformer,
                                            filterOccupationJsonTransformer: self.filterOccupationJsonTransformer,
                                            filterGenreJsonTransformer: self.filterGenreJsonTransformer,
                                            filterShowSubTypeJsonTransformer: self.filterShowSubTypeJsonTransformer)
    }()
    
    private lazy var listAppJsonTransformer: ListAppJsonTransformer = {
        return ListAppJsonTransformer(feedJsonTransformer: self.feedJsonTransformer)
    }()
	
    private lazy var listStarJsonTransformer: ListStarJsonTransformer = {
        return ListStarJsonTransformer(contentPagePageDetailJsonTransformer: self.contentPagePageDetailJsonTransformer)
    }()
    
    private lazy var relatedContentJsonTransformer: RelatedContentJsonTransformer = {
        return RelatedContentJsonTransformer(pageJsonTransformer: self.pageJsonTransformer,
                                             mediaJsonTransformer: self.mediaJsonTransformer,
                                             videoJsonTransformer: self.videoJsonTransformer)
    }()
	
	private lazy var statisticJsonTransformer: StatisticJsonTransformer = {
		return StatisticJsonTransformer()
	}()
	
	private lazy var searchResultJsonTransformer: SearchResultJsonTransformer = {
		return SearchResultJsonTransformer(campainJsonTransformer: campaignJsonTransformer,
										   statisticJsonTransformer: statisticJsonTransformer)
	}()
    
    private lazy var searchSuggestionJsonTransformer: SearchSuggestionJsonTransformer = {
        return SearchSuggestionJsonTransformer()
    }()
    
    private lazy var listSearchSuggestionJsonTransformer: ListSearchSuggestionJsonTransformer = {
        return ListSearchSuggestionJsonTransformer(searchSuggestionJsonTransformer: searchSuggestionJsonTransformer)
    }()
    
    private lazy var appVersionJsonTransformer: AppVersionJsonTransformer = {
        return AppVersionJsonTransformer()
    }()
    
    private lazy var remoteNotificationJsonTransformer: RemoteNotificationJsonTransformer = {
        return RemoteNotificationJsonTransformer()
    }()
	
	private lazy var frequencyChannelJsonTransformer: FrequencyChannelJsonTransformer = {
		return FrequencyChannelJsonTransformer()
	}()
	
	private lazy var listFrequencyChannelJsonTransformer: ListFrequencyChannelJsonTransformer = {
		return ListFrequencyChannelJsonTransformer(frequencyChannelJsonTransformer: frequencyChannelJsonTransformer)
	}()
	
	private lazy var socialNetworkJsonTransformer: SocialNetworkJsonTransformer = {
		return SocialNetworkJsonTransformer()
	}()
	
	private lazy var listSocialNetworkJsonTransformer: ListSocialNetworkJsonTransformer = {
		return ListSocialNetworkJsonTransformer(socialNetworkJsonTransformer: socialNetworkJsonTransformer)
	}()
	
	private lazy var radioSubChannelJsonTransformer: RadioSubChannelJsonTransformer = {
		return RadioSubChannelJsonTransformer()
	}()
	
	private lazy var listRadioSubChannelJsonTransformer: ListRadioSubChannelJsonTransformer = {
		return ListRadioSubChannelJsonTransformer(radioSubChannelJsonTransformer: radioSubChannelJsonTransformer)
	}()
    
    private lazy var infoComponentJsonTransformer: InfoComponentJsonTransformer = {
        return InfoComponentJsonTransformer(infoComponentElementJsonTransformer: infoComponentElementJsonTransformer)
    }()
    
    private lazy var infoComponentElementJsonTransformer: InfoComponentElementJsonTransformer = {
        return InfoComponentElementJsonTransformer(linkedPageJsonTransformer: pageJsonTransformer,
                                                   linkedValueJsonTransformer: linkedValueJsonTransformer,
                                                   linkedCharacterPageJsonTransformer: linkedCharacterJsonTransformer)
    }()
    
    private lazy var linkedCharacterJsonTransformer: LinkedCharacterPageJsonTransformer = {
        return LinkedCharacterPageJsonTransformer()
    }()
    
    private lazy var linkedValueJsonTransformer: LinkedValueJsonTransformer = {
        return LinkedValueJsonTransformer(infoMetadataJsonTransformer: infoMetadataJsonTransformer)
    }()
    
    private lazy var infoMetadataJsonTransformer: InfoMetaDataJsonTransformer = {
        return InfoMetaDataJsonTransformer()
    }()

    private lazy var showJsonTranformer: ShowJsonTransfomer = {
        return ShowJsonTransfomer()
    }()
    
    private lazy var scheduleJsonTransformer: ScheduleJsonTransfomer = {
        return ScheduleJsonTransfomer(showJsonTransformer: showJsonTranformer,
                                      schedulerChannelJsonTransfomer: schedulerChannelJsonTransfomer)
    }()
    
    private lazy var schedulerChannelJsonTransfomer: SchedulerChannelJsonTransfomer = {
        return SchedulerChannelJsonTransfomer()
    }()
    
    private lazy var listScheduleJsonTransformer: ListScheduleJsonTransfomer = {
        return ListScheduleJsonTransfomer(scheduleJsonTransfomer: scheduleJsonTransformer)
    }()
    
    private lazy var airTimeInformationJsonTransformer: AirTimeInformationJsonTransformer = {
        return AirTimeInformationJsonTransformer()
    }()
    
    private lazy var listPageDetailJsonTransformer: ListPageDetailJsonTransformer = {
        return ListPageDetailJsonTransformer(pageDetailJsonTransformer: pageDetailJsonTransformer)
    }()
    
    private lazy var listChannelJsonTransformer: ListChannelJsonTransformer = {
        return ListChannelJsonTransformer(listPageDetailJsonTransformer: listPageDetailJsonTransformer)
    }()
    
    private lazy var filterGenreJsonTransformer: FilterGenreJsonTransformer = {
        return FilterGenreJsonTransformer()
    }()
    
    private lazy var filterShowSubTypeJsonTransformer: FilterShowSubTypeJsonTransformer = {
        return FilterShowSubTypeJsonTransformer()
    }()
    
    private lazy var listShowJsonTransformer: ListShowJsonTransformer = {
        return ListShowJsonTransformer(listPageDetailJsonTransformer: listPageDetailJsonTransformer)
    }()
    
    private lazy var episodeTabJsonTransformer: EpisodeTabJsonTransformer = {
        return EpisodeTabJsonTransformer(feedJsonTransformer: feedJsonTransformer)
    }()
    
    private lazy var scheduledChannelsJsonTransfomer: ScheduledChannelsJsonTransfomer = {
        return ScheduledChannelsJsonTransfomer()
    }()
    
    private lazy var listScheduledChannelsJsonTransfomer: ListScheduledChannelsJsonTransfomer = {
        return ListScheduledChannelsJsonTransfomer(scheduledChannelsJsonTransfomer: scheduledChannelsJsonTransfomer)
    }()
    
    // swiftlint:disable:next identifier_name
    private lazy var activityCardMessagePackageJsonTransformer: ActivityCardMessagePackageJsonTransformer = {
        return ActivityCardMessagePackageJsonTransformer()
    }()
    
    private lazy var activityCardJsonTransformer: ActivityCardJsonTransformer = {
        return ActivityCardJsonTransformer(authorJsonTransformer: authorJsonTransformer,
                                activityCardMessagePackageJsonTransformer: activityCardMessagePackageJsonTransformer)
    }()
    
    private lazy var bundleItemJsonTransformer: BundleItemJsonTransformer = {
        return BundleItemJsonTransformer()
    }()
    
    //----------------------------------------------------------------------------------------------
    // MARK: Interactor */

    static func pageDetailInteractor() -> PageDetailInteractor {
        return PageDetailInteractorImpl(contentPageApi: instance.contentPageApi, pageAlbumApi: instance.pageAlbumApi,
                                        streamApi: instance.streamApi,
                                        appApi: instance.appApi, videoApi: instance.videoApi,
                                        infoComponentApi: instance.infoComponentApi,
										languageConfigService: self.languageConfigService,
                                        pageDetailRepository: instance.pageDetailRepository,
                                        streamRepository: instance.streamRepository,
                                        pageAlbumRepository: instance.pageAlbumRepository,
                                        appTabRepository: instance.appTabRepository,
                                        videoPlaylistRepository: instance.videoPlaylistRepository,
                                        pageDetailApi: instance.pageDetailApi, schedulerApi: instance.schedulerApi,
                                        infoComponentRepository: instance.infoComponentRepository,
                                        episodeApi: instance.episodeApi, episodeRepository: instance.episodeRepository,
                                        scheduledChannelsApi: instance.scheduledChannelsApi)
    }
    
    static func menuInteractor() -> MenuInteractor {
        return MenuInteractorImpl(pageApi: instance.pageApi,
                                  authenticationService: self.authenticationService)
    }
    
    static func homeStreamInteractor() -> HomeStreamInteractor {
        let tz = TimeZone.current.secondsFromGMT() / 3600
        return HomeStreamInteractorImpl(streamApi: instance.streamApi, timeZone: tz,
                                        streamRepository: instance.streamRepository,
                                        languageConfigService: self.languageConfigService)
    }
    
    static func signupInteractor() -> SignupInteractor {
        return SignupInteractorImpl(authenticationService: self.authenticationService)
    }
    
    static func signinInteractor() -> LoginInteractor {
        return LoginInteractorImpl(authenticationService: self.authenticationService)
    }
    
    static func emailVerificationInteractor() -> EmailVerificationInteractor {
        return EmailVerificationInteractorImpl(authenticationService: self.authenticationService)
    }

    static func forgotPasswordInteractor() -> ForgotPasswordInteractor {
        return ForgotPasswordInteractorImpl(authenticationService: self.authenticationService)
    }
    
    static func userProfileInteractor() -> UserProfileInteractor {
        return UserProfileInteractorImpl(languageConfigService: self.languageConfigService,
                                         userProfileService: self.userProfileService)
    }
    
    static func commentInteractor() -> CommentInteractor {
        return CommentInteractorImpl()
    }
    
    static func videoPlaylistInteractor() -> VideoPlaylistInteractor {
        return VideoPlaylistInteractorImpl(videoApi: instance.videoApi,
                                           videoPlaylistRepository: instance.videoPlaylistRepository)
    }
    
    static func contentPageInteractor() -> ContentPageInteractor {
        return ContentPageInteractorImpl(contentPageApi: instance.contentPageApi,
                                         contentPageRepository: instance.contentPageRepository,
                                         relatedContentApi: instance.relatedContentApi)
    }
    
    static func appWhitePageInteractor() -> AppWhitePageInteractor {
        return AppWhitePageInteractorImpl(contentPageApi: instance.contentPageApi,
                                          contentPageRepository: instance.contentPageRepository)
    }
    
    static func searchInteractor() -> SearchInteractor {
		return SearchInteractorImpl(searchSuggestionApi: instance.searchSuggestionApi)
    }
    
    static func channelListingInteractor() -> ChannelListingInteractor {
        return ChannelListingInteractorImpl(channelListingApi: instance.channelListingApi,
                                            channelRepository: instance.channelRepository)
    }
    
    static func listingInteractor() -> ListingInteractor {
        return ListingInteractorImpl(appListingApi: instance.appListingApi,
                                     appTabRepository: instance.appTabRepository,
                                     filterContentApi: instance.filterContentApi,
                                     starPageListingApi: instance.starPageListingApi,
                                     starPageListingRepository: instance.starPageListingRepository,
                                     showListingApi: instance.showListingApi,
                                     showListingRepository: instance.showListingRepository)
    }
    
    static func schedulerAllChannelInterator() -> SchedulerAllChannelsInteractor {
        return SchedulerAllChannelsInteractorImpl(schedulerApi: instance.schedulerApi)
    }
    
    static func formInteractor() -> FormInteractor {
        return FormInteractorImpl(formApi: instance.formApi)
    }
}
