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


@interface StravaActivityZoneDistributionBucket : MTLModel<MTLJSONSerializing>

@property (nonatomic, readonly) CGFloat min;
@property (nonatomic, readonly) CGFloat max;
@property (nonatomic, readonly) NSTimeInterval time;

@end

@interface StravaActivityZone : MTLModel<MTLJSONSerializing>

@property (nonatomic, readonly) kActivityZoneType type;
@property (nonatomic, readonly) kResourceState resourceState;
@property (nonatomic, readonly) BOOL sensorBased;
@property (nonatomic, readonly) CGFloat points;
@property (nonatomic, readonly) BOOL customZones;
@property (nonatomic, readonly) CGFloat max;
@property (nonatomic, readonly) CGFloat bikeWeight;
@property (nonatomic, readonly) CGFloat athleteWeight;
@property (nonatomic, readonly, copy) NSArray *distributionBuckets; // array of StravaActivityZoneDistributionBucket

@end
