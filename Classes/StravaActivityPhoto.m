//
//  StravaActivityPhoeo.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/24/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "StravaActivityPhoto.h"

@implementation StravaActivityPhoto

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"id": @"id",
             @"activityId":@"activity_id",
             @"resourceState":@"resource_state",
             @"ref":@"ref",
             @"uid":@"uid",
             @"caption":@"caption",
             @"type":@"type",
             @"uploadedAt":@"uploaded_at",
             @"createdAt":@"created_at",
             @"location":@"location"
             };
}

#define HANDLE_NIL_FOR_KEY(keyname,ivar,value) if ([key isEqualToString:keyname]) { ivar = value; }

-(void) setNilValueForKey:(NSString *)key
{
    HANDLE_NIL_FOR_KEY(@"id",               _id,            0);
    HANDLE_NIL_FOR_KEY(@"activityId",       _activityId,    0);
    HANDLE_NIL_FOR_KEY(@"resourceState",    _resourceState, kResourceStateUnknown);
    HANDLE_NIL_FOR_KEY(@"location",         _location,      CLLocationCoordinate2DMake(0, 0));
}

+ (NSValueTransformer *)createdAtJSONTransformer
{
    return [StravaCommon dateJSONTransformer];
}

+ (NSValueTransformer *)uploadedAtJSONTransformer
{
    return [StravaCommon dateJSONTransformer];
}

+ (NSValueTransformer *)locationJSONTransformer
{
    return [StravaCommon locationJSONTransformer];
}



@end
