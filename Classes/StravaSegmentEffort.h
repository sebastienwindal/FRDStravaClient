//
//  StravaSegmentEffort.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/9/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "MTLModel.h"
#import "StravaSegment.h"

///
/// Segment Effort object.
///
/// Strava API maching docs: http://strava.github.io/api/v3/efforts/
///
@interface StravaSegmentEffort : MTLModel<MTLJSONSerializing>

@property (nonatomic, readonly) NSInteger id;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) StravaSegment *segment;
@property (nonatomic, readonly) NSInteger activityId;
@property (nonatomic, readonly) NSInteger athleteId;
@property (nonatomic, readonly) NSInteger komRank;
@property (nonatomic, readonly) NSInteger prRank;
@property (nonatomic, readonly) NSTimeInterval elapsedTime;
@property (nonatomic, readonly) NSTimeInterval movingTime;
@property (nonatomic, copy, readonly) NSDate *startDate;
@property (nonatomic, readonly) CGFloat distance;
@property (nonatomic, readonly) NSInteger startIndex;
@property (nonatomic, readonly) NSInteger endIndex;
@property (nonatomic, readonly) BOOL hidden;
@property (nonatomic, readonly) kResourceState resourceState;


@end
