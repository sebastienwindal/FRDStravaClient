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
/**
 Fetch detailed segment.
 
 Strava API related documentation: http://strava.github.io/api/v3/segments/#retrieve
 
 @params segmentId segment identifier
 @params success Success callback
 @params failure Failure callback
 */
-(void) fetchSegmentWithId:(NSInteger)segmentId
                   success:(void (^)(StravaSegment *segment))success
                   failure:(void (^)(NSError *error))failure;

/**
 Fetch segments the current logged-in user has flagged.
 
 Strava API related documentation: http://strava.github.io/api/v3/segments/#starred
 
 @params success Success callback, segments is a NSArray of StravaSegment objects.
 @params failure Failure callback
 */
-(void) fetchStarredSegmentsForCurrentAthleteWithSuccess:(void (^)(NSArray *segments))success
                                                 failure:(void (^)(NSError *error))failure;

/**
 Fetch a detailed segment effort by Id
 
 Strava API related documentation: http://strava.github.io/api/v3/efforts/#retrieve
 
 @params segmentEffortId segment effort Id
 @params success Success callback
 @params failure Failure callback
 */
-(void) fetchSegmentEffortWithId:(NSInteger)segmentEffortId
                         success:(void (^)(StravaSegmentEffort *segmentEffort))success
                         failure:(void (^)(NSError *error))failure;




/**
 Fetch segments efforts for specified segment. Paged request.
 
 Strava API related documentation: http://strava.github.io/api/v3/segments/#efforts
 
 @params segmentId segment ID
 @params pageSize number of efforts per page
 @params pageIndex page index, first page index is 1
 @params success Success callback, segments is a NSArray of StravaSegmentEffort objects.
 @params failure Failure callback
 */
-(void) fetchSegmentEffortsForSegment:(NSInteger)segmentId
                             pageSize:(NSInteger)pageSize
                            pageIndex:(NSInteger)pageIndex
                              success:(void (^)(NSArray *efforts))success
                              failure:(void (^)(NSError *error))failure;
/**
 Fetch segments efforts for the specified segment by specified athlete. Paged request.
 
 Strava API related documentation: http://strava.github.io/api/v3/segments/#efforts
 
 @params segmentId segment ID
 @params athleteId athlete ID
 @params pageSize number of efforts per page
 @params pageIndex page index, first page index is 1
 @params success Success callback, segments is a NSArray of StravaSegmentEffort objects.
 @params failure Failure callback
 */
-(void) fetchSegmentEffortsForSegment:(NSInteger)segmentId
                              athlete:(NSInteger)athleteId
                             pageSize:(NSInteger)pageSize
                            pageIndex:(NSInteger)pageIndex
                              success:(void (^)(NSArray *efforts))success
                              failure:(void (^)(NSError *error))failure;

/**
 Returns an array of segment efforts representing KOMs/QOMs and course records held by the given athlete. Paged request.
 
 Strava API related documentation: http://strava.github.io/api/v3/athlete/#koms
 
 @params athleteId athlete ID
 @params pageSize number of efforts per page
 @params pageIndex page index, first page index is 1
 @params success Success callback, efforts is a NSArray of StravaSegmentEffort objects.
 @params failure Failure callback
 */
-(void) fetchKOMsForAthlete:(NSInteger)athleteId
                   pageSize:(NSInteger)pageSize
                  pageIndex:(NSInteger)pageIndex
                    success:(void (^)(NSArray *efforts))success
                    failure:(void (^)(NSError *error))failure;


@end
