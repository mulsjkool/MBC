 /*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Object encapsulating information about an iOS app in the 'Top Paid Apps' RSS feed.
  Each one corresponds to a row in the app's table.
 */

@import Foundation;
@import UIKit;

@interface RemoteImage : NSObject

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSString *imageURLString;

@end
