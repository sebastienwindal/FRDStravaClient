//
//  StravaStream.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/3/14.
//

#import <Mantle/Mantle.h>
#import "StravaCommon.h"

///
/// Stream resolution.
///
/// Matching Strava API docs: http://strava.github.io/api/v3/streams/
///
typedef NS_ENUM(NSInteger, kStravaStreamResolution) {
    kStravaStreamResolutionUnknown,
    kStravaStreamResolutionLow,
    kStravaStreamResolutionMedium,
    kStravaStreamResolutionHigh
};

///
/// Stream type.
///
/// Matching Strava API docs: http://strava.github.io/api/v3/streams/
///
typedef NS_ENUM(NSInteger, kStravaStreamType) {
    kStravaStreamTypeUnknown,
    kStravaStreamTypeTime,
    kStravaStreamTypeLatLng,
    kStravaStreamTypeDistance,
    kStravaStreamTypeAltitude,
    kStravaStreamTypeVelocitySmooth,
    kStravaStreamTypeHeartrate,
    kStravaStreamTypeCadence,
    kStravaStreamTypeWatts,
    kStravaStreamTypeTemperature,
    kStravaStreamTypeMoving,
    kStravaStreamTypeGradesmooth
};


///
/// Stream object.
///
/// Matching Strava API docs: http://strava.github.io/api/v3/streams/
///
/// Note that unlike everything else where Mantle does a nice job at converting all the JSON data in NSDictionary
/// objects, the `data` NSArray contains "unprocessed" data you will have to manage yourself. Depending of the
/// type property value, the data will contain various objects, e.g. for most stream types it will contain a
/// NSArray of NSNumber objects, for kStravaStreamTypeLatLng, a NSArray of NSArray of two
/// NSNumbers (`@[ @[lat1,lon1], @[lat2,lon2], ...]`), etc...
///
///
/// Strava API maching docs: http://strava.github.io/api/v3/streams/
///
@interface StravaStream : MTLModel<MTLJSONSerializing>

@property (nonatomic, readonly) kStravaStreamType type;
@property (nonatomic, readonly) kStravaStreamResolution resolution;
@property (nonatomic, readonly, copy) NSArray *data; /// depending of
@property (nonatomic, readonly) NSInteger originalSize;
@property (nonatomic, readonly) kStravaStreamType seriesType;
@property (nonatomic, readonly) kResourceState resourceState;

+ (NSValueTransformer *)typeJSONTransformer;

@end
