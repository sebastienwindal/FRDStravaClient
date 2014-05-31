//
//  StravaSegment.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/8/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <CoreLocation/CoreLocation.h>
#import "StravaActivity.h"
#import "StravaCommon.h"

///
/// Segment object.
///
/// Strava API maching docs: http://strava.github.io/api/v3/segments/
///
@interface StravaSegment : MTLModel<MTLJSONSerializing>

@property (nonatomic, readonly) NSInteger id;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, readonly) kActivityType activityType;
@property (nonatomic, readonly) CGFloat distance;
@property (nonatomic, readonly) CGFloat averageGrade;
@property (nonatomic, readonly) CGFloat maximumGrade;
@property (nonatomic, readonly) CGFloat elevationHigh;
@property (nonatomic, readonly) CGFloat elevationLow;
@property (nonatomic, readonly) CLLocationCoordinate2D startLocation;
@property (nonatomic, readonly) CLLocationCoordinate2D endLocation;
@property (nonatomic, readonly) NSInteger climbCategory;
@property (nonatomic, copy, readonly) NSString *city;
@property (nonatomic, copy, readonly) NSString *state;
@property (nonatomic, copy, readonly) NSString *country;
@property (nonatomic, readonly) BOOL private;
@property (nonatomic, readonly) CGFloat totalElevationGain;
@property (nonatomic, copy, readonly) StravaMap *map;
@property (nonatomic, readonly) NSInteger effortCount;
@property (nonatomic, readonly) NSInteger athleteCount;
@property (nonatomic, readonly) BOOL hazardous;
@property (nonatomic, readonly) NSInteger prEfforId;
@property (nonatomic, readonly) NSTimeInterval prTime;
@property (nonatomic, readonly) CGFloat prDistance;
@property (nonatomic, readonly) BOOL starred;
@property (nonatomic, readonly) kResourceState resourceState;

@end
