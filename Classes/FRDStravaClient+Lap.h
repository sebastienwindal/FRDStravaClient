//
//  FRDStravaClient+Lap.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/24/14.
//

#import "FRDStravaClient.h"
#import "StravaActivityLap.h"

@interface FRDStravaClient (Lap)

-(void) fetchLapsForActivity:(NSInteger)activityId
                     success:(void (^)(NSArray *laps))success
                     failure:(void (^)(NSError *error))failure;

@end
