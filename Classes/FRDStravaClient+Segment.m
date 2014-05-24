//
//  FRDStravaClient+Segment.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/9/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "FRDStravaClient+Segment.h"
#import <AFNetworking/AFNetworking.h>
#import <Mantle/Mantle.h>

@interface StravaSegmentArrayWrapper : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSArray *segments;

@end


@implementation StravaSegmentArrayWrapper

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ @"segments": @"segments" };
}

+ (NSValueTransformer *)segmentsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[StravaSegment class]];
}

@end

@interface EffortArrayResponse : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSArray *efforts;

@end

@implementation EffortArrayResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ @"efforts": @"efforts" };
}

+ (NSValueTransformer *)effortsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[StravaSegmentEffort class]];
}

@end

@implementation FRDStravaClient (Segment)

-(void) fetchSegmentWithId:(NSInteger)segmentId
                   success:(void (^)(StravaSegment *segment))success
                   failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:self.baseURL];
    
    NSString *url = [NSString stringWithFormat:@"segments/%ld", (long)segmentId];
    
    [manager GET:url
      parameters:@{ @"access_token" : self.accessToken }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSError *error = nil;
             
             StravaSegment *segment = [MTLJSONAdapter modelOfClass:[StravaSegment class]
                                                fromJSONDictionary:responseObject
                                                             error:&error];
             
             if (error) {
                 failure(error);
             } else {
                 success(segment);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure(error);
         }];
}


-(void) fetchStarredSegmentsForCurrentAthleteWithSuccess:(void (^)(NSArray *segments))success
                                              failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:self.baseURL];
    
    [manager GET:@"segments/starred"
      parameters:@{ @"access_token" : self.accessToken }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSError *error = nil;
             
             NSDictionary *wrapper = @{ @"segments": responseObject };
             
             StravaSegmentArrayWrapper *result = [MTLJSONAdapter modelOfClass:[StravaSegmentArrayWrapper class]
                                                           fromJSONDictionary:wrapper
                                                                        error:&error];
             
             if (error) {
                 failure(error);
             } else {
                 success(result.segments);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure(error);
         }];
}

-(void) fetchSegmentEffortWithId:(NSInteger)segmentEffortId
                         success:(void (^)(StravaSegmentEffort *segmentEffort))success
                         failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:self.baseURL];
    
    NSString *url = [NSString stringWithFormat:@"segment_efforts/%ld", (long)segmentEffortId];
    
    [manager GET:url
      parameters:@{ @"access_token" : self.accessToken }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSError *error = nil;
             
             StravaSegmentEffort *segmentEffort = [MTLJSONAdapter modelOfClass:[StravaSegmentEffort class]
                                                            fromJSONDictionary:responseObject
                                                                         error:&error];
             
             if (error) {
                 failure(error);
             } else {
                 success(segmentEffort);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure(error);
         }];
    
}

-(void) fetchSegmentEffortsForSegment:(NSInteger)segmentId
                             pageSize:(NSInteger)pageSize
                            pageIndex:(NSInteger)pageIndex
                              success:(void (^)(NSArray *efforts))success
                              failure:(void (^)(NSError *error))failure
{
    [self fetchSegmentEffortsForSegment:segmentId
                         withParameters:@{  @"page":@(pageIndex),
                                            @"per_page":@(pageSize) }
                                success:success
                                failure:failure];
}

-(void) fetchSegmentEffortsForSegment:(NSInteger)segmentId
                              athlete:(NSInteger)athleteId
                             pageSize:(NSInteger)pageSize
                            pageIndex:(NSInteger)pageIndex
                              success:(void (^)(NSArray *efforts))success
                              failure:(void (^)(NSError *error))failure
{
    [self fetchSegmentEffortsForSegment:segmentId
                         withParameters:@{  @"athlete_id": @(athleteId),
                                            @"page":@(pageIndex),
                                            @"per_page":@(pageSize) }
                                success:success
                                failure:failure];
}


-(void) fetchSegmentEffortsForSegment:(NSInteger)segmentId
                       withParameters:(NSDictionary *)params
                              success:(void (^)(NSArray *efforts))success
                              failure:(void (^)(NSError *error))failure
{
    if (params == nil) {
        params = @{};
    }
    
    // add the access token to the provided params dictionary.
    NSMutableDictionary *mutableParams = [params mutableCopy];
    
    [mutableParams addEntriesFromDictionary:@{ @"access_token" : self.accessToken }];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:self.baseURL];
    
    NSString *url = [NSString stringWithFormat:@"segments/%ld/all_efforts", (long)segmentId];
    
    [manager GET:url
      parameters:mutableParams
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSError *error = nil;
             
             NSDictionary *wrapper = @{ @"efforts": responseObject };
             
             EffortArrayResponse *response = [MTLJSONAdapter modelOfClass:[EffortArrayResponse class]
                                                       fromJSONDictionary:wrapper
                                                                    error:&error];
             
             if (error) {
                 failure(error);
             } else {
                 NSArray *arr = response.efforts;
                 success(arr);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure(error);
         }];

}

-(void) fetchKOMsForAthlete:(NSInteger)athleteId
                   pageSize:(NSInteger)pageSize
                  pageIndex:(NSInteger)pageIndex
                    success:(void (^)(NSArray *efforts))success
                    failure:(void (^)(NSError *error))failure
{
    NSDictionary *params = @{ @"access_token" : self.accessToken,
                              @"page":@(pageIndex),
                              @"per_page":@(pageSize) };
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:self.baseURL];
    
    NSString *url = [NSString stringWithFormat:@"athletes/%ld/koms", (long)athleteId];
    
    [manager GET:url
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSError *error = nil;
             
             NSDictionary *wrapper = @{ @"efforts": responseObject };
             
             EffortArrayResponse *response = [MTLJSONAdapter modelOfClass:[EffortArrayResponse class]
                                                       fromJSONDictionary:wrapper
                                                                    error:&error];
             
             if (error) {
                 failure(error);
             } else {
                 NSArray *arr = response.efforts;
                 success(arr);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure(error);
         }];

}

@end
