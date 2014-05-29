//
//  ZonesTableViewController.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/24/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "ZonesTableViewController.h"
#import "FRDStravaClient+Activity.h"
#import "ZoneTableViewCell.h"
#import "ActivityHelper.h"


@interface ZonesTableViewController () <JBBarChartViewDataSource, JBBarChartViewDelegate>

@property (nonatomic, strong) NSArray *zones;

@end

@implementation ZonesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[FRDStravaClient sharedInstance] fetchZonesForActivity:self.activityId
                                                    success:^(NSArray *zones) {
                                                        self.zones = zones;
                                                        [self.tableView reloadData];
                                                    }
                                                    failure:^(NSError *error) {
                                                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                     message:error.localizedDescription
                                                                                                    delegate:nil
                                                                                           cancelButtonTitle:@"Ok"
                                                                                           otherButtonTitles:nil];
                                                        [av show];
                                                    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.zones count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZoneTableViewCell *cell = (ZoneTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ZoneCell"
                                                                                   forIndexPath:indexPath];
    
    StravaActivityZone *zone = self.zones[indexPath.row];
    
    __block NSString *str = @"";
    
    [zone.distributionBuckets enumerateObjectsUsingBlock:^(StravaActivityZoneDistributionBucket *bucket, NSUInteger idx, BOOL *stop) {
        str = [str stringByAppendingFormat:@"min %d max %d time %d", (int)bucket.min, (int)bucket.max, (int)bucket.time];
    }];
    
    cell.zoneLabel.text = zone.type == kActivityZoneTypePower ? @"Power" : @"Heart Rate";
    cell.chartView.delegate = self;
    cell.chartView.dataSource = self;
    [cell.chartView reloadData];
    return cell;
}


#pragma mark - JBBarChartViewDataSource

-(StravaActivityZone *) zoneForChart:(JBBarChartView *)barChartView
{
    CGRect chartFrame = [barChartView convertRect:barChartView.bounds toView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:chartFrame.origin];
    
    StravaActivityZone *zone = self.zones[indexPath.row];
    
    return zone;
}

- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    StravaActivityZone *zone = [self zoneForChart:barChartView];
    
    return [zone.distributionBuckets count];
}

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSUInteger)index
{
    StravaActivityZone *zone = [self zoneForChart:barChartView];
    
    __block NSTimeInterval maxTime = 0.0f;
    
    [zone.distributionBuckets enumerateObjectsUsingBlock:^(StravaActivityZoneDistributionBucket *obj, NSUInteger idx, BOOL *stop) {
        maxTime = MAX(maxTime, obj.time);
    }];
    
    StravaActivityZoneDistributionBucket *bucket = zone.distributionBuckets[index];

    NSTimeInterval t = bucket.time;
    if (maxTime > 0)
        return t * CGRectGetHeight(barChartView.frame) / maxTime;
    return 0.0f;
}

- (UIColor *)barChartView:(JBBarChartView *)barChartView colorForBarViewAtIndex:(NSUInteger)index
{
    StravaActivityZone *zone = [self zoneForChart:barChartView];
    
    if (zone.type == kActivityZoneTypeHeartRate) {
        StravaActivityZoneDistributionBucket *bucket = zone.distributionBuckets[index];
        
        return [ActivityHelper colorForHeartRate:bucket.max];
    }
    return [UIColor blueColor];
}

@end
