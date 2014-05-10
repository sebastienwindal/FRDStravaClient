//
//  ActivityDetailsViewController.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/5/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "ActivityDetailsViewController.h"
#import "FRDStravaClient+Activity.h"
#import "FRDStravaClient+ActivityStream.h"
#import "JBLineChartView.h"
#import "JBBarChartView.h"
#import "ActivityHelper.h"

@interface ActivityDetailsViewController () <JBLineChartViewDataSource, JBLineChartViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) StravaStream *heartRateStream;
@property (weak, nonatomic) IBOutlet JBLineChartView *heartrateLineChartView;
@property (weak, nonatomic) IBOutlet JBBarChartView *heartrateBarChartView;
@property (nonatomic, strong) NSMutableDictionary *heartrateRepartition;
@property (nonatomic) int minHeartRate;
@property (nonatomic) int maxHeartRate;

@property (nonatomic) CGFloat hrRangeWidth;

@property (weak, nonatomic) IBOutlet JBBarChartView *cadenceChartView;
@property (nonatomic, strong) NSMutableDictionary *cadenceRepartition;
@property (nonatomic) CGFloat minCadence;
@property (nonatomic) CGFloat maxCadence;
@property (nonatomic) CGFloat cadenceRangeWidth;

@end

@implementation ActivityDetailsViewController


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
    
    self.scrollView.contentSize = CGSizeMake(320, 800);
    
    self.hrRangeWidth = 2.0f;
    self.cadenceRangeWidth = 2.0f;
    
    self.heartrateLineChartView.dataSource = self;
    self.heartrateLineChartView.delegate = self;
    
    self.heartrateBarChartView.dataSource = self;
    self.heartrateBarChartView.delegate = self;
    
    
    self.cadenceChartView.dataSource = self;
    self.cadenceChartView.delegate = self;
}

-(NSMutableDictionary *) heartrateRepartition
{
    if (_heartrateRepartition == nil) {
        _heartrateRepartition = [[NSMutableDictionary alloc] init];
    }
    return _heartrateRepartition;
}

-(NSMutableDictionary *) cadenceRepartition
{
    if (_cadenceRepartition == nil) {
        _cadenceRepartition = [[NSMutableDictionary alloc] init];
    }
    return _cadenceRepartition;
}

-(void) processHeartRateStream:(StravaStream *)stream
{
    self.heartRateStream = stream;
    
    self.minHeartRate = 10000;
    self.maxHeartRate = 0;

    [self.heartRateStream.data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        int hr = (int) floorf([obj intValue] / self.hrRangeWidth);
        self.maxHeartRate = MAX(self.maxHeartRate, hr);
        self.minHeartRate = MIN(self.minHeartRate, hr);
        
        self.heartrateRepartition[@(hr)] = @([self.heartrateRepartition[@(hr)] intValue] + 1);
    }];
    
    [self.heartrateLineChartView reloadData];
    [self.heartrateBarChartView reloadData];
}

-(void) processCadenceStream:(StravaStream *)stream
{
    self.minCadence = 10000;
    self.maxCadence = 0;
    
    [stream.data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        int cadence = (int) floorf([obj floatValue] / self.cadenceRangeWidth);
        self.maxCadence = MAX(self.maxCadence, cadence);
        self.minCadence = MIN(self.minCadence, cadence);
        
        self.cadenceRepartition[@(cadence)] = @([self.cadenceRepartition[@(cadence)] intValue] + 1);
    }];
    
    [self.cadenceChartView reloadData];
}

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    return 1;
}


- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView
numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    return [self.heartRateStream.data count];
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView
verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex
             atLineIndex:(NSUInteger)lineIndex
{
    return [self.heartRateStream.data[horizontalIndex] floatValue];
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
    return 1.0f;
}

- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    if (barChartView == self.heartrateBarChartView) {
        return self.maxHeartRate - self.minHeartRate + 1;
    } else if (barChartView == self.cadenceChartView) {
        return self.maxCadence - self.minCadence + 1;
    }
    return 0;
}


- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSUInteger)index
{
    if (barChartView == self.heartrateBarChartView) {
        unsigned long hr = self.minHeartRate + index;
        int val = [self.heartrateRepartition[@(hr)] intValue];
        return val;
    }  else if (barChartView == self.cadenceChartView) {
        unsigned long cadence = self.minCadence + index;
        int val = [self.cadenceRepartition[@(cadence)] intValue];
        return val;
    }
    
    return 0.0f;
}

- (NSUInteger)barPaddingForBarChartView:(JBBarChartView *)barChartView
{
    return 1;
}

-(UIView *) barChartView:(JBBarChartView *)barChartView
          barViewAtIndex:(NSUInteger)index
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,1,1)];
    if (barChartView == self.heartrateBarChartView) {
        v.backgroundColor = [ActivityHelper colorForHeartRate:(self.minHeartRate + index) * self.hrRangeWidth];
    } else if (barChartView == self.cadenceChartView) {
        v.backgroundColor = [ActivityHelper colorForCadence:(self.minCadence + index) * self.cadenceRangeWidth];
    }
    
    return v;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setActivityId:)]) {
        [segue.destinationViewController setActivityId:self.activityId];
    }
}
@end
