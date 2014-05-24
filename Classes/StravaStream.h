//
//  StravaStream.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/3/14.
//

#import <Mantle/Mantle.h>
#import "StravaCommon.h"

typedef NS_ENUM(NSInteger, kStravaStreamResolution) {
    kStravaStreamResolutionUnknown,
    kStravaStreamResolutionLow,
    kStravaStreamResolutionMedium,
    kStravaStreamResolutionHigh
};


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


@interface StravaStream : MTLModel<MTLJSONSerializing>

@property (nonatomic, readonly) kStravaStreamType type;
@property (nonatomic, readonly) kStravaStreamResolution resolution;
@property (nonatomic, readonly, copy) NSArray *data;
@property (nonatomic, readonly) NSInteger originalSize;
@property (nonatomic, readonly) kStravaStreamType seriesType;
@property (nonatomic, readonly) kResourceState resourceState;

+ (NSValueTransformer *)typeJSONTransformer;

@end
