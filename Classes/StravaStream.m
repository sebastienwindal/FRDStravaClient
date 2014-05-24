//
//  StravaStream.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/3/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "StravaStream.h"

@implementation StravaStream

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"type": @"type",
             @"data": @"data",
             @"seriesType": @"series_type",
             @"resolution": @"resolution",
             @"originalSize": @"original_size",
             @"resourceState": @"resource_state"
             };
}

#define HANDLE_NIL_FOR_KEY(keyname,ivar,value) if ([key isEqualToString:keyname]) { ivar = value; }

-(void) setNilValueForKey:(NSString *)key
{
    HANDLE_NIL_FOR_KEY(@"type",             _type,              kStravaStreamTypeUnknown);
    HANDLE_NIL_FOR_KEY(@"seriesType",       _seriesType,        kStravaStreamTypeUnknown);
    HANDLE_NIL_FOR_KEY(@"resolution",       _resolution,        kStravaStreamResolutionUnknown);
    HANDLE_NIL_FOR_KEY(@"originalSize",     _originalSize,      0);
    HANDLE_NIL_FOR_KEY(@"resourceState",    _resourceState,     kResourceStateUnknown);
    
}



+ (NSValueTransformer *)typeJSONTransformer
{
    NSDictionary *mapping = @{ @"altitude": @(kStravaStreamTypeAltitude),
                               @"cadence": @(kStravaStreamTypeCadence),
                               @"distance": @(kStravaStreamTypeDistance),
                               @"grade_smooth": @(kStravaStreamTypeGradesmooth),
                               @"heartrate": @(kStravaStreamTypeHeartrate),
                               @"latlng": @(kStravaStreamTypeLatLng),
                               @"moving": @(kStravaStreamTypeMoving),
                               @"tmperature": @(kStravaStreamTypeTemperature),
                               @"time": @(kStravaStreamTypeTime),
                               @"velocity_smooth": @(kStravaStreamTypeVelocitySmooth),
                               @"watts": @(kStravaStreamTypeWatts),
                               };
    
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:mapping
                                                            defaultValue:@(kStravaStreamTypeUnknown)
                                                     reverseDefaultValue:@"unknown"];
}

+ (NSValueTransformer *)seriesTypeJSONTransformer
{
    return [self typeJSONTransformer];
}

+ (NSValueTransformer *)resolutionJSONTransformer
{
    NSDictionary *mapping = @{ @"low": @(kStravaStreamResolutionLow),
                               @"medium": @(kStravaStreamResolutionMedium),
                               @"high": @(kStravaStreamResolutionHigh)
                               };
    
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:mapping
                                                            defaultValue:@(kStravaStreamResolutionUnknown)
                                                     reverseDefaultValue:@"unknown"];
}

@end
