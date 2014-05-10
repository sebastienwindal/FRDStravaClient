//
//  StravaActivityUploadStatus.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/27/14.
//

#import "StravaActivityUploadStatus.h"

@implementation StravaActivityUploadStatus


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"id": @"id",
             @"externalId": @"external_id",
             @"error": @"error",
             @"status": @"status",
             @"activityId": @"activity_id"
             };
}

#define HANDLE_NIL_FOR_KEY(keyname,ivar,value) if ([key isEqualToString:keyname]) { ivar = value; }

-(void) setNilValueForKey:(NSString *)key
{
    HANDLE_NIL_FOR_KEY(@"id",               _id,                0);
    HANDLE_NIL_FOR_KEY(@"activityId",       _activityId,        0);
}
    
@end
