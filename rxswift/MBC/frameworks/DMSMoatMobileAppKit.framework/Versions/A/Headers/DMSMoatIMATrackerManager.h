//
//  IMAMoatTrackerManager.h
//  MoatMobileAppKit
//
//  Created by alex on 8/12/15.
//  Copyright © 2016 Moat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
#import <GoogleInteractiveMediaAds/GoogleInteractiveMediaAds.h>

/** Tracker for tracking IMA video ads. */
@interface DMSMoatIMATrackerManager : NSObject

@property (weak) UIView *baseView;

/** Creates tracker manager for tracking IMA ads.
 *
 * The best place to initialize the tracker manager is right after you’ve created your IMAAdsLoader instance. 
 * It’s recommended that the tracker should have the same lifetime as the IMAAdsLoader instance.
 *
 * @param partnerCode The code provided to you by Moat for video ad tracking.
 * @return DMSMoatIMATrackerManager instance
 */
- (id)initWithPartnerCode:(NSString *) partnerCode;

/** Call to report a video ad event.
 *
 * In the AdsManager didReceiveAdEvent delegate method, forward all video events
 * to the Moat tracker.
 */
- (void)dispatchEvent:(IMAAdEvent *)event;

/** Call to report that the ad has ended and content has resumed
 *
 * Should be called from the AdsManager adsManagerDidRequestContentResume delegate method
 */
- (void)onPodEnded;

- (void)onPodError;

- (void)stop;

@end
