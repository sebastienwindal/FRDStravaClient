//
//  StravaActivityComment.h
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/28/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "StravaAthlete.h"

///
/// Activity Comment object.
///
/// Strava API maching docs: http://strava.github.io/api/v3/comments/
///
@interface StravaActivityComment : MTLModel<MTLJSONSerializing>

@property (nonatomic, readonly) NSInteger id;
@property (nonatomic, readonly) NSInteger activityId;
@property (nonatomic, readonly) kResourceState resourceState;
@property (nonatomic, copy, readonly) NSString *text;
@property (nonatomic, copy, readonly) StravaAthlete *athlete;
@property (nonatomic, copy, readonly) NSDate *createdAt;

@end
