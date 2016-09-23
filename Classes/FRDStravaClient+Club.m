//
//  FRDStravaClient+Club.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/17/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "FRDStravaClient+Club.h"
#import <AFNetworking/AFNetworking.h>
#import "StravaActivity.h"
#import "StravaAthlete.h"


@interface ResponseWrapper : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSArray *activities;
@property (nonatomic, copy, readonly) NSArray *members;
@property (nonatomic, copy, readonly) NSArray *clubs;

@end

@implementation ResponseWrapper

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ @"activities": @"activities",
              @"members":@"members",
              @"clubs": @"clubs"
              };
}


+ (NSValueTransformer *)activitiesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[StravaActivity class]];
}

+ (NSValueTransformer *)membersJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[StravaAthlete class]];
}

+ (NSValueTransformer *)clubsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[StravaClub class]];
}

@end

@implementation FRDStravaClient (Club)

-(void) fetchClubsForCurrentAthleteWithSuccess:(void (^)(NSArray *clubs))success
                                       failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseURL];
    [manager GET:@"athlete/clubs"
      parameters:@{ @"access_token" : self.accessToken }
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSError *error = nil;
            
            NSDictionary *dict = @{ @"clubs": responseObject };
            
            ResponseWrapper *wrapper = [MTLJSONAdapter modelOfClass:[ResponseWrapper class]
                                                 fromJSONDictionary:dict
                                                              error:&error];
            if (error) {
                failure(error);
            } else {
                success(wrapper.clubs);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
}


-(void) fetchClubWithID:(NSInteger)clubID
                success:(void (^)(StravaClub *club))success
                failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseURL];
    [manager GET:[NSString stringWithFormat:@"clubs/%ld", (long)clubID]
      parameters:@{ @"access_token" : self.accessToken }
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSError *error = nil;
            StravaClub *club = [MTLJSONAdapter modelOfClass:[StravaClub class]
                                         fromJSONDictionary:responseObject
                                                      error:&error];
            if (error) {
                failure(error);
            } else {
                success(club);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
}


-(void) fetchMembersOfClub:(NSInteger)clubId
                  pageSize:(NSInteger)pageSize
                 pageIndex:(NSInteger)pageIndex
                   success:(void (^)(NSArray *member))success
                   failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseURL];
    [manager GET:[NSString stringWithFormat:@"clubs/%ld/members", (long)clubId]
      parameters:@{ @"access_token" : self.accessToken,
                    @"page": @(pageIndex),
                    @"per_page": @(pageSize) }
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSError *error = nil;
            NSDictionary *dict = @{ @"members": responseObject };
            
            ResponseWrapper *wrapper = [MTLJSONAdapter modelOfClass:[ResponseWrapper class]
                                                 fromJSONDictionary:dict
                                                              error:&error];
            if (error) {
                failure(error);
            } else {
                success(wrapper.members);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
}

-(void) fetchActivitiesOfClub:(NSInteger)clubId
                     pageSize:(NSInteger)pageSize
                    pageIndex:(NSInteger)pageIndex
                      success:(void (^)(NSArray *activities))success
                      failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseURL];
    [manager GET:[NSString stringWithFormat:@"clubs/%ld/activities", (long)clubId]
      parameters:@{ @"access_token" : self.accessToken,
                    @"page": @(pageIndex),
                    @"per_page": @(pageSize) }
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSError *error = nil;
            NSDictionary *dict = @{ @"activities": responseObject };
            ResponseWrapper *wrapper = [MTLJSONAdapter modelOfClass:[ResponseWrapper class]
                                                 fromJSONDictionary:dict
                                                              error:&error];
            if (error) {
                failure(error);
            } else {
                success(wrapper.activities);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
}

@end
