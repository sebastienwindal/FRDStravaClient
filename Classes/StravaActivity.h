//
//  StravaActivity.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/18/14.
//

#import "MTLModel.h"
#import "StravaAthlete.h"
#import <CoreLocation/CoreLocation.h>
#import "StravaMap.h"
#import "StravaCommon.h"

///
/// Main activity object.
///
/// Strava API maching docs: http://strava.github.io/api/v3/activities/
///
@interface StravaActivity : MTLModel<MTLJSONSerializing>

@property (nonatomic, readonly) NSInteger id;
@property (nonatomic, readonly) NSInteger externalId;
@property (nonatomic, readonly) kResourceState resourceState;
@property (nonatomic, copy, readonly) StravaAthlete *athlete;
@property (nonatomic, copy, readonly) StravaMap *map;
@property (nonatomic, copy, readonly) NSArray *segmentEfforts; /// NSArray of StravaSegmentEffort
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *activityDescription;
@property (nonatomic, readonly) float distance;
@property (nonatomic, readonly) float totalElevationGain;
@property (nonatomic, readonly) NSTimeInterval movingTime;
@property (nonatomic, readonly) NSTimeInterval elapsedTime;
@property (nonatomic, readonly) kActivityType type;
@property (nonatomic, copy, readonly) NSDate *startDate;
@property (nonatomic, copy, readonly) NSString *gearId;
@property (nonatomic, readonly) CLLocationCoordinate2D startLocation;
@property (nonatomic, readonly) CLLocationCoordinate2D endLocation;

@property (nonatomic, readonly) BOOL trainer;
@property (nonatomic, readonly) BOOL private;
@property (nonatomic, readonly) BOOL commute;

@property (nonatomic, copy, readonly) NSString *locationCity;
@property (nonatomic, copy, readonly) NSString *locationCountry;
@property (nonatomic, copy, readonly) NSString *locationState;

@property (nonatomic, readonly) float averageSpeed;
@property (nonatomic, readonly) float maxSpeed;
@property (nonatomic, readonly) float averageCadence;
@property (nonatomic, readonly) float averageWatts;
@property (nonatomic, readonly) float kiloJoules;
@property (nonatomic, readonly) float averageHeartrate;
@property (nonatomic, readonly) float maxHeartrate;
@property (nonatomic, readonly) float calories;

@end
