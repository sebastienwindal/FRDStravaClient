//
//  FRDStravaClient+Gear.h
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/17/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "FRDStravaClient.h"
#import "StravaGear.h"

@interface FRDStravaClient (Gear)

/**
 Fetch Gear details by Id. Only works if the gear is owned by curent logged-in user.
 
 Strava API related documentation: http://strava.github.io/api/v3/gear/#show
 
 @param gearId gear identifier
 @param success Success callback
 @param failure Failure callback
 */
-(void) fetchGearWithId:(NSString *)gearId
                success:(void (^)(StravaGear *gear))success
                failure:(void (^)(NSError *error))failure;

@end
