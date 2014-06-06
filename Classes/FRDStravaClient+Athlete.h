//
//  FRDStravaClient+Athlete.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/21/14.
//

#import "FRDStravaClient.h"
#import "StravaAthlete.h"

@interface FRDStravaClient (Athlete)

/**
 Fetch athlete summary information by Id.
 
 Strava API related documentation: http://strava.github.io/api/v3/athlete/#get-another-details
 
 @param athleteId the ID of the athlete
 @param success Success callback
 @param failure Failure callback
 */
-(void) fetchAthleteWithId:(NSInteger)athleteId
                   success:(void (^)(StravaAthlete *athlete))success
                   failure:(void (^)(NSError *error))failure;

/**
 Fetch current athlete detailed information.
 
 Strava API related documentation: http://strava.github.io/api/v3/athlete/#get-details
 
 @param success Success callback
 @param failure Failure callback
 */
-(void) fetchCurrentAthleteWithSuccess:(void (^)(StravaAthlete *athlete))success
                              failure:(void (^)(NSError *error))failure;

/**
 Fetch followers of the current athlete, paged.
 
 Strava API related documentation: http://strava.github.io/api/v3/follow/#followers
 
 @param pageSize number of athletes per page
 @param pageIndex index of page to fetch, first page index is 1.
 @param success Success callback, athletes is a NSArray of StravaAthlete objects.
 @param failure Failure callback
 */
-(void) fetchCurrentAthleteFollowersWithPageSize:(NSInteger)pageSize
                                       pageIndex:(NSInteger)pageIndex
                                         success:(void (^)(NSArray *athletes))success
                                         failure:(void (^)(NSError *error))failure;

/**
 Fetch current athlete friends, paged.
 
 Strava API related documentation: http://strava.github.io/api/v3/follow/#friends
 
 @param pageSize number of athletes per page
 @param pageIndex index of page to fetch, first page index is 1.
 @param success Success callback, athletes is a NSArray of StravaAthlete objects.
 @param failure Failure callback
 */
-(void) fetchCurrentAthleteFriendsWithPageSize:(NSInteger)pageSize
                                     pageIndex:(NSInteger)pageIndex
                                       success:(void (^)(NSArray *athletes))success
                                       failure:(void (^)(NSError *error))failure;

/**
 Fetch followers of the specified athlete, paged.
 
 Strava API related documentation: http://strava.github.io/api/v3/follow/#followers
 
 @param athleteId athlete Id
 @param pageSize number of athletes per page
 @param pageIndex index of page to fetch, first page index is 1.
 @param success Success callback, athletes is a NSArray of StravaAthlete objects.
 @param failure Failure callback
 */
-(void) fetchFollowersForAthlete:(NSInteger)athleteId
                        pageSize:(NSInteger)pageSize
                       pageIndex:(NSInteger)pageIndex
                         success:(void (^)(NSArray *athletes))success
                         failure:(void (^)(NSError *error))failure;

/**
 Fetch friends of the specified athlete, paged.
 
 Strava API related documentation: http://strava.github.io/api/v3/follow/#friends
 
 @param athleteId athlete Id
 @param pageSize number of athletes per page
 @param pageIndex index of page to fetch, first page index is 1.
 @param success Success callback, athletes is a NSArray of StravaAthlete objects.
 @param failure Failure callback
 */
-(void) fetchFriendsForAthlete:(NSInteger)athleteId
                      pageSize:(NSInteger)pageSize
                     pageIndex:(NSInteger)pageIndex
                       success:(void (^)(NSArray *athletes))success
                       failure:(void (^)(NSError *error))failure;

/**
 Fetch athletes that both the current athlete and the athlete specified in argument follow. Paged request.
 
 Strava API related documentation: http://strava.github.io/api/v3/follow/#friends
 
 @param athleteId athlete Id
 @param pageSize number of athletes per page
 @param pageIndex index of page to fetch, first page index is 1.
 @param success Success callback, athletes is a NSArray of StravaAthlete objects.
 @param failure Failure callback
 */
-(void) fetchCommonFollowersOfCurrentAthleteAndAthlete:(NSInteger)athleteId
                                              pageSize:(NSInteger)pageSize
                                             pageIndex:(NSInteger)pageIndex
                                               success:(void (^)(NSArray *athletes))success
                                               failure:(void (^)(NSError *error))failure;

@end
