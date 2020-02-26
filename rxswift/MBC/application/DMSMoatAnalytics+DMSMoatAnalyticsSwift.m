//
//  DMSMoatAnalytics+DMSMoatAnalyticsSwift.m
//  MBC
//
//  Created by Tram Nguyen on 4/19/18.
//  Copyright © 2018 MBC. All rights reserved.
//

#import "MBC-Bridging-Header.h"

@implementation DMSMoatAnalytics (DMSMoatAnalyticsSwift)
- (BOOL)prepareTracking:(NSString *)partnerCode {
    NSError *error;
    BOOL success = [self prepareNativeDisplayTracking:partnerCode error:&error];
    return success;
}
@end
