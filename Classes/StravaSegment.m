//
//  StravaSegment.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/8/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "StravaSegment.h"

@implementation StravaSegment

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"id": @"id",
             @"name": @"name",
             @"activityType": @"activity_type",
             @"distance": @"distance",
             @"averageGrade": @"average_grade",
             @"maximumGrade": @"maximum_grade",
             @"elevationHigh": @"elevation_high",
             @"elevationLow": @"elevation_low",
             @"startLocation": @"start_latlng",
             @"endLocation": @"end_latlng",
             @"climbCategory": @"climb_category",
             @"city": @"city",
             @"state": @"state",
             @"country": @"country",
             @"private": @"private",
             @"totalElevationGain": @"total_elevation_gain",
             @"map": @"map",
             @"effortCount": @"effort_count",
             @"athleteCount": @"athlete_count",
             @"hazardous": @"hazardous",
             @"prEfforId": @"pr_effort_id",
             @"prTime": @"pr_time",
             @"prDistance": @"pr_distance",
             @"starred": @"starred",
             @"resourceState":@"resource_state"
             };
}

#define HANDLE_NIL_FOR_KEY(keyname,ivar,value) if ([key isEqualToString:keyname]) { ivar = value; }

-(void) setNilValueForKey:(NSString *)key
{
    HANDLE_NIL_FOR_KEY(@"id",                   _id,                    0);
    HANDLE_NIL_FOR_KEY(@"activityType",         _activityType,          kActivityTypeUnknown);
    HANDLE_NIL_FOR_KEY(@"distance",             _distance,              0);
    HANDLE_NIL_FOR_KEY(@"averageGrade",         _averageGrade,          0);
    HANDLE_NIL_FOR_KEY(@"maximumGrade",         _maximumGrade,          0);
    HANDLE_NIL_FOR_KEY(@"elevationHigh",        _elevationHigh,         0);
    HANDLE_NIL_FOR_KEY(@"elevationLow",         _elevationLow,          0);
    HANDLE_NIL_FOR_KEY(@"startLocation",        _startLocation,         CLLocationCoordinate2DMake(0, 0));
    HANDLE_NIL_FOR_KEY(@"endLocation",          _endLocation,           CLLocationCoordinate2DMake(0, 0));
    HANDLE_NIL_FOR_KEY(@"climbCategory",        _climbCategory,         0);
    HANDLE_NIL_FOR_KEY(@"private",              _private,               FALSE);
    HANDLE_NIL_FOR_KEY(@"totalElevationGain",   _totalElevationGain,    0);
    HANDLE_NIL_FOR_KEY(@"effortCount",          _effortCount,           0);
    HANDLE_NIL_FOR_KEY(@"athleteCount",         _athleteCount,          0);
    HANDLE_NIL_FOR_KEY(@"prEfforId",            _prEfforId,             FALSE);
    HANDLE_NIL_FOR_KEY(@"prTime",               _prTime,                0);
    HANDLE_NIL_FOR_KEY(@"prDistance",           _prDistance,            0);
    HANDLE_NIL_FOR_KEY(@"starred",              _starred,               FALSE);
    HANDLE_NIL_FOR_KEY(@"ResourceState",        _resourceState,         kResourceStateUnknown);
}

+ (NSValueTransformer *)activityTypeJSONTransformer
{
    return [StravaCommon activityTypeJSONTransformer];
}

+ (NSValueTransformer *) startLocationJSONTransformer
{
    return [StravaCommon locationJSONTransformer];
}

+ (NSValueTransformer *) endLocationJSONTransformer
{
    return [StravaCommon locationJSONTransformer];
}

+ (NSValueTransformer *)mapJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:StravaMap.class];
}



@end
