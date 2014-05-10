//
//  FRDStravaClient+Segment.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/9/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "FRDStravaClient.h"
#import "StravaSegment.h"
#import "StravaSegmentEffort.h"


@interface FRDStravaClient (Segment)

-(void) fetchSegmentWithId:(NSInteger)segmentId
                   success:(void (^)(StravaSegment *segment))success
                   failure:(void (^)(NSError *error))failure;

-(void) fetchStarredSegmentsForCurrentUserWithSuccess:(void (^)(NSArray *segments))success
                                              failure:(void (^)(NSError *error))failure;


-(void) fetchSegmentEffortWithId:(NSInteger)segmentEffortId
                         success:(void (^)(StravaSegmentEffort *segmentEffort))success
                         failure:(void (^)(NSError *error))failure;

@end
