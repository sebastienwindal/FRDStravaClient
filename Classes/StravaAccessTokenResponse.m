//
//  StravaAccessTokenResponse.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/18/14.
//

#import "StravaAccessTokenResponse.h"

@implementation StravaAccessTokenResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"accessToken": @"access_token",
                @"athlete": @"athlete"
             };
}

+ (NSValueTransformer *)athleteJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:StravaAthlete.class];
}

@end
