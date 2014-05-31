//
//  StravaActivityZone.h
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/24/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "StravaCommon.h"

typedef NS_ENUM(NSInteger, kActivityZoneType) {
    kActivityZoneTypeUnknown,
    kActivityZoneTypeHeartRate,
    kActivityZoneTypePower
};

///
/// Zone distribution bucket (heart rate zone or power distribution
/// repartition slice e.g. 100-120Watts, 120-140watts, etc...).
///
/// Strava API maching docs: http://strava.github.io/api/v3/activities/#zones
///
/// @see StravaActivityZone
///
@interface StravaActivityZoneDistributionBucket : MTLModel<MTLJSONSerializing>

@property (nonatomic, readonly) CGFloat min;
@property (nonatomic, readonly) CGFloat max;
@property (nonatomic, readonly) NSTimeInterval time;

@end

///
/// Activity Zone object.
///
/// Strava API maching docs: http://strava.github.io/api/v3/activities/#zones
///
/// @see StravaActivityZoneDistributionBucket
///
@interface StravaActivityZone : MTLModel<MTLJSONSerializing>

@property (nonatomic, readonly) kActivityZoneType type;
@property (nonatomic, readonly) kResourceState resourceState;
@property (nonatomic, readonly) BOOL sensorBased;
@property (nonatomic, readonly) CGFloat points;
@property (nonatomic, readonly) BOOL customZones;
@property (nonatomic, readonly) CGFloat max;
@property (nonatomic, readonly) CGFloat bikeWeight;
@property (nonatomic, readonly) CGFloat athleteWeight;
@property (nonatomic, readonly, copy) NSArray *distributionBuckets; /// NSArray of StravaActivityZoneDistributionBucket objects

@end
