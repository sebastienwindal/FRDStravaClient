//
//  FRDStravaClient+Lap.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/24/14.
//

#import "FRDStravaClient.h"
#import "StravaActivityLap.h"

@interface FRDStravaClient (Lap)

/**
 Fetch laps of specified activity.
 
 Strava API related documentation: http://strava.github.io/api/v3/activities/#laps
 
 @param activityId activity identifier
 @param success Success callback, laps is a NSArray of StravaActivityLap objects.
 @param failure Failure callback
 */
-(void) fetchLapsForActivity:(NSInteger)activityId
                     success:(void (^)(NSArray *laps))success
                     failure:(void (^)(NSError *error))failure;

@end
