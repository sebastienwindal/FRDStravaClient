//
//  FRDStravaClient+Gear.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/17/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "FRDStravaClient+Gear.h"
#import <AFNetworking/AFNetworking.h>


@implementation FRDStravaClient (Gear)

-(void) fetchGearWithId:(NSString *)gearId
                success:(void (^)(StravaGear *gear))success
                failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:self.baseURL];
    
    [manager GET:[NSString stringWithFormat:@"gear/%@", gearId]
      parameters:@{ @"access_token" : self.accessToken}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSError *error = nil;
             
             StravaGear *gear = [MTLJSONAdapter modelOfClass:[StravaGear class]
                                            fromJSONDictionary:responseObject
                                                         error:&error];
             
             
             if (error) {
                 failure(error);
             } else {
                 success(gear);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure(error);
         }];

}

@end
