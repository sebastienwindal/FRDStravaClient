//
//  HeartRateStreamViewController.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/14/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "HeartRateStreamViewController.h"
#import "ActivityHelper.h"
@interface HeartRateStreamViewController ()

@end

@implementation HeartRateStreamViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define RANGE 2
-(CGFloat) dataRangeWidth
{
    return RANGE;
}

-(kStravaStreamType) valueStreamType
{
    return kStravaStreamTypeHeartrate; 
}


-(UIColor *) colorForValue:(CGFloat)value
{
    return [ActivityHelper colorForHeartRate:value];
}

-(NSString *)stringForRangeStartingWith:(CGFloat)value1 endingWith:(CGFloat)value2 percent:(CGFloat)percent
{
    NSString *str = [NSString stringWithFormat:@"%d-%dbpm %.1f%%", (int)floorf(value1), (int)floorf(value2), percent];
    
    return str;
}

@end
