//
//  ActivityHelper.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/1/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StravaActivity.h"

@interface ActivityHelper : NSObject

+(UIColor *)colorForActivityType:(kActivityType)activityType;
+(void) makeLabel:(UILabel *)label activityTypeIconForActivity:(StravaActivity *)activity;
+(CGFloat) fontSizeFactorForActivityType:(kActivityType)activityType;
+(const char *) iconCodeForActivityType:(kActivityType)activityType;
+(UIColor *)colorForHeartRate:(float)bpm;
+(UIColor *)colorForSpeed:(float)speed;
+(UIColor *)colorForCadence:(float)cadence;
+(UIColor *)colorForGrade:(float)grade;

@end
