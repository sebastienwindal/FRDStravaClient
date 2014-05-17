//
//  FRDStravaClient+Gear.h
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/17/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "FRDStravaClient.h"
#import "StravaGear.h"

@interface FRDStravaClient (Gear)

-(void) fetchGearWithId:(NSString *)gearId
                success:(void (^)(StravaGear *gear))success
                failure:(void (^)(NSError *error))failure;

@end
