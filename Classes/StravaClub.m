//
//  StravaClub.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/17/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "StravaClub.h"

@implementation StravaClub


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"id": @"id",
             @"name": @"name",
             @"profileMedium": @"profile_medium",
             @"profile": @"profile",
             @"clubDescription": @"description",
             @"clubType": @"club_type",
             @"sportType":@"sport_type",
             @"city":@"city",
             @"state":@"state",
             @"country":@"country",
             @"private":@"private",
             @"memberCount":@"member_count",
             @"resourceState":@"resource_state"
             };
}


+ (NSValueTransformer *)clubTypeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"casual_club": @(kStravaClubTypeCasualClub),
                                                                           @"racing_team": @(kStravaClubTypesRacingTeam),
                                                                           @"shop": @(kStravaClubTypesShop),
                                                                           @"company": @(kStravaClubTypesCompany),
                                                                           @"other": @(kStravaClubTypesOther)
                                                                           }
                                                            defaultValue:@(kStravaClubTypesUnknown)
                                                     reverseDefaultValue:@"unknown"];
}

+ (NSValueTransformer *)sportTypeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"cycling": @(kStravaSportTypesCycling),
                                                                           @"running": @(kStravaSportTypesRunning),
                                                                           @"triathlon": @(kStravaSportTypesTriathlon),
                                                                           @"other": @(kStravaSportTypesOther)
                                                                           }
                                                            defaultValue:@(kStravaSportTypesUnknown)
                                                     reverseDefaultValue:@"unknown"];
}

#define HANDLE_NIL_FOR_KEY(keyname,ivar,value) if ([key isEqualToString:keyname]) { ivar = value; }

-(void) setNilValueForKey:(NSString *)key
{
    HANDLE_NIL_FOR_KEY(@"id",           _id,            0);
    HANDLE_NIL_FOR_KEY(@"clubType",     _clubType,      kStravaClubTypesUnknown);
    HANDLE_NIL_FOR_KEY(@"sportType",    _sportType,     kStravaSportTypesUnknown);
    HANDLE_NIL_FOR_KEY(@"memberCount",  _memberCount,   0);
    HANDLE_NIL_FOR_KEY(@"resourceState",_resourceState, kResourceStateUnknown);
}





@end
