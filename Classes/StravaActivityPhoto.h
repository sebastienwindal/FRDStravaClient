//
//  StravaActivityPhoeo.h
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/24/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "StravaCommon.h"
#import <CoreLocation/CoreLocation.h>

///
/// Activity Photo object.
///
/// Strava API maching docs: http://strava.github.io/api/v3/photos/
///
@interface StravaActivityPhoto : MTLModel<MTLJSONSerializing>

@property (nonatomic, readonly) NSInteger id;
@property (nonatomic, readonly) NSInteger activityId;
@property (nonatomic, readonly) kResourceState resourceState;
@property (nonatomic, copy, readonly) NSString *ref;
@property (nonatomic, copy, readonly) NSString *uid;
@property (nonatomic, copy, readonly) NSString *caption;
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, copy, readonly) NSDate *uploadedAt;
@property (nonatomic, copy, readonly) NSDate *createdAt;
@property (nonatomic, readonly) CLLocationCoordinate2D location;


@end
