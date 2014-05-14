//
//  GradeStreamViewController.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/14/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "GradeStreamViewController.h"
#import "ActivityHelper.h"

@interface GradeStreamViewController ()

@end

@implementation GradeStreamViewController

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

#define RANGE 1.0
-(CGFloat) dataRangeWidth
{
    return RANGE;
}

-(kStravaStreamType) valueStreamType
{
    return kStravaStreamTypeGradesmooth;
}


-(UIColor *) colorForValue:(CGFloat)value
{
    UIColor *c = [ActivityHelper colorForGrade:value];
    return c;
}

-(NSString *)stringForRangeStartingWith:(CGFloat)value1 endingWith:(CGFloat)value2 percent:(CGFloat)percent
{
    NSString *str = [NSString stringWithFormat:@"%.1f-%.1f%% %.1f%%", value1, value2, percent];
    
    return str;
}


@end
