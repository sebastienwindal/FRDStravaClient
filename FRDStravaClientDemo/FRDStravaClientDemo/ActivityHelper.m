//
//  ActivityHelper.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/1/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "ActivityHelper.h"
#import "IconHelper.h"
#import "EDColor.h"

@implementation ActivityHelper

+(UIColor *)colorForActivityType:(kActivityType)activityType
{
    if (activityType == kActivityTypeRide) {
        return [UIColor redColor];
    } else if (activityType == kActivityTypeRun) {
        return [UIColor blueColor];
    } else if (activityType == kActivityTypeHike) {
        return [UIColor brownColor];
    } else if (activityType == kActivityTypeWalk) {
        return [UIColor magentaColor];
    } else {
        return [UIColor blackColor];
    }
}

+(const char *) iconCodeForActivityType:(kActivityType)activityType
{
    static const char *codes[] = {
                            ICON_PERSON87, // kActivityTypeUnknown
                            ICON_BICYCLE, // kActivityTypeRide
                            ICON_TRAIL, // kActivityTypeRun
                            ICON_MOUNTAIN22, // kActivityTypeHike
                            ICON_RUBBER4, // kActivityTypeWalk
                            ICON_SWIM1, // kActivityTypeSwim
                            ICON_PERSON87, // kActivityTypeWorkout
                            ICON_SKI2, // kActivityTypeNordicSki
                            ICON_SKIING, // kActivityTypeAlpineSki
                            ICON_SKI2, // kActivityTypeBackcountrySki
                            ICON_SPEED7, // kActivityTypeIceSkate
                            ICON_SKATER1, // kActivityTypeInlineSkate
                            ICON_KITESURFING, // kActivityTypeKitesurf
                            ICON_SKATER1, // kActivityTypeRollerSki
                            ICON_WINDSURF, // kActivityTypeWindsurf
                            ICON_SNOWBOARD1, // kActivityTypeSnowboard
                            ICON_SNOWBOARD1 // kActivityTypeSnowshoe
    };

    return codes[activityType];
}

+(CGFloat) fontSizeFactorForActivityType:(kActivityType)activityType
{
    const CGFloat fontBase = 14.0f;
    
    static const CGFloat sizes[] = {
        18.0f/fontBase, // kActivityTypeUnknown
        18.0f/fontBase, // kActivityTypeRide
        20.0f/fontBase, // kActivityTypeRun
        22.0f/fontBase, // kActivityTypeHike
        24.0f/fontBase, // kActivityTypeWalk
        14.0f/fontBase, // kActivityTypeSwim
        18.0f/fontBase, // kActivityTypeWorkout
        18.0f/fontBase, // kActivityTypeNordicSki
        20.0f/fontBase, // kActivityTypeAlpineSki
        18.0f/fontBase, // kActivityTypeBackcountrySki
        20.0f/fontBase, // kActivityTypeIceSkate
        18.0f/fontBase, // kActivityTypeInlineSkate
        18.0f/fontBase, // kActivityTypeKitesurf
        22.0f/fontBase, // kActivityTypeRollerSki
        18.0f/fontBase, // kActivityTypeWindsurf
        22.0f/fontBase, // kActivityTypeSnowboard
        22.0f/fontBase // kActivityTypeSnowshoe
    };
    
    
    return sizes[activityType];

}

+(void) makeLabel:(UILabel *)label activityTypeIconForActivity:(StravaActivity *)activity
{
    
    
    CGFloat fontSize = 12 * [self fontSizeFactorForActivityType:activity.type];
    const char *iconCode = [self iconCodeForActivityType:activity.type];
    
    [IconHelper makeThisLabel:label anIcon:(char *)iconCode ofSize:fontSize];
}

+(UIColor *)colorForHeartRate:(float)bpm
{
    // made up color zones...
    if (bpm < 90) {
        return [UIColor blueColor];
    }
    if (bpm > 190) {
        return [UIColor redColor];
    }
    
    int hrRange = 190-90;

    
    int distanceFromBlue = bpm-90;

    // HR 90 : blue (hue 240 degrees)
    // HR 190: red (hue of 0 degrees)
    CGFloat hueRange = 240;
    CGFloat hueDegrees = 240 - hueRange * distanceFromBlue/hrRange;
    
    return [UIColor colorWithHue:hueDegrees/360.0f
                      saturation:1.0f
                      brightness:0.95f
                           alpha:1.0f];
}

+(UIColor *)colorForSpeed:(float)speed
{
    // speed expressed in m/s
    if (speed < 4) {
        return [UIColor blueColor];
    }
    if (speed > 18) {
        return [UIColor colorWithHue:300/360.0f saturation:1 brightness:1 alpha:1];
    }
    
    // between 4 and 18, the hue is going to range from blue (hue 240) to magenta (hue 300, or 660)...
    CGFloat hueDelta = 360 + 240 - 300;
    CGFloat speedDelta = (18-4);
    
    CGFloat hueDegreePerSpeedUnit = hueDelta/speedDelta;
    
    CGFloat hue = 240 - (speed-4) * hueDegreePerSpeedUnit;
    while (hue > 360) {
        hue -= 360;
    }
    while (hue<0) {
        hue += 360;
    }
    
    return [UIColor colorWithHue:hue/360.0f saturation:1 brightness:1 alpha:1];
}

+(UIColor *)colorForCadence:(float)cadence
{
    if (cadence < 50) {
        return [UIColor blueColor];
    }
    if (cadence > 120) {
        return [UIColor redColor];
    }
    
    
    // between 50 and 120, the hue is going to range from blue (hue 240) to magenta (hue 300, or 660)...
    CGFloat hueDelta = 360 + 240 - 300;
    CGFloat cadenceDelta = 120-50;
    
    CGFloat hueDegreePerRpm = hueDelta/cadenceDelta;
    
    CGFloat hue = 240 - (cadence-50) * hueDegreePerRpm;
    while (hue > 360) {
        hue -= 360;
    }
    while (hue<0) {
        hue += 360;
    }
    
    return [UIColor colorWithHue:hue/360.0f saturation:1 brightness:1 alpha:1];
}

+(UIColor *)colorForGrade:(float)grade
{
    if (grade > 14) {
        return [UIColor colorWithHue:300/360.0f saturation:1 brightness:1 alpha:1];
    }
    if (grade < -14) {
        return [UIColor blueColor];
    }
    
    grade += 14;
    
    // between -14% and +14, the hue is going to range from blue (hue 240) to magenta (hue 300, or 660)...
    CGFloat hueDelta = 360 + 240 - 300;
    CGFloat gradeDelta = 14 - (-14);
    
    CGFloat hueDegreePerGrade = hueDelta/gradeDelta;
    
    CGFloat hue = 240 - grade * hueDegreePerGrade;
    while (hue > 360) {
        hue -= 360;
    }
    while (hue<0) {
        hue += 360;
    }
    
    return [UIColor colorWithHue:hue/360.0f saturation:1 brightness:1 alpha:1];

}

@end
