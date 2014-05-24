//
//  StravaSegmentEffort.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/9/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "StravaSegmentEffort.h"
#import "StravaCommon.h"


@implementation StravaSegmentEffort

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"id": @"id",
             @"name": @"name",
             @"segment": @"segment",
             @"activityId": @"activity.id",
             @"athleteId": @"athlete.id",
             @"komRank": @"kom_rank",
             @"prRank": @"pr_rank",
             @"elapsedTime": @"elapsed_time",
             @"movingTime": @"moving_time",
             @"startDate": @"start_date",
             @"distance": @"start_date_local",
             @"startIndex": @"start_index",
             @"endIndex": @"end_index",
             @"hidden": @"hidden",
             @"resourceState": @"resource_state"
             };
}

#define HANDLE_NIL_FOR_KEY(keyname,ivar,value) if ([key isEqualToString:keyname]) { ivar = value; }

-(void) setNilValueForKey:(NSString *)key
{
    HANDLE_NIL_FOR_KEY(@"id",                   _id,                    0);
    HANDLE_NIL_FOR_KEY(@"activityId",           _activityId,            0);
    HANDLE_NIL_FOR_KEY(@"athleteId",            _athleteId,             0);
    HANDLE_NIL_FOR_KEY(@"komRank",              _komRank,               0);
    HANDLE_NIL_FOR_KEY(@"prRank",               _prRank,                0);
    HANDLE_NIL_FOR_KEY(@"elapsedTime",          _elapsedTime,           0.0);
    HANDLE_NIL_FOR_KEY(@"movingTime",           _movingTime,            0.0);
    HANDLE_NIL_FOR_KEY(@"distance",             _distance,              0.0f);
    HANDLE_NIL_FOR_KEY(@"startIndex",           _startIndex,            0);
    HANDLE_NIL_FOR_KEY(@"endIndex",             _endIndex,              0);
    HANDLE_NIL_FOR_KEY(@"hidden",               _hidden,                FALSE);
    HANDLE_NIL_FOR_KEY(@"resourceState",        _resourceState,         kResourceStateUnknown);
}

+ (NSValueTransformer *) startDateJSONValueTransformer
{
    return [StravaCommon dateJSONTransformer];
}

+ (NSValueTransformer *) segmentJSONValueTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:StravaSegment.class];
}


@end
