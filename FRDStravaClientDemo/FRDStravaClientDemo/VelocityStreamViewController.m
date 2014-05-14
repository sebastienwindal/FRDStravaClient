//
//  VelocityStreamViewController.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/8/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "VelocityStreamViewController.h"
#import "ActivityHelper.h"


@interface VelocityStreamViewController () 



@end

@implementation VelocityStreamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(CGFloat) dataRangeWidth
{
    return 2 / 3.6f; // so the histogram bars width is 2 km/h
}

-(kStravaStreamType) valueStreamType
{
    return kStravaStreamTypeVelocitySmooth;
}

-(UIColor *) colorForValue:(CGFloat)value
{
    return [ActivityHelper colorForSpeed:value];
}

-(NSString *)stringForRangeStartingWith:(CGFloat)value1 endingWith:(CGFloat)value2 percent:(CGFloat)percent
{
    NSString *str = [NSString stringWithFormat:@"%d-%dkm/h %.1f%%", (int)floorf(value1*3.6), (int)floorf(value2*3.6), percent];
    
    return str;
}



@end
