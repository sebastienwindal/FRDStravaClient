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
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseURL];
    [manager GET:[NSString stringWithFormat:@"gear/%@", gearId] parameters:@{ @"access_token" : self.accessToken} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error = nil;
        StravaGear *gear = [MTLJSONAdapter modelOfClass:[StravaGear class]
                                     fromJSONDictionary:responseObject
                                                  error:&error];
        if (error) {
            failure(error);
        } else {
            success(gear);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
