//
//  FRDStravaClient+Athlete.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/21/14.
//

#import "FRDStravaClient.h"
#import "StravaAthlete.h"

@interface FRDStravaClient (Athlete)

-(void) fetchAthleteWithId:(NSInteger)athleteId
                   success:(void (^)(StravaAthlete *athlete))success
                   failure:(void (^)(NSError *error))failure;
-(void) fetchCurrentAthleteWithSuccess:(void (^)(StravaAthlete *athlete))success
                              failure:(void (^)(NSError *error))failure;

-(void) fetchCurrentAthleteFollowersWithPageSize:(NSInteger)pageSize
                                       pageIndex:(NSInteger)pageIndex
                                         success:(void (^)(NSArray *athletes))success
                                         failure:(void (^)(NSError *error))failure;
-(void) fetchCurrentAthleteFriendsWithPageSize:(NSInteger)pageSize
                                     pageIndex:(NSInteger)pageIndex
                                       success:(void (^)(NSArray *athletes))success
                                       failure:(void (^)(NSError *error))failure;
-(void) fetchFollowersForAthlete:(NSInteger)athleteId
                        pageSize:(NSInteger)pageSize
                       pageIndex:(NSInteger)pageIndex
                         success:(void (^)(NSArray *athletes))success
                         failure:(void (^)(NSError *error))failure;
-(void) fetchFriendsForAthlete:(NSInteger)athleteId
                      pageSize:(NSInteger)pageSize
                     pageIndex:(NSInteger)pageIndex
                       success:(void (^)(NSArray *athletes))success
                       failure:(void (^)(NSError *error))failure;
-(void) fetchCommonFollowersOfCurrentAthleteAndAthlete:(NSInteger)athleteId
                                              pageSize:(NSInteger)pageSize
                                             pageIndex:(NSInteger)pageIndex
                                               success:(void (^)(NSArray *athletes))success
                                               failure:(void (^)(NSError *error))failure;

@end
