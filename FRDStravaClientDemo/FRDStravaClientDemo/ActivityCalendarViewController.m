//
//  ActivityCalendarViewController.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/15/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "ActivityCalendarViewController.h"
#import "ActivityHelper.h"
#import "FRDStravaClient+Activity.h"
#import "ActivityCalendarCollectionViewCell.h"
#import "EDColor.h"
#import "HeaderPickerView.h"

@interface ActivitySummary : NSObject

@property (nonatomic) float distance;
@property (nonatomic) float avgSpeed;
@property (nonatomic) NSTimeInterval movingTime;
@property (nonatomic) float elevationGain;

+(instancetype) activitySummaryWithDistance:(CGFloat)distance
                                   avgSpeed:(float)avgSpeed
                                 movingTime:(NSTimeInterval)movingTime
                              elevationGain:(float)elevationGain;
@end

@implementation ActivitySummary

+(instancetype) activitySummaryWithDistance:(CGFloat)distance
                                   avgSpeed:(float)avgSpeed
                                 movingTime:(NSTimeInterval)movingTime
                              elevationGain:(float)elevationGain
{
    ActivitySummary *as = [[ActivitySummary alloc] init];
    as.distance  = distance;
    as.avgSpeed = avgSpeed;
    as.movingTime = movingTime;
    as.elevationGain = elevationGain;
    
    return as;
}

-(NSString *) debugDescription
{
    return [NSString stringWithFormat:@"%fkm %.1fkm/h %.2fhrs %dm", self.distance/1000.0f, self.avgSpeed*3.6, self.movingTime/3600.0, (int)self.elevationGain];
}
@end


@interface ActivityCalendarViewController ()

@property (nonatomic, strong) NSDate *mondayNextWeek;
@property (nonatomic, strong) NSDate *oldestDateWithAnActivity;
@property (nonatomic,  strong) NSMutableDictionary *activitySummaries;


@property (nonatomic) int selectedIndex;

@end

@implementation ActivityCalendarViewController

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
    
    self.selectedIndex = 0;
    
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setLocale:[NSLocale currentLocale]];
    
    NSDateComponents *nowComponents = [gregorian components:NSYearCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:today];
    
    [nowComponents setWeekday:1]; // Monday
    [nowComponents setWeek: [nowComponents week] + 1]; //Next week
    [nowComponents setHour:0]; // 0a.m.
    [nowComponents setMinute:0];
    [nowComponents setSecond:0];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:nowComponents];
    
    self.mondayNextWeek = self.oldestDateWithAnActivity = beginningOfWeek;
    
    [self fetchNextBatch];
}

-(NSMutableDictionary *) activitySummaries
{
    if (_activitySummaries == nil) {
        _activitySummaries = [[NSMutableDictionary alloc] init];
    }
    return _activitySummaries;
}

-(void) fetchNextBatch
{
    [self showSpinner];
    [[FRDStravaClient sharedInstance] fetchActivitiesForCurrentUserBeforeDate:self.oldestDateWithAnActivity
                                                                      success:^(NSArray *activities) {
                                                                          [self processActivities:activities];
                                                                          [self showMoreButton];
                                                                      }
                                                                      failure:^(NSError *error) {
                                                                          [self showMoreButton];
                                                                      }];
    
}


-(NSDate *)midnightDateForDate:(NSDate *)date
{
    static const unsigned componentFlags = (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit);
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *components = [calendar components:componentFlags
                                               fromDate:date];
	components.hour = 0;
	components.minute = 0;
	components.second = 0;
    
	return [calendar dateFromComponents:components];
}

-(void) processActivities:(NSArray *)activities
{
    for (StravaActivity *activity in activities) {
        NSDate *midnight = [self midnightDateForDate:activity.startDate];
        if (activity.type == kActivityTypeRide) {
        
            ActivitySummary *activitySummary = [ActivitySummary activitySummaryWithDistance:activity.distance
                                                                                   avgSpeed:activity.averageSpeed
                                                                                 movingTime:activity.movingTime
                                                                              elevationGain:activity.totalElevationGain];
            ActivitySummary *existingActivitySummary = self.activitySummaries[midnight];
            
            // weighted average or sum between new one and existing for that day
            activitySummary.avgSpeed = (activity.averageSpeed * activity.movingTime + existingActivitySummary.avgSpeed * existingActivitySummary.movingTime) / (activity.movingTime + existingActivitySummary.movingTime);
            activitySummary.distance += existingActivitySummary.distance;
            activitySummary.movingTime += existingActivitySummary.movingTime;
            activitySummary.elevationGain += existingActivitySummary.elevationGain;
            
            self.activitySummaries[midnight] = activitySummary;
        }
        self.oldestDateWithAnActivity = activity.startDate;
    }
    
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:self.oldestDateWithAnActivity
                                                          toDate:self.mondayNextWeek
                                                         options:0];
    if (components.day % 7 == 0) {
        return components.day;
    } else {
        return (int) 7 * ceilf(components.day / 7.0f);
    }
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityCalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DayActivityCell"
                                                                                         forIndexPath:indexPath];
    
    // "flip" each row horizontally e.g.
    //   0->6   1->5
    //   7->13  8->12
    int week = (int) floorf(indexPath.row / 7.0f);
    int day = indexPath.row % 7;
    
    int index = week * 7 + 6 - day;
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-index];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                                    toDate:self.mondayNextWeek
                                                                   options:0];

    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:newDate];
    cell.dayLabel.text = [NSString stringWithFormat:@"%d", components.day];
    ActivitySummary *summary = self.activitySummaries[newDate];
    if (summary == nil) {
        cell.backgroundColor = [UIColor lightGrayColor];
    } else {
        if (self.selectedIndex == 0) {
            cell.backgroundColor = [self colorForCalendarDistance:summary.distance];
        } else if (self.selectedIndex == 1) {
            cell.backgroundColor = [self colorForCalendarDuration:summary.movingTime];
        } else if (self.selectedIndex == 2) {
           cell.backgroundColor = [self colorForCalendarClimbing:summary.elevationGain];
        } else if (self.selectedIndex == 3) {
            cell.backgroundColor = [self colorForCalendarSpeed:summary.avgSpeed];
        }
    }
    return cell;
}

-(UICollectionReusableView *) collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    HeaderPickerView *v = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                     withReuseIdentifier:@"Header"
                                                                            forIndexPath:indexPath];

    if ([v.segmentedControl actionsForTarget:self forControlEvent:UIControlEventValueChanged].count == 0) {
        [v.segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return v;
}

-(IBAction)valueChanged:(UISegmentedControl *)sender
{
    self.selectedIndex = sender.selectedSegmentIndex;
    
    [self.collectionView reloadData];
}

-(void) showMoreButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"more"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(fetchNextBatch)];
}

-(void) showSpinner
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = activityItem;
}

-(UIColor *)colorForCalendarDuration:(float)duration
{
    CGFloat b;
    
    if (duration < 3600) {
        // less than an hour should be almost white...
        b = 0.2;
    } else if (duration > 5 * 3600) {
        b = 0.9;
    } else {
        b = 0.2 + 0.7 * (duration - 3600) / 4.0f / 3600.0f;
    }
    
    UIColor *c = [UIColor colorWithHue:0.5 saturation:1.0f lightness:1-b alpha:1.0f];

    return c;
}

-(UIColor *)colorForCalendarSpeed:(float)speed
{
    CGFloat b;
    CGFloat upperThreshold = 24;
    CGFloat lowerThreshold = 16;
    float speedMPH = speed * 3.6 / 1.6;
    
    if (speedMPH < lowerThreshold) {
        // less than 30K should be almost white...
        b = 0.2;
    } else if (speedMPH > upperThreshold) {
        b = 0.9;
    } else {
        b = 0.2 + 0.7 * (speedMPH - lowerThreshold) / (upperThreshold - lowerThreshold);
    }
    
    UIColor *c = [UIColor colorWithHue:0.0 saturation:1.0f lightness:1-b alpha:1.0f];
    
    return c;
}

-(UIColor *)colorForCalendarClimbing:(float)climbing
{
    CGFloat b;
    CGFloat upperThreshold = 4200;
    CGFloat lowerThreshold = 200;
    
    if (climbing < lowerThreshold) {
        // less than 30K should be almost white...
        b = 0.2;
    } else if (climbing > upperThreshold) {
        b = 0.9;
    } else {
        b = 0.2 + 0.7 * (climbing -lowerThreshold) / (upperThreshold - lowerThreshold);
    }
    
    UIColor *c = [UIColor colorWithHue:0.1 saturation:1.0f lightness:1-b alpha:1.0f];
    
    return c;
}

-(UIColor *)colorForCalendarDistance:(float)distance
{
    CGFloat b;
    CGFloat upperThreshold = 160000;
    CGFloat lowerThreshold = 30000;
    
    if (distance < lowerThreshold) {
        // less than 30K should be almost white...
        b = 0.2;
    } else if (distance > upperThreshold) {
        b = 0.9;
    } else {
        b = 0.2 + 0.7 * (distance - lowerThreshold) / (upperThreshold - lowerThreshold);
    }
    
    UIColor *c = [UIColor colorWithHue:0.3 saturation:1.0f lightness:1-b alpha:1.0f];
    
    return c;
}
@end
