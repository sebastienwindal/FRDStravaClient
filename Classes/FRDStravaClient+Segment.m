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


-(void) fetchStarredSegmentsForCurrentUserWithSuccess:(void (^)(NSArray *segments))success
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
                            pageIndex:(NSInteger)pageIndex
{
    
}

-(void) fetchSegmentEffortsForSegment:(NSInteger)segmentId
                              athlete:(NSInteger)athleteId
                            pageIndex:(NSInteger)pageIndex
{
    
}


@end
