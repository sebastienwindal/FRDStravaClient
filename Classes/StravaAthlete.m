//
//  StravaAthlete.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/18/14.
//

#import "StravaAthlete.h"

@implementation StravaAthlete

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"id": @"id",
             @"firstName": @"firstname",
             @"lastName": @"lastname",
             @"profileMediumURL": @"profile_medium",
             @"profileLargeURL": @"profile",
             @"country": @"country",
             @"state":@"state",
             @"city":@"city",
             @"sex":@"sex",
             @"resourceState": @"resource_state"
             };
}


+ (NSValueTransformer *)sexJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"F": @(kAthleteGenderFemale),
                                                                           @"M": @(kAthleteGenderMale)
                                                                           }
                                                            defaultValue:@(kAthleteGenderMale)
                                                     reverseDefaultValue:@"M"];
}


#define HANDLE_NIL_FOR_KEY(keyname,ivar,value) if ([key isEqualToString:keyname]) { ivar = value; }

-(void) setNilValueForKey:(NSString *)key
{
    HANDLE_NIL_FOR_KEY(@"id",               _id,            0);
    HANDLE_NIL_FOR_KEY(@"sex",              _sex,           kAthleteGenderMale);
    HANDLE_NIL_FOR_KEY(@"resourceState",    _resourceState, kResourceStateUnknown);
    
}

@end
