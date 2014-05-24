//
//  StravaActivity.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/18/14.
//

#import "StravaActivity.h"
#import "StravaSegmentEffort.h"
#import <MapKit/MapKit.h>

@implementation StravaActivity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"id": @"id",
             @"externalId": @"external_id",
             @"athlete": @"athlete",
             @"resourceState": @"resource_state",
             @"map": @"map",
             @"name": @"name",
             @"activityDescription": @"description",
             @"distance": @"distance",
             @"totalElevationGain": @"total_elevation_gain",
             @"movingTime": @"moving_time",
             @"elapsedTime": @"elapsed_time",
             @"type": @"type",
             @"startDate": @"start_date",
             @"startLocation": @"start_latlng",
             @"endLocation": @"end_latlng",
             @"trainer": @"trainer",
             @"private": @"private",
             @"averageSpeed":@"average_speed",
             @"maxSpeed":@"max_speed",
             @"averageCadence":@"average_cadence",
             @"averageWatts":@"average_watts",
             @"kiloJoules":@"kilojoules",
             @"averageHeartrate":@"average_heartrate",
             @"maxHeartrate":@"max_heartrate",
             @"calories":@"calories",
             @"locationCity": @"location_city",
             @"locationCountry": @"location_country",
             @"locationState": @"location_state",
             @"commute": @"commute",
             @"segmentEfforts": @"segment_efforts",
             @"gearId": @"gear_id"
             };
}


#define HANDLE_NIL_FOR_KEY(keyname,ivar,value) if ([key isEqualToString:keyname]) { ivar = value; }

-(void) setNilValueForKey:(NSString *)key
{
    HANDLE_NIL_FOR_KEY(@"externalId",       _externalId,        0);
    HANDLE_NIL_FOR_KEY(@"id",               _id,                0);
    HANDLE_NIL_FOR_KEY(@"distance",         _distance,          0);
    HANDLE_NIL_FOR_KEY(@"totalElevationGain",_totalElevationGain,0);
    HANDLE_NIL_FOR_KEY(@"movingTime",       _movingTime,        0);
    HANDLE_NIL_FOR_KEY(@"elapsedTime",      _elapsedTime,       0);
    HANDLE_NIL_FOR_KEY(@"startLocation",    _startLocation,     CLLocationCoordinate2DMake(0, 0));
    HANDLE_NIL_FOR_KEY(@"endLocation",      _endLocation,       CLLocationCoordinate2DMake(0, 0));
    HANDLE_NIL_FOR_KEY(@"trainer",          _trainer,           FALSE);
    HANDLE_NIL_FOR_KEY(@"private",          _private,           FALSE);
    HANDLE_NIL_FOR_KEY(@"averageSpeed",     _averageSpeed,      0);
    HANDLE_NIL_FOR_KEY(@"maxSpeed",         _maxSpeed,          0);
    HANDLE_NIL_FOR_KEY(@"averageCadence",   _averageCadence,    0);
    HANDLE_NIL_FOR_KEY(@"averageWatts",     _averageWatts,      0);
    HANDLE_NIL_FOR_KEY(@"kiloJoules",       _kiloJoules,        0);
    HANDLE_NIL_FOR_KEY(@"averageHeartrate", _averageHeartrate,  0);
    HANDLE_NIL_FOR_KEY(@"maxHeartrate",     _maxHeartrate,      0);
    HANDLE_NIL_FOR_KEY(@"calories",         _calories,          0);
    HANDLE_NIL_FOR_KEY(@"commute",          _commute,           FALSE);
    HANDLE_NIL_FOR_KEY(@"resourceState",    _resourceState,     kResourceStateUnknown);
}

+ (NSValueTransformer *)athleteJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:StravaAthlete.class];
}

+ (NSValueTransformer *)mapJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:StravaMap.class];
}

+ (NSValueTransformer *)typeJSONTransformer
{
    return [StravaCommon activityTypeJSONTransformer];
}

+ (NSValueTransformer *)startDateJSONTransformer
{
    return [StravaCommon dateJSONTransformer];
}

+ (NSValueTransformer *)startLocationJSONTransformer
{
    return [StravaCommon locationJSONTransformer];
}

+ (NSValueTransformer *)endLocationJSONTransformer
{
    return [StravaCommon locationJSONTransformer];
}

+ (NSValueTransformer *) segmentEffortsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:StravaSegmentEffort.class];
}

@end
