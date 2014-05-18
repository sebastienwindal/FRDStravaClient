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

-(void) fetchClubsForCurrentAthleteWithSuccess:(void (^)(NSArray *clubs))success
                                       failure:(void (^)(NSError *error))failure;

-(void) fetchClubWithID:(NSInteger)clubID
                 success:(void (^)(StravaClub *club))success
                    failure:(void (^)(NSError *error))failure;

-(void) fetchMembersOfClub:(NSInteger)clubId
                  pageSize:(NSInteger)pageSize
                 pageIndex:(NSInteger)pageIndex
                   success:(void (^)(NSArray *users))success
                   failure:(void (^)(NSError *error))failure;

-(void) fetchActivitiesOfClub:(NSInteger)clubId
                     pageSize:(NSInteger)pageSize
                    pageIndex:(NSInteger)pageIndex
                      success:(void (^)(NSArray *users))success
                      failure:(void (^)(NSError *error))failure;


@end
