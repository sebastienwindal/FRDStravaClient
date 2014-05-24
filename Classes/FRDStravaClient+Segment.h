//
//  FRDStravaClient+Segment.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/9/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "FRDStravaClient.h"
#import "StravaSegment.h"
#import "StravaSegmentEffort.h"


@interface FRDStravaClient (Segment)

-(void) fetchSegmentWithId:(NSInteger)segmentId
                   success:(void (^)(StravaSegment *segment))success
                   failure:(void (^)(NSError *error))failure;

-(void) fetchStarredSegmentsForCurrentAthleteWithSuccess:(void (^)(NSArray *segments))success
                                                 failure:(void (^)(NSError *error))failure;


-(void) fetchSegmentEffortWithId:(NSInteger)segmentEffortId
                         success:(void (^)(StravaSegmentEffort *segmentEffort))success
                         failure:(void (^)(NSError *error))failure;

-(void) fetchSegmentEffortsForSegment:(NSInteger)segmentId
                             pageSize:(NSInteger)pageSize
                            pageIndex:(NSInteger)pageIndex
                              success:(void (^)(NSArray *efforts))success
                              failure:(void (^)(NSError *error))failure;

-(void) fetchSegmentEffortsForSegment:(NSInteger)segmentId
                              athlete:(NSInteger)athleteId
                             pageSize:(NSInteger)pageSize
                            pageIndex:(NSInteger)pageIndex
                              success:(void (^)(NSArray *efforts))success
                              failure:(void (^)(NSError *error))failure;

-(void) fetchKOMsForAthlete:(NSInteger)athleteId
                   pageSize:(NSInteger)pageSize
                  pageIndex:(NSInteger)pageIndex
                    success:(void (^)(NSArray *efforts))success
                    failure:(void (^)(NSError *error))failure;


@end
