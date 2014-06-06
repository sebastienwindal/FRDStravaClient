//
//  FRDStravaClient+ActivityStream.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/5/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "FRDStravaClient.h"
#import "StravaStream.h"

@interface FRDStravaClient (ActivityStream)


/**
 Fetch activity streams for the specified activity. Only work for activities owned by the current authenticated user.
 
 Strava API related documentation: http://strava.github.io/api/v3/streams/#activity
 
 @param activityId the ID of the activity
 @param resolution Stream data resolution
 @param dataTypes an NSArray of kStravaStreamType NSNumber objects e.g. @[ @(kStravaStreamTypeHeartrate), @(kStravaStreamTypeCadence) ]
 @param success Success callback, streams is a NSArray of `StravaStream` objects, one element per dataTypes requested. If a requested dataType is not available for that activity, it will be omitted.
 @param failure Failure callback
 
 */
-(void) fetchActivityStreamForActivityId:(NSInteger)activityId
                              resolution:(kStravaStreamResolution)resolution
                               dataTypes:(NSArray *)dataTypes
                                 success:(void (^)(NSArray *streams))success
                                 failure:(void (^)(NSError *error))failure;



@end
