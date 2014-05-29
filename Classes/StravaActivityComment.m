//
//  StravaActivityComment.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/28/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "StravaActivityComment.h"

@implementation StravaActivityComment


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"id": @"id",
             @"activityId":@"activity_id",
             @"resourceState":@"resource_state",
             @"text":@"text",
             @"athlete":@"athlete",
             @"createdAt":@"created_at"
             };
}

#define HANDLE_NIL_FOR_KEY(keyname,ivar,value) if ([key isEqualToString:keyname]) { ivar = value; }

-(void) setNilValueForKey:(NSString *)key
{
    HANDLE_NIL_FOR_KEY(@"id",               _id,            0);
    HANDLE_NIL_FOR_KEY(@"activityId",       _activityId,    0);
    HANDLE_NIL_FOR_KEY(@"resourceState",    _resourceState, kResourceStateUnknown);
}

+ (NSValueTransformer *)createdAtJSONTransformer
{
    return [StravaCommon dateJSONTransformer];
}

+ (NSValueTransformer *)athleteJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:StravaAthlete.class];
}


@end
