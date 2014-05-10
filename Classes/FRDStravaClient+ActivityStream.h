//
//  FRDStravaClient+ActivityStream.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/5/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "FRDStravaClient.h"
#import "StravaStream.h"

@interface FRDStravaClient (ActivityStream)

-(void) fetchActivityStreamForActivityId:(NSInteger)activityId
                              resolution:(kStravaStreamResolution)resolution
                               dataTypes:(NSArray *)dataTypes
                                 success:(void (^)(NSArray *streams))success
                                 failure:(void (^)(NSError *error))failure;



@end
