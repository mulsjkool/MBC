//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#ifndef MBC_Bridging_Header_h
#define MBC_Bridging_Header_h

#import <GigyaSDK/Gigya.h>
#import <TeadsSDK/TeadsSDK.h>
#import "IQKeyboardManager.h"
#import <DMSMoatMobileAppKit/DMSMoatAnalytics.h>
#import <DMSMoatMobileAppKit/DMSMoatBaseTracker.h>
#import <DMSMoatMobileAppKit/DMSMoatNativeDisplayTracker.h>
#import "IconDownloader.h"
#import "RemoteImage.h"

@interface DMSMoatAnalytics (DMSMoatAnalyticsSwift)
- (BOOL)prepareTracking:(NSString *)partnerCode;
@end

#endif
