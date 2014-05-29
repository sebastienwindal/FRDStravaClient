//
//  StravaActivityZone.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/24/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "StravaActivityZone.h"

#define HANDLE_NIL_FOR_KEY(keyname,ivar,value) if ([key isEqualToString:keyname]) { ivar = value; }


@implementation StravaActivityZoneDistributionBucket


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"min": @"min",
             @"max": @"max",
             @"time": @"time"
             };
}

-(void) setNilValueForKey:(NSString *)key
{
    HANDLE_NIL_FOR_KEY(@"min",  _min,   0);
    HANDLE_NIL_FOR_KEY(@"max",  _max,   0);
    HANDLE_NIL_FOR_KEY(@"time", _time,  0);
}

@end


@implementation StravaActivityZone

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"resourceState": @"resource_state",
             @"sensorBased": @"sensor_based",
             @"type": @"type",
             @"points": @"points",
             @"customZones": @"custom_zones",
             @"max": @"max",
             @"bikeWeight": @"bike_weight",
             @"athleteWeight": @"athlete_weight",
             @"distributionBuckets": @"distribution_buckets"
             };
}

-(void) setNilValueForKey:(NSString *)key
{
    HANDLE_NIL_FOR_KEY(@"resourceState",    _resourceState, kResourceStateUnknown);
    HANDLE_NIL_FOR_KEY(@"sensorBased",      _sensorBased,   FALSE);
    HANDLE_NIL_FOR_KEY(@"type",             _type,          kActivityZoneTypeUnknown);
    HANDLE_NIL_FOR_KEY(@"points",           _points,        0);
    HANDLE_NIL_FOR_KEY(@"customZones",      _customZones,   FALSE);
    HANDLE_NIL_FOR_KEY(@"max",              _max,           0);
    HANDLE_NIL_FOR_KEY(@"bikeWeight",       _bikeWeight,    0);
    HANDLE_NIL_FOR_KEY(@"athleteWeight",    _athleteWeight, 0);
}

+ (NSValueTransformer *) distributionBucketsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:StravaActivityZoneDistributionBucket.class];
}


+ (NSValueTransformer *)typeJSONTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"heartrate": @(kActivityZoneTypeHeartRate),
                                                                           @"power": @(kActivityZoneTypePower)\
                                                                           }
                                                            defaultValue:@(kActivityZoneTypeUnknown)
                                                     reverseDefaultValue:@"unknown"];
}


@end
