//
//  FRDStravaClient+Activity.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/21/14.
//

#import "FRDStravaClient.h"
#import "StravaActivity.h"

@interface FRDStravaClient (Activity)

// https://www.strava.com/api/v3/athlete/activities
// current user...
-(void) fetchActivitiesForCurrentUserWithSuccess:(void (^)(NSArray *activities))success
                                        failure:(void (^)(NSError *error))failure;

-(void) fetchActivitiesForCurrentUser:(NSInteger)pageSize
                            pageIndex:(NSInteger)pageIndex
                              success:(void (^)(NSArray *activities))success
                              failure:(void (^)(NSError *error))failure;

-(void) fetchActivitiesForCurrentUserAfterDate:(NSDate *)date
                                       success:(void (^)(NSArray *activities))success
                                       failure:(void (^)(NSError *error))failure;

-(void) fetchActivitiesForCurrentUserBeforeDate:(NSDate *)date
                                        success:(void (^)(NSArray *activities))success
                                        failure:(void (^)(NSError *error))failure;


// https://www.strava.com/api/v3/activities/following
// friend feed
-(void) fetchFriendActivitiesWithSuccess:(void (^)(NSArray *activities))success
                                 failure:(void (^)(NSError *error))failure;

-(void) fetchFriendActivities:(NSInteger)pageSize
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



@end
