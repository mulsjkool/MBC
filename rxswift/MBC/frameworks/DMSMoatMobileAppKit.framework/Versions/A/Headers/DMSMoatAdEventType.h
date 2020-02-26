//
//  DMSMoatAdEventType.h
//  DMSMoatMobileAppKit
//
//  Created by Moat 740 on 3/27/17.
//  Copyright © 2017 Moat. All rights reserved.
//

#ifndef DMSMoatAdEventType_h
#define DMSMoatAdEventType_h

typedef enum DMSMoatAdEventType : NSUInteger {
    DMSMoatAdEventComplete
    , DMSMoatAdEventStart
    , DMSMoatAdEventFirstQuartile
    , DMSMoatAdEventMidPoint
    , DMSMoatAdEventThirdQuartile
    , DMSMoatAdEventSkipped
    , DMSMoatAdEventStopped
    , DMSMoatAdEventPaused
    , DMSMoatAdEventPlaying
    , DMSMoatAdEventVolumeChange
    , DMSMoatAdEventNone
} DMSMoatAdEventType;

#endif /* DMSMoatAdEventType_h */
