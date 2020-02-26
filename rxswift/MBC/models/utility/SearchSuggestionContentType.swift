//
//  SearchSuggestionContentType.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 3/1/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

enum SearchSuggestionContentType: String {
    case page
    case playlist
    case bundle
    case app
    case article
    
    // Post
    case postImageSingle = "post.image.single"
    case postText = "post.text"
    case postEmbed = "post.embed"
    case postEpisode = "post.episode"
    case postImageMultipleTitle = "post.image.multiple.title"
    case postImageMultipleWithOutTitle = "post.image.multiple.withOutTitle"
    case postImageMultiple = "post.image.multiple"
    case postVideo = "post.video"
    
    // Profile
    case profileStar = "page.profile.star"
    case profileSportPlayer = "page.profile.sportPlayer"
    case profileGuest = "page.profile.guest"
    case profileTalent = "page.profile.talent"
    case profileSportTeam = "page.profile.sportTeam"
    case profileBand = "page.profile.band"
    
    // Show
    case postShowVideo = "page.show.movie"
    case postShowSeries = "page.show.series"
    case postShowProgram = "page.show.program"
    case postShowNews = "page.show.news"
    case postShowMatch = "page.show.match"
    case postShowPlay = "page.show.play"
    
    // Channel
    case channelRadio = "page.channel.radioChannel"
    case channelTV = "page.channel.tvChannel"
    /*
     page.profile.star
     page.profile.sportPlayer
     page.profile.guest
     page.profile.talent
     page.profile.sportTeam
     page.profile.band
     
     page.show.movie
     page.show.series
     page.show.program
     page.show.news
     page.show.match
     page.show.play
     
     page.channel.radioChannel
     page.channel.tvChannel
     
     article
     bundle
     playlist
     app
     post.video
     post.embed
     post.text
     post.episode
     post.image.multiple.withOutTitle
     post.image.multiple.title
     post.image.single
     */
}
