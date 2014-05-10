//
//  StravaCommon.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/8/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

typedef NS_ENUM(NSInteger, kActivityType) {
    kActivityTypeUnknown = 0,
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
