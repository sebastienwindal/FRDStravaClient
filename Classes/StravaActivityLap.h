//
//  StravaActivityLap.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/24/14.
//

#import <Mantle/Mantle.h>
#import "StravaCommon.h"


///
/// Activity Lap object.
///
/// Strava API maching docs: http://strava.github.io/api/v3/activities/#laps
///
@interface StravaActivityLap : MTLModel<MTLJSONSerializing>

@property (nonatomic, readonly) NSInteger id;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, readonly) NSInteger activityId;
@property (nonatomic, readonly) NSInteger athleteId;
@property (nonatomic, readonly) NSTimeInterval movingTime;
@property (nonatomic, readonly) NSTimeInterval elapsedTime;
@property (nonatomic, copy, readonly) NSDate *startDate;
@property (nonatomic, readonly) double distance;
@property (nonatomic, readonly) NSInteger lapIndex;
@property (nonatomic, readonly) float averageSpeed;
@property (nonatomic, readonly) float maxSpeed;
@property (nonatomic, readonly) float averageCadence;
@property (nonatomic, readonly) float averageWatts;
@property (nonatomic, readonly) float kiloJoules;
@property (nonatomic, readonly) float averageHeartrate;
@property (nonatomic, readonly) float maxHeartrate;
@property (nonatomic, readonly) kResourceState resourceState;

@end
