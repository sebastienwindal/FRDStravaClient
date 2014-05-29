//
//  FRDStravaClient+Activity.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/21/14.
//

#import "FRDStravaClient.h"
#import "StravaActivity.h"
#import "StravaActivityZone.h"
#import "StravaActivityPhoto.h"
#import "StravaActivityComment.h"


@interface FRDStravaClient (Activity)

// https://www.strava.com/api/v3/athlete/activities
// current user...
-(void) fetchActivitiesForCurrentAthleteWithSuccess:(void (^)(NSArray *activities))success
                                            failure:(void (^)(NSError *error))failure;

-(void) fetchActivitiesForCurrentAthleteWithPageSize:(NSInteger)pageSize
                                           pageIndex:(NSInteger)pageIndex
                                             success:(void (^)(NSArray *activities))success
                                             failure:(void (^)(NSError *error))failure;

-(void) fetchActivitiesForCurrentAthleteAfterDate:(NSDate *)date
                                          success:(void (^)(NSArray *activities))success
                                          failure:(void (^)(NSError *error))failure;

-(void) fetchActivitiesForCurrentAthleteBeforeDate:(NSDate *)date
                                           success:(void (^)(NSArray *activities))success
                                           failure:(void (^)(NSError *error))failure;


// https://www.strava.com/api/v3/activities/following
// friend feed
-(void) fetchFriendActivitiesWithSuccess:(void (^)(NSArray *activities))success
                                 failure:(void (^)(NSError *error))failure;

-(void) fetchFriendActivitiesWithPageSize:(NSInteger)pageSize
                                pageIndex:(NSInteger)pageIndex
                                  success:(void (^)(NSArray *activities))success
                                  failure:(void (^)(NSError *error))failure;

-(void) fetchFriendActivitiesAfterDate:(NSDate *)date
                               success:(void (^)(NSArray *activities))success
                               failure:(void (^)(NSError *error))failure;

-(void) fetchFriendActivitiesBeforeDate:(NSDate *)date
                                success:(void (^)(NSArray *activities))success
                                failure:(void (^)(NSError *error))failure;


// individual activity

-(void) fetchActivityWithId:(NSInteger)activityId
          includeAllEfforts:(BOOL)includeAllEfforts
                    success:(void (^)(StravaActivity *activity))success
                    failure:(void (^)(NSError *error))failure;

// photos

-(void) fetchPhotosForActivity:(NSInteger)activityId
                       success:(void (^)(NSArray *photos))success
                       failure:(void (^)(NSError *error))failure;

// zones

-(void) fetchZonesForActivity:(NSInteger)activityId
                      success:(void (^)(NSArray *zones))success
                      failure:(void (^)(NSError *error))failure;

// comments

-(void) fetchCommentsForActivity:(NSInteger)activityId
                        markdown:(BOOL)markdown
                        pageSize:(NSInteger)pageSize
                       pageIndex:(NSInteger)pageIndex
                         success:(void (^)(NSArray *comments))success
                         failure:(void (^)(NSError *error))failure;

// kudos

-(void) fetchKudoersForActivity:(NSInteger)activityId
                       pageSize:(NSInteger)pageSize
                      pageIndex:(NSInteger)pageIndex
                        success:(void (^)(NSArray *comments))success
                        failure:(void (^)(NSError *error))failure;


@end
