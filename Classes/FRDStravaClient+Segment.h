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
 
 @param segmentId segment identifier
 @param success Success callback
 @param failure Failure callback
 */
-(void) fetchSegmentWithId:(NSInteger)segmentId
                   success:(void (^)(StravaSegment *segment))success
                   failure:(void (^)(NSError *error))failure;

/**
 Fetch segments the current logged-in user has flagged.
 
 Strava API related documentation: http://strava.github.io/api/v3/segments/#starred
 
 @param success Success callback, segments is a NSArray of StravaSegment objects.
 @param failure Failure callback
 */
-(void) fetchStarredSegmentsForCurrentAthleteWithSuccess:(void (^)(NSArray *segments))success
                                                 failure:(void (^)(NSError *error))failure;

/**
 Fetch a detailed segment effort by Id
 
 Strava API related documentation: http://strava.github.io/api/v3/efforts/#retrieve
 
 @param segmentEffortId segment effort Id
 @param success Success callback
 @param failure Failure callback
 */
-(void) fetchSegmentEffortWithId:(NSInteger)segmentEffortId
                         success:(void (^)(StravaSegmentEffort *segmentEffort))success
                         failure:(void (^)(NSError *error))failure;




/**
 Fetch segments efforts for specified segment. Paged request.
 
 Strava API related documentation: http://strava.github.io/api/v3/segments/#efforts
 
 @param segmentId segment ID
 @param pageSize number of efforts per page
 @param pageIndex page index, first page index is 1
 @param success Success callback, segments is a NSArray of StravaSegmentEffort objects.
 @param failure Failure callback
 */
-(void) fetchSegmentEffortsForSegment:(NSInteger)segmentId
                             pageSize:(NSInteger)pageSize
                            pageIndex:(NSInteger)pageIndex
                              success:(void (^)(NSArray *efforts))success
                              failure:(void (^)(NSError *error))failure;
/**
 Fetch segments efforts for the specified segment by specified athlete. Paged request.
 
 Strava API related documentation: http://strava.github.io/api/v3/segments/#efforts
 
 @param segmentId segment ID
 @param athleteId athlete ID
 @param pageSize number of efforts per page
 @param pageIndex page index, first page index is 1
 @param success Success callback, segments is a NSArray of StravaSegmentEffort objects.
 @param failure Failure callback
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
 
 @param athleteId athlete ID
 @param pageSize number of efforts per page
 @param pageIndex page index, first page index is 1
 @param success Success callback, efforts is a NSArray of StravaSegmentEffort objects.
 @param failure Failure callback
 */
-(void) fetchKOMsForAthlete:(NSInteger)athleteId
                   pageSize:(NSInteger)pageSize
                  pageIndex:(NSInteger)pageIndex
                    success:(void (^)(NSArray *efforts))success
                    failure:(void (^)(NSError *error))failure;


@end
