//
//  FRDStravaClient+Club.h
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/17/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "FRDStravaClient.h"
#import "StravaClub.h"


@interface FRDStravaClient (Club)

/**
 Fetch clubs for curent athlete.
 
 Strava API related documentation: http://strava.github.io/api/v3/clubs/#get-athletes
 
 @params success Success callback, athletes is a NSArray of StravaClub objects.
 @params failure Failure callback
 */
-(void) fetchClubsForCurrentAthleteWithSuccess:(void (^)(NSArray *clubs))success
                                       failure:(void (^)(NSError *error))failure;

/**
 Fetch club details by Id.
 
 Strava API related documentation: http://strava.github.io/api/v3/clubs/#get-details
 
 @params clubId club identifier
 @params success Success callback, athletes is a NSArray of StravaClub objects.
 @params failure Failure callback
 */
-(void) fetchClubWithID:(NSInteger)clubId
                 success:(void (^)(StravaClub *club))success
                    failure:(void (^)(NSError *error))failure;

/**
 Fetch club members for specified club. Paged request
 
 Strava API related documentation: http://strava.github.io/api/v3/clubs/#get-members
 
 @params clubId club Id
 @params pageSize number of athletes per page
 @params pageIndex index of page to fetch, first page index is 1.
 @params success Success callback, users is a NSArray of StravaAthlete objects.
 @params failure Failure callback
 */
-(void) fetchMembersOfClub:(NSInteger)clubId
                  pageSize:(NSInteger)pageSize
                 pageIndex:(NSInteger)pageIndex
                   success:(void (^)(NSArray *users))success
                   failure:(void (^)(NSError *error))failure;

/**
 Fetch club activities for specified club. Paged request.
 
 Strava API related documentation: http://strava.github.io/api/v3/clubs/#get-activities
 
 @params clubId club Id
 @params pageSize number of activities per page
 @params pageIndex index of page to fetch, first page index is 1.
 @params success Success callback, users is a NSArray of StravaActivity objects.
 @params failure Failure callback
 */
-(void) fetchActivitiesOfClub:(NSInteger)clubId
                     pageSize:(NSInteger)pageSize
                    pageIndex:(NSInteger)pageIndex
                      success:(void (^)(NSArray *activities))success
                      failure:(void (^)(NSError *error))failure;


@end
