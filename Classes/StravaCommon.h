//
//  StravaCommon.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/8/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

///
/// Level of details a response object contains.
///
/// Strava doc: http://strava.github.io/api/#decoration
///
///
typedef NS_ENUM(NSInteger, kResourceState) {
    /// unspecified/unknown level of details
    kResourceStateUnknown = 0,
    /// minimal level of details (most likely only the ID is valid in the object)
    kResourceStateMeta,
    /// summary information
    kResourceStateSummary,
    /// full details, all fields in the response object should have been set
    kResourceStateDetailed
};


///
/// Strava doc: http://strava.github.io/api/v3/activities/
///
typedef NS_ENUM(NSInteger, kActivityType) {
    /// unspecified/unknown
    kActivityTypeUnknown = 0,
    /// Any kind of cycling, road, mountain, etc...
    kActivityTypeRide,
    kActivityTypeRun,
    kActivityTypeHike,
    kActivityTypeWalk,
    kActivityTypeSwim,
    kActivityTypeWorkout,
    kActivityTypeNordicSki,
    kActivityTypeAlpineSki,
    kActivityTypeBackcountrySki,
    kActivityTypeIceSkate,
    kActivityTypeInlineSkate,
    kActivityTypeKitesurf,
    kActivityTypeRollerSki,
    kActivityTypeWindsurf,
    kActivityTypeSnowboard,
    kActivityTypeSnowshoe
};


@interface StravaCommon : NSObject

+ (NSValueTransformer *)activityTypeJSONTransformer;    // NSString <=> kActivityTypeUnknown
+ (NSValueTransformer *)locationJSONTransformer;        // NSArray [lat, lon] <=> CLLocationDegrees
+ (NSValueTransformer *)dateJSONTransformer;            // NSString <=> NSDate

@end
