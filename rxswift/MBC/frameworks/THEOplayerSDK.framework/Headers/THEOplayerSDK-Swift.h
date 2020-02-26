// Generated by Apple Swift version 4.0.3 (swiftlang-900.0.74.1 clang-900.0.39.2)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_attribute(external_source_symbol)
# define SWIFT_STRINGIFY(str) #str
# define SWIFT_MODULE_NAMESPACE_PUSH(module_name) _Pragma(SWIFT_STRINGIFY(clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in=module_name, generated_declaration))), apply_to=any(function, enum, objc_interface, objc_category, objc_protocol))))
# define SWIFT_MODULE_NAMESPACE_POP _Pragma("clang attribute pop")
#else
# define SWIFT_MODULE_NAMESPACE_PUSH(module_name)
# define SWIFT_MODULE_NAMESPACE_POP
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR __attribute__((enum_extensibility(open)))
# else
#  define SWIFT_ENUM_ATTR
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_ATTR SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if __has_feature(modules)
@import ObjectiveC;
@import Foundation;
@import CoreGraphics;
@import UIKit;
@import WebKit;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

SWIFT_MODULE_NAMESPACE_PUSH("THEOplayerSDK")

/// The AdDescription object can be of type THEOplayerAdDescription or SpotXAdDescription
SWIFT_CLASS("_TtC13THEOplayerSDK13AdDescription")
@interface AdDescription : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


/// The AnalyticsDescription object can be of type YouboraOptions
SWIFT_CLASS("_TtC13THEOplayerSDK20AnalyticsDescription")
@interface AnalyticsDescription : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


/// Abstract class from which its subclasses can add and remove event listeners.
SWIFT_CLASS("_TtC13THEOplayerSDK15EventDispatcher")
@interface EventDispatcher : NSObject
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


/// Geographical location object
SWIFT_CLASS("_TtC13THEOplayerSDK3Geo")
@interface Geo : NSObject
/// Latitude
@property (nonatomic) double lat SWIFT_DEPRECATED_OBJC("Swift property 'Geo.lat' uses '@objc' inference deprecated in Swift 4; add '@objc' to provide an Objective-C entrypoint");
/// Longitude
@property (nonatomic) double lon SWIFT_DEPRECATED_OBJC("Swift property 'Geo.lon' uses '@objc' inference deprecated in Swift 4; add '@objc' to provide an Objective-C entrypoint");
/// Construct a Geo object
- (nonnull instancetype)initWithLat:(double)lat lon:(double)lon OBJC_DESIGNATED_INITIALIZER SWIFT_DEPRECATED_OBJC("Swift initializer 'Geo.init(lat:lon:)' uses '@objc' inference deprecated in Swift 4; add '@objc' to provide an Objective-C entrypoint");
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


/// A <code>GoogleImaAdDescription</code> object contains a description of an advertisement that will be added to the player using the Google Ima integration.
SWIFT_CLASS("_TtC13THEOplayerSDK22GoogleImaAdDescription")
@interface GoogleImaAdDescription : AdDescription
/// The ‘src’ property represents the source of the ad (VAST/VMAP). The player will download the content available at the URL and will schedule the specified advertisement(s). The Google IMA ad integration supports VAST, VMAP and VPAID files.
@property (nonatomic, copy) NSURL * _Nonnull src;
/// Specifies when an ad should be played in the content video.
/// Currently supports the following values: ‘start’, ‘end’, and percentages (string, e.g. ‘10%’).
/// important:
/// Only use this property for VAST-files. THEOplayer will ignore this value for VMAP-files, because they already have their own offset.
@property (nonatomic, copy) NSString * _Nullable timeOffset;
/// Constructs a GoogleImaAdDescription
/// \param src the source of the ad
///
/// \param timeOffset the optional time offset
///
- (nonnull instancetype)initWithSrc:(NSString * _Nonnull)src timeOffset:(NSString * _Nullable)timeOffset OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


/// FairPlay key system configuration
SWIFT_CLASS("_TtC13THEOplayerSDK22KeySystemConfiguration")
@interface KeySystemConfiguration : NSObject
/// FairPlay
@property (nonatomic, copy) NSString * _Nonnull name SWIFT_DEPRECATED_OBJC("Swift property 'KeySystemConfiguration.name' uses '@objc' inference deprecated in Swift 4; add '@objc' to provide an Objective-C entrypoint");
/// Specifies the URL of the licensing server.
@property (nonatomic, copy) NSURL * _Nullable licenseAcquisitionURL SWIFT_DEPRECATED_OBJC("Swift property 'KeySystemConfiguration.licenseAcquisitionURL' uses '@objc' inference deprecated in Swift 4; add '@objc' to provide an Objective-C entrypoint");
/// Specifies the URL of the FairPlay certificate server.
@property (nonatomic, copy) NSURL * _Nullable certificateURL SWIFT_DEPRECATED_OBJC("Swift property 'KeySystemConfiguration.certificateURL' uses '@objc' inference deprecated in Swift 4; add '@objc' to provide an Objective-C entrypoint");
/// Constructs a KeySystemConfiguration
/// \param licenseAcquisitionURL the URL of the licensing server
///
/// \param certificateURL the URL of the certificate server
///
- (nonnull instancetype)initWithName:(NSString * _Nonnull)name licenseAcquisitionURL:(NSString * _Nullable)licenseAcquisitionURL certificateURL:(NSString * _Nullable)certificateURL OBJC_DESIGNATED_INITIALIZER SWIFT_DEPRECATED_OBJC("Swift initializer 'KeySystemConfiguration.init(name:licenseAcquisitionURL:certificateURL:)' uses '@objc' inference deprecated in Swift 4; add '@objc' to provide an Objective-C entrypoint");
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


/// A MetadataDescription consists of:
SWIFT_CLASS("_TtC13THEOplayerSDK19MetadataDescription")
@interface MetadataDescription : NSObject
/// A dictionary of metadata
@property (nonatomic, copy) NSDictionary<NSString *, id> * _Nullable metadataKeys SWIFT_DEPRECATED_OBJC("Swift property 'MetadataDescription.metadataKeys' uses '@objc' inference deprecated in Swift 4; add '@objc' to provide an Objective-C entrypoint");
/// Constructs a MetadataDescription
- (nonnull instancetype)initWithMetadataKeys:(NSDictionary<NSString *, id> * _Nullable)metadataKeys OBJC_DESIGNATED_INITIALIZER SWIFT_DEPRECATED_OBJC("Swift initializer 'MetadataDescription.init(metadataKeys:)' uses '@objc' inference deprecated in Swift 4; add '@objc' to provide an Objective-C entrypoint");
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


/// Configure Moat analytics pre-integration
SWIFT_CLASS("_TtC13THEOplayerSDK11MoatOptions")
@interface MoatOptions : AnalyticsDescription
/// Constructs a MoatOptions object
/// \param partnerCode the Moat partnerCode
///
- (nonnull instancetype)initWithPartnerCode:(NSString * _Nonnull)partnerCode OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

@class TypedSource;
@class TextTrackDescription;

/// The <code>SourceDescription</code> object is used to describe a configuration of a source for a THEOplayer instance.
SWIFT_CLASS("_TtC13THEOplayerSDK17SourceDescription")
@interface SourceDescription : NSObject
/// Represents the source of the media to be played.
@property (nonatomic, copy) NSArray<TypedSource *> * _Nonnull sources SWIFT_DEPRECATED_OBJC("Swift property 'SourceDescription.sources' uses '@objc' inference deprecated in Swift 4; add '@objc' to provide an Objective-C entrypoint");
/// The textTracks property can be used to add an array of side-loaded text tracks to the player. All valid tracks will be available for playback as long as the player’s source is not set again. Each text track should be described as a TextTrackDescription.
@property (nonatomic, copy) NSArray<TextTrackDescription *> * _Nullable textTracks SWIFT_DEPRECATED_OBJC("Swift property 'SourceDescription.textTracks' uses '@objc' inference deprecated in Swift 4; add '@objc' to provide an Objective-C entrypoint");
/// The poster property can be used to specify a content poster per source. The player’s content poster will be updated as soon as a new source with valid poster is set, or when the player’s own poster property is altered.
@property (nonatomic, copy) NSURL * _Nullable poster SWIFT_DEPRECATED_OBJC("Swift property 'SourceDescription.poster' uses '@objc' inference deprecated in Swift 4; add '@objc' to provide an Objective-C entrypoint");
/// Metadata that can be used to describe content, e.g. when casting to chromecast.
@property (nonatomic, strong) MetadataDescription * _Nullable metadata SWIFT_DEPRECATED_OBJC("Swift property 'SourceDescription.metadata' uses '@objc' inference deprecated in Swift 4; add '@objc' to provide an Objective-C entrypoint");
/// Constructs a SourceDescription
/// \param sources an array of TypedSource
///
/// \param textTracks the optional text track
///
/// \param poster the optional poster URL
///
- (nonnull instancetype)initWithSources:(NSArray<TypedSource *> * _Nonnull)sources textTracks:(NSArray<TextTrackDescription *> * _Nullable)textTracks poster:(NSString * _Nullable)poster metadata:(MetadataDescription * _Nullable)metadata OBJC_DESIGNATED_INITIALIZER;
/// Constructs a SourceDescription
/// \param source a TypedSource
///
/// \param textTracks the optional text track
///
/// \param poster the optional poster URL
///
- (nonnull instancetype)initWithSource:(TypedSource * _Nonnull)source textTracks:(NSArray<TextTrackDescription *> * _Nullable)textTracks poster:(NSString * _Nullable)poster metadata:(MetadataDescription * _Nullable)metadata OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

@class VRConfiguration;

SWIFT_AVAILABILITY(ios,introduced=11.0)
@interface SourceDescription (SWIFT_EXTENSION(THEOplayerSDK))
/// The ‘vr’ property can be used to configure VR video playback.
@property (nonatomic, strong) VRConfiguration * _Nullable vr SWIFT_DEPRECATED_OBJC("Swift property 'SourceDescription.vr' uses '@objc' inference deprecated in Swift 4; add '@objc' to provide an Objective-C entrypoint");
/// Constructs a SourceDescription
/// \param sources an array of TypedSource
///
/// \param ads the optional ad descriptions
///
/// \param textTracks the optional text track
///
/// \param poster the optional poster URL
///
/// \param analytics the optional analytics configurations
///
/// \param metadata Any free-form metadata you’d like to add.
///
/// \param vr The VR configuration for this source. (ONLY SUPPORTED ON IOS 11+)
///
- (nonnull instancetype)initWithSources:(NSArray<TypedSource *> * _Nonnull)sources ads:(NSArray<AdDescription *> * _Nullable)ads textTracks:(NSArray<TextTrackDescription *> * _Nullable)textTracks poster:(NSString * _Nullable)poster analytics:(NSArray<AnalyticsDescription *> * _Nullable)analytics metadata:(MetadataDescription * _Nullable)metadata vr:(VRConfiguration * _Nullable)vr;
/// Constructs a SourceDescription
/// \param source a TypedSource
///
/// \param ads the optional ad descriptions
///
/// \param textTracks the optional text track
///
/// \param poster the optional poster URL
///
/// \param analytics the optional analytics configurations
///
/// \param metadata Any free-form metadata you’d like to add.
///
/// \param vr The VR configuration for this source. (ONLY SUPPORTED ON IOS 11+)
///
- (nonnull instancetype)initWithSource:(TypedSource * _Nonnull)source ads:(NSArray<AdDescription *> * _Nullable)ads textTracks:(NSArray<TextTrackDescription *> * _Nullable)textTracks poster:(NSString * _Nullable)poster analytics:(NSArray<AnalyticsDescription *> * _Nullable)analytics metadata:(MetadataDescription * _Nullable)metadata vr:(VRConfiguration * _Nullable)vr;
@end


@interface SourceDescription (SWIFT_EXTENSION(THEOplayerSDK))
/// The ads property can be used to add an array of AdDescriptions to the player. All valid and supported advertisement files will be cued for playback in the player. Each ad in the array should be described as an AdDescription.
@property (nonatomic, copy) NSArray<AdDescription *> * _Nullable ads SWIFT_DEPRECATED_OBJC("Swift property 'SourceDescription.ads' uses '@objc' inference deprecated in Swift 4; add '@objc' to provide an Objective-C entrypoint");
/// The analytics property can be used to add an array of analytics integrations to the player.
@property (nonatomic, copy) NSArray<AnalyticsDescription *> * _Nullable analytics SWIFT_DEPRECATED_OBJC("Swift property 'SourceDescription.analytics' uses '@objc' inference deprecated in Swift 4; add '@objc' to provide an Objective-C entrypoint");
/// Constructs a SourceDescription
/// \param sources an array of TypedSource
///
/// \param ads the optional ad descriptions
///
/// \param textTracks the optional text track
///
/// \param poster the optional poster URL
///
/// \param analytics the optional analytics configurations
///
/// \param metadata Any free-form metadata you’d like to add.
///
- (nonnull instancetype)initWithSources:(NSArray<TypedSource *> * _Nonnull)sources ads:(NSArray<AdDescription *> * _Nullable)ads textTracks:(NSArray<TextTrackDescription *> * _Nullable)textTracks poster:(NSString * _Nullable)poster analytics:(NSArray<AnalyticsDescription *> * _Nullable)analytics metadata:(MetadataDescription * _Nullable)metadata;
/// Constructs a SourceDescription
/// \param source a TypedSource
///
/// \param ads the optional ad descriptions
///
/// \param textTracks the optional text track
///
/// \param poster the optional poster URL
///
/// \param analytics the optional analytics configurations
///
/// \param metadata Any free-form metadata you’d like to add.
///
- (nonnull instancetype)initWithSource:(TypedSource * _Nonnull)source ads:(NSArray<AdDescription *> * _Nullable)ads textTracks:(NSArray<TextTrackDescription *> * _Nullable)textTracks poster:(NSString * _Nullable)poster analytics:(NSArray<AnalyticsDescription *> * _Nullable)analytics metadata:(MetadataDescription * _Nullable)metadata;
@end


/// A <code>SpotXAdDescription</code> object contains a description of a SpotX advertisement that will be added to the player using the SpotX integration.
SWIFT_CLASS("_TtC13THEOplayerSDK18SpotXAdDescription")
@interface SpotXAdDescription : AdDescription
/// Your SpotX id
@property (nonatomic, copy) NSString * _Nonnull id SWIFT_DEPRECATED_OBJC("Swift property 'SpotXAdDescription.id' uses '@objc' inference deprecated in Swift 4; add '@objc' to provide an Objective-C entrypoint");
/// Add the VMaxd parameter with a duration to the SpotX tag
@property (nonatomic, copy) NSString * _Nullable maximumAdDuration SWIFT_DEPRECATED_OBJC("Swift property 'SpotXAdDescription.maximumAdDuration' uses '@objc' inference deprecated in Swift 4; add '@objc' to provide an Objective-C entrypoint");
/// Add a IP address
@property (nonatomic, copy) NSString * _Nullable ipAddress SWIFT_DEPRECATED_OBJC("Swift property 'SpotXAdDescription.ipAddress' uses '@objc' inference deprecated in Swift 4; add '@objc' to provide an Objective-C entrypoint");
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


/// A <code>THEOplayerAdDescription</code> object contains a description of an advertisement that will be added to the player.
SWIFT_CLASS("_TtC13THEOplayerSDK17THEOAdDescription")
@interface THEOAdDescription : AdDescription
/// The ‘src’ property represents the source of the ad (VAST/VMAP). The player will download the content available at the URL and will schedule the specified advertisement(s). Currently, the THEO ad integration supports VAST and VMAP files.
@property (nonatomic, copy) NSURL * _Nonnull src;
/// Specifies when an ad should be played in the content video.
/// Currently supports the following values: ‘start’, ‘end’, and percentages (string, e.g. ‘10%’).
/// important:
/// Only use this property for VAST-files. THEOplayer will ignore this value for VMAP-files, because they already have their own offset.
@property (nonatomic, copy) NSString * _Nullable timeOffset;
/// Specifies when a linear ad can be skipped.
/// Value should be a percentage string, e.g. ‘10%’.
/// This value overwrites the value specified in the VAST-files, unless the skipOffset would be higher than the duration of the ad video (e.g. 110%).
@property (nonatomic, copy) NSString * _Nullable skipOffset;
/// Constructs a THEOAdDescription
/// \param src the source of the ad
///
/// \param timeOffset the optional time offset
///
/// \param skipOffset the optional skip offset
///
- (nonnull instancetype)initWithSrc:(NSString * _Nonnull)src timeOffset:(NSString * _Nullable)timeOffset skipOffset:(NSString * _Nullable)skipOffset OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


SWIFT_PROTOCOL("_TtP13THEOplayerSDK17THEOScriptMessage_")
@protocol THEOScriptMessage
@property (nonatomic, readonly) id _Nonnull body;
@property (nonatomic, readonly, copy) NSString * _Nonnull name;
@end


SWIFT_PROTOCOL("_TtP13THEOplayerSDK24THEOScriptMessageHandler_")
@protocol THEOScriptMessageHandler
- (void)didReceiveWithMessage:(id <THEOScriptMessage> _Nonnull)message;
@end

@class TimeRange;
@class UIView;

/// The THEOplayer object
SWIFT_CLASS("_TtC13THEOplayerSDK10THEOplayer")
@interface THEOplayer : NSObject
@property (nonatomic, readonly) BOOL isDestroyed SWIFT_DEPRECATED_OBJC("Swift property 'THEOplayer.isDestroyed' uses '@objc' inference deprecated in Swift 4; add '@objc' to provide an Objective-C entrypoint");
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
/// The frame rectangle, which describes the THEOplayer view’s location and size in its superview’s coordinate system.
@property (nonatomic) CGRect frame;
/// The bounds rectangle, which describes the THEOplayer  view’s location and size in its own coordinate system.
@property (nonatomic) CGRect bounds;
/// The center of the THEOplayer view’s frame.
@property (nonatomic) CGPoint center;
/// An integer bit mask that determines how the THEOplayer view resizes itself when its superview’s bounds change.
@property (nonatomic) UIViewAutoresizing autoresizingMask;
/// Sets or returns if the video should automatically start playing
/// remark:
/// If you set autoplay to true, this will set preload to ‘auto’.
/// Preload will be back to the previous state if you set autoplay back to false.
/// If you want to use autoplay, you should not modify the preload or the autoplay won’t work.
@property (nonatomic) BOOL autoplay;
/// Sets or Returns the current source of the video
/// After invoking the setter, the player sets the provided playback source and applies the provided parameters in the source description. The source description is an object that should be constructed by the user and which should implement the SourceDescription interface.
@property (nonatomic, strong) SourceDescription * _Nullable source;
/// Returns the current source URL of the video
@property (nonatomic, readonly, copy) NSString * _Nullable src;
/// Sets or returns the volume of the video
@property (nonatomic) float volume;
/// Sets or returns whether the audio output of the video is muted or not
@property (nonatomic) BOOL muted;
/// Return whether the video is seeking or not.
@property (nonatomic, readonly) BOOL seeking;
/// Returns whether the video is paused or not.
@property (nonatomic, readonly) BOOL paused;
/// Returns whether the video has ended or not.
@property (nonatomic, readonly) BOOL ended;
/// Returns current playback rate of the player.
/// <em>1</em> referring to normal speed.
@property (nonatomic, readonly) double playbackRate;
/// Returns the last encountered player error.
@property (nonatomic, readonly, copy) NSString * _Nullable error;
/// After invoking this method, the player starts playback.
- (void)play;
/// After invoking this method, the player pauses playback.
- (void)pause;
/// Sets the current playback position in the video
/// \param newValue The new playback position in seconds
///
/// \param completionHandler <em>Optional</em> A closure to invoke when operation completes or fails
///
- (void)setCurrentTime:(double)newValue completionHandler:(void (^ _Nullable)(id _Nullable, NSError * _Nullable))completionHandler;
/// Requests the current ProgramDateTime of the player.
/// \param completionHandler A closure to invoke when operation completes or fails
///
- (void)requestCurrentProgramDateTimeWithCompletionHandler:(void (^ _Nonnull)(NSDate * _Nullable, NSError * _Nullable))completionHandler;
/// Sets the current ProgramDateTime of the player.
/// \param newValue The new ProgramDateTime
///
/// \param completionHandler <em>Optional</em> A closure to invoke when operation completes or fails
///
- (void)setCurrentProgramDateTime:(NSString * _Nonnull)newValue completionHandler:(void (^ _Nullable)(id _Nullable, NSError * _Nullable))completionHandler;
/// Sets the playback rate of the player.
/// \param newValue The new playback rate
///
/// \param completionHandler <em>Optional</em> A closure to invoke when operation completes or fails
///
- (void)setPlaybackRate:(double)newValue completionHandler:(void (^ _Nullable)(id _Nullable, NSError * _Nullable))completionHandler;
/// Request the buffered TimeRanges of the player.
/// \param completionHandler A closure to invoke when operation completes or fails
///
- (void)requestBufferedWithCompletionHandler:(void (^ _Nonnull)(NSArray<TimeRange *> * _Nullable, NSError * _Nullable))completionHandler;
/// Request the played TimeRanges of the player.
/// \param completionHandler A closure to invoke when operation completes or fails
///
- (void)requestPlayedWithCompletionHandler:(void (^ _Nonnull)(NSArray<TimeRange *> * _Nullable, NSError * _Nullable))completionHandler;
/// Adds the THEOplayer view to the end of the parameter view’s list of subviews.
/// \param view The view on which the THEOplayer view will be added as a subview.
///
- (void)addAsSubviewOf:(UIView * _Nonnull)view;
/// Inserts the THEOplayer view at the specified index of the parameter view’s list of subviews.
/// \param view The view on which the THEOplayer view will be added as a subview.
///
/// \param at The index in the array of the subviews property at which to insert the THEOplayer view. Subview indices start at 0 and cannot be greater than the number of subviews.
///
- (void)insertAsSubviewOf:(UIView * _Nonnull)view at:(NSInteger)at;
/// Inserts the THEOplayer view below another view in the parameter view’s hierarchy.
/// \param view The view on which the THEOplayer view will be added as a subview.
///
/// \param siblingSubview The sibling view that will be above the THEOplayer view.
///
- (void)insertAsSubviewOf:(UIView * _Nonnull)view belowSubview:(UIView * _Nonnull)siblingSubview;
/// Inserts the THEOplayer view above another view in the parameter view’s hierarchy.
/// \param view The view on which the THEOplayer view will be added as a subview.
///
/// \param siblingSubview The sibling view that will be behind the inserted THEOplayer view.
///
- (void)insertAsSubviewOf:(UIView * _Nonnull)view aboveSubview:(UIView * _Nonnull)siblingSubview;
/// Returns a Boolean value indicating whether the THEOplayer is contained the given array of UIview.
/// \code
/// self.theoplayer.isContained(in: self.view.subviews)
///
/// \endcode\param views The array of views in which search for the THEOplayer.
///
- (BOOL)isContainedIn:(NSArray<UIView *> * _Nonnull)views SWIFT_WARN_UNUSED_RESULT;
/// Request the seekable TimeRanges of the player.
/// \param completionHandler A closure to invoke when operation completes or fails
///
- (void)requestSeekableWithCompletionHandler:(void (^ _Nonnull)(NSArray<TimeRange *> * _Nullable, NSError * _Nullable))completionHandler;
/// Unloads the THEOplayer. All future calls to this object will throw an error.
- (void)destroy;
@end

@class THEOplayerConfiguration;

@interface THEOplayer (SWIFT_EXTENSION(THEOplayerSDK))
/// Create a new instance of THEOplayer.
/// \param configuration <em>Optional</em> A configuration for the new THEOplayer
///
- (nonnull instancetype)initWithConfiguration:(THEOplayerConfiguration * _Nullable)configuration;
/// Create a new instance of THEOplayer with a frame.
/// \param frame The frame rectangle, which describes the THEOplayer view’s location and size in its superview’s coordinate system.
///
/// \param configuration <em>Optional</em> A configuration for the new THEOplayer
///
- (nonnull instancetype)initWith:(CGRect)frame configuration:(THEOplayerConfiguration * _Nullable)configuration;
/// Turns on or off the coupling of fullscreen and device orientation. This means that landscape will be coupled to fullscreen mode and portrait will be couple to non-fullscreen mode. Switching rotation or fullscreen state will also trigger changin to the couple counterpart. Default is set to <em>false</em>.
@property (nonatomic) BOOL fullscreenOrientationCoupling;
/// Add a JavaScript message listener
/// When using a custom JavaScript file, you can communicate to native code through the window.webkit.messageHandlers.‘messageName’.postMessage() method.
/// \param name The name of the message
///
/// \param listener The callback invoked in native code.
///
- (void)addJavascriptMessageListenerWithName:(NSString * _Nonnull)name listener:(void (^ _Nonnull)(NSDictionary<NSString *, id> * _Nonnull))listener;
/// Remove a JavaScript message listener previously added with addMessageListener(name:listener:)
/// \param name The name of the message
///
- (void)removeJavascriptMessageListenerWithName:(NSString * _Nonnull)name;
/// Evaluates a JavaScript string.
/// The method sends the result of the script evaluation (or an error) to the completion handler. The completion handler always runs on the main thread.
/// \param javaScriptString The JavaScript string to evaluate.
///
/// \param completionHandler A block to invoke when script evaluation completes or fails.
///
- (void)evaluateJavaScript:(NSString * _Nonnull)javaScriptString completionHandler:(void (^ _Nullable)(id _Nullable, NSError * _Nullable))completionHandler;
- (void)unload SWIFT_DEPRECATED_MSG("Use destroy() instead") SWIFT_DEPRECATED_OBJC("Swift method 'THEOplayer.unload()' uses '@objc' inference deprecated in Swift 4; add '@objc' to provide an Objective-C entrypoint");
@end


/// A THEOplayerConfiguration object contains properties used to configure a THEOplayer
SWIFT_CLASS("_TtC13THEOplayerSDK23THEOplayerConfiguration")
@interface THEOplayerConfiguration : NSObject
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


/// A TextTrackDescription object contains a description of a side-loaded text track that will be added to the player.
SWIFT_CLASS("_TtC13THEOplayerSDK20TextTrackDescription")
@interface TextTrackDescription : NSObject
/// Specifies a source URL where the text track can be downloaded from.
@property (nonatomic, copy) NSURL * _Nonnull src SWIFT_DEPRECATED_OBJC("Swift property 'TextTrackDescription.src' uses '@objc' inference deprecated in Swift 4; add '@objc' to provide an Objective-C entrypoint");
/// Specifies the main language of the track.
@property (nonatomic, copy) NSString * _Nonnull srclang SWIFT_DEPRECATED_OBJC("Swift property 'TextTrackDescription.srclang' uses '@objc' inference deprecated in Swift 4; add '@objc' to provide an Objective-C entrypoint");
/// Optionally specifies a label for the track which can be used to identify it.
@property (nonatomic, copy) NSString * _Nullable label SWIFT_DEPRECATED_OBJC("Swift property 'TextTrackDescription.label' uses '@objc' inference deprecated in Swift 4; add '@objc' to provide an Objective-C entrypoint");
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


/// A range of time
SWIFT_CLASS("_TtC13THEOplayerSDK9TimeRange")
@interface TimeRange : NSObject
/// Start of the range
@property (nonatomic, readonly) double start;
/// End of the range
@property (nonatomic, readonly) double end;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end




/// The <code>TypedSource</code> object provides the following properties:
SWIFT_CLASS("_TtC13THEOplayerSDK11TypedSource")
@interface TypedSource : NSObject
/// The ‘src’ property represents the source URL of the manifest or video file to be played.
@property (nonatomic, copy) NSURL * _Nonnull src;
/// Specifies the content type (MIME type) of source being played. <code>'application/x-mpegURL'</code> or <code>'application/vnd.apple.mpegurl'</code> indicates HLS, <code>'video/mp4'</code> indicates MP4.
@property (nonatomic, copy) NSString * _Nonnull type;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end








/// A VRConfiguration object contains the settings for 360 VR video playback. (ONLY USABLE ON IOS 11+)
SWIFT_CLASS("_TtC13THEOplayerSDK15VRConfiguration")
@interface VRConfiguration : NSObject
/// This attributed indicates whether 360 VR is enabled.
@property (nonatomic) BOOL vr360 SWIFT_DEPRECATED_OBJC("Swift property 'VRConfiguration.vr360' uses '@objc' inference deprecated in Swift 4; add '@objc' to provide an Objective-C entrypoint");
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


@interface WKScriptMessage (SWIFT_EXTENSION(THEOplayerSDK)) <THEOScriptMessage>
@end




/// Configure Youbora analytics pre-integration
SWIFT_CLASS("_TtC13THEOplayerSDK14YouboraOptions")
@interface YouboraOptions : AnalyticsDescription
- (void)putWithKey:(NSString * _Nonnull)key value:(NSString * _Nonnull)value;
- (void)putMapWithKey:(NSString * _Nonnull)key value:(NSDictionary<NSString *, NSString *> * _Nonnull)value;
/// Constructs a YouboraOptions object
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
/// Constructs a YouboraOptions object
/// \param accountCode the Youbora accountCode
///
- (nonnull instancetype)initWithAccountCode:(NSString * _Nonnull)accountCode OBJC_DESIGNATED_INITIALIZER;
@end

SWIFT_MODULE_NAMESPACE_POP
#pragma clang diagnostic pop
