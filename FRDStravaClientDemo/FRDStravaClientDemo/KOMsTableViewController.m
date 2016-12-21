//
//  KOMsTableViewController.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/22/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "KOMsTableViewController.h"

#import "FRDStravaClientImports.h"

@interface KOMsTableViewController ()

@property (nonatomic, strong) NSArray *koms;
@property (nonatomic) NSInteger pageIndex;

@end

@implementation KOMsTableViewController

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
    self.pageIndex = 1;
    self.koms = @[];
    [self fetchNextPage];
}

-(void) fetchNextPage
{
    [self showSpinner];
    
    [[FRDStravaClient sharedInstance] fetchKOMsForAthlete:self.athleteId
                                                 pageSize:5
                                                pageIndex:self.pageIndex
                                                  success:^(NSArray *efforts) {
                                                      self.pageIndex ++;
                                                      [self showMoreButton];
                                                      self.koms = [self.koms arrayByAddingObjectsFromArray:efforts];
                                                      [self.tableView reloadData];
                                                  }
                                                  failure:^(NSError *error) {
                                                      [self showMoreButton];
                                                      UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"FAILED"
                                                  message:error.localizedDescription
                                                                                                  delegate:nil
                                                                                         cancelButtonTitle:@"Close"
                                                                                         otherButtonTitles:nil];
                                                      [av show];
                                                  }];
}

-(void) showMoreButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"more"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(fetchNextPage)];
}

-(void) showSpinner
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = activityItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.koms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EfforCell" forIndexPath:indexPath];
    
    StravaSegmentEffort *effort = self.koms[indexPath.row];
    
    cell.textLabel.text = effort.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %dm %dsec", effort.startDate, (int)effort.distance, (int)effort.elapsedTime];
    
    return cell;
}


@end
