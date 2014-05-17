//
//  StravaGear.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/17/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "StravaGear.h"

@implementation StravaGear

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"id": @"id",
             @"primary": @"primary",
             @"name": @"name",
             @"distance": @"distance",
             @"brandName": @"brand_name",
             @"modelName": @"model_name",
             @"frameType": @"frame_type",
             @"gearDescription": @"description",
             };
}


#define HANDLE_NIL_FOR_KEY(keyname,ivar,value) if ([key isEqualToString:keyname]) { ivar = value; }

-(void) setNilValueForKey:(NSString *)key
{
    HANDLE_NIL_FOR_KEY(@"primary",          _primary,        FALSE);
    HANDLE_NIL_FOR_KEY(@"distance",         _distance,       0.0f);
    HANDLE_NIL_FOR_KEY(@"frameType",        _frameType,      kGearFrameTypeUnknown);
}


@end
