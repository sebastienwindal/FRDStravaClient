//
//  StravaActivityLap.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/24/14.
//

#import "StravaActivityLap.h"
#import "StravaCommon.h"

@implementation StravaActivityLap

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"id": @"id",
             @"name": @"name",
             @"activityId": @"activity.id",
             @"athleteId": @"athlete.id",
             @"movingTime": @"moving_time",
             @"elapsedTime": @"elapsed_time",
             @"startDate": @"start_date",
             @"distance": @"distance",
             @"lapIndex": @"lap_index",
             @"averageSpeed": @"average_speed",
             @"maxSpeed":@"max_speed",
             @"averageCadence": @"average_cadence",
             @"averageWatts": @"average_watts",
             @"kiloJoules": @"kilojoules",
             @"averageHeartrate": @"average_heartrate",
             @"maxHeartrate": @"max_heartrate",
             @"resourceState": @"resource_state"
             };
}

#define HANDLE_NIL_FOR_KEY(keyname,ivar,value) if ([key isEqualToString:keyname]) { ivar = value; }

-(void) setNilValueForKey:(NSString *)key
{
    HANDLE_NIL_FOR_KEY(@"id",               _id,                0);
    HANDLE_NIL_FOR_KEY(@"activityId",       _activityId,        0);
    HANDLE_NIL_FOR_KEY(@"athleteId",        _athleteId,         0);
    HANDLE_NIL_FOR_KEY(@"movingTime",       _movingTime,        0);
    HANDLE_NIL_FOR_KEY(@"elapsedTime",      _elapsedTime,       0);
    HANDLE_NIL_FOR_KEY(@"distance",         _distance,          0);
    HANDLE_NIL_FOR_KEY(@"lapIndex",         _lapIndex,          0);
    HANDLE_NIL_FOR_KEY(@"averageSpeed",     _averageSpeed,      0);
    HANDLE_NIL_FOR_KEY(@"maxSpeed",         _maxSpeed,          0);
    HANDLE_NIL_FOR_KEY(@"averageCadence",   _averageCadence,    0);
    HANDLE_NIL_FOR_KEY(@"averageWatts",     _averageWatts,      0);
    HANDLE_NIL_FOR_KEY(@"kiloJoules",       _kiloJoules,        0);
    HANDLE_NIL_FOR_KEY(@"averageHeartrate", _averageHeartrate,  0);
    HANDLE_NIL_FOR_KEY(@"maxHeartrate",     _maxHeartrate,      0);
    HANDLE_NIL_FOR_KEY(@"resourceState",    _resourceState,     kResourceStateUnknown);
}

+ (NSValueTransformer *)startDateJSONTransformer {
    return [StravaCommon dateJSONTransformer];
}


@end
