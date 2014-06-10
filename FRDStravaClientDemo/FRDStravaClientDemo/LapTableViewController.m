//
//  LapTableViewController.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/20/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "LapTableViewController.h"
#import "FRDStravaClientImports.h"

@interface LapTableViewController ()

@property (nonatomic, strong) NSArray *laps;

@end

@implementation LapTableViewController

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
    
    [[FRDStravaClient sharedInstance] fetchLapsForActivity:self.activityId
                                                   success:^(NSArray *laps) {
                                                       self.laps = laps;
                                                       [self.tableView reloadData];
                                                   }
                                                   failure:^(NSError *error) {
                                                       UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"FAILED" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
                                                       [av show];
                                                   }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.laps count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LapCell" forIndexPath:indexPath];
    
    StravaActivityLap *lap = self.laps[indexPath.row];
    
    cell.textLabel.text = lap.name;
    
    NSString *details = [NSString stringWithFormat:@"%.1fhrs %.1fmph %dbpm", lap.movingTime/3600.0f, lap.averageSpeed*3.6/1.6, (int)lap.averageHeartrate];
    cell.detailTextLabel.text = details;
    
    return cell;
}



@end
