//
//  DMSMoatTrackerDelegate.h
//  DMSMoatMobileAppKit
//
//  Created by Moat 740 on 3/27/17.
//  Copyright © 2017 Moat. All rights reserved.
//

#import "DMSMoatAdEventType.h"

#ifndef DMSMoatTrackerDelegate_h
#define DMSMoatTrackerDelegate_h

typedef enum : NSUInteger {
    DMSMoatStartFailureTypeNone = 0, //Default none value
    DMSMoatStartFailureTypeActive,   //The tracker was already active
    DMSMoatStartFailureTypeRestart,  //The tracker was stopped already
    DMSMoatStartFailureTypeBadArgs,  //The arguments provided upon initialization or startTracking were invalid.
} DMSMoatStartFailureType;

@class DMSMoatBaseTracker;
@class DMSMoatBaseVideoTracker;

@protocol DMSMoatTrackerDelegate <NSObject>

@optional

/**
 Notifies delegate that the tracker has started tracking.
 */

- (void)trackerStartedTracking:(DMSMoatBaseTracker *)tracker;

/**
 Notifies delegate that the tracker has stopped tracking.
 */

- (void)trackerStoppedTracking:(DMSMoatBaseTracker *)tracker;

/**
 Notifies delegate that the tracker failed to start.
 
 @param type Type of startTracking failure.
 @param reason A human readable string on why the tracking failed.
 */

- (void)tracker:(DMSMoatBaseTracker *)tracker failedToStartTracking:(DMSMoatStartFailureType)type reason:(NSString *)reason;

@end

#pragma mark

@protocol DMSMoatVideoTrackerDelegate <NSObject>

@optional

/**
 Notifies delegate an ad event type is being dispatched (i.e. start, pause, quarterly events).
 
 @param adEventType The type of event fired.
 */
- (void)tracker:(DMSMoatBaseVideoTracker *)tracker sentAdEventType:(DMSMoatAdEventType)adEventType;

@end

#endif /* DMSMoatTrackerDelegate_h */
