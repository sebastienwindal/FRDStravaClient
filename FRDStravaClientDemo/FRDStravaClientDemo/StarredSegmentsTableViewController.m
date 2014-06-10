//
//  StarredSegmentsTableViewController.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/9/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "StarredSegmentsTableViewController.h"
#import "FRDStravaClientImports.h"
#import "SegmentEffortsTableViewController.h"

@interface StarredSegmentsTableViewController ()

@property (nonatomic, strong) NSArray *segments;

@end

@implementation StarredSegmentsTableViewController

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
    
    [self showSpinner];
    
    [[FRDStravaClient sharedInstance] fetchStarredSegmentsForCurrentAthleteWithSuccess:^(NSArray *segments) {
        self.segments = segments;
        [self.tableView reloadData];
        [self hideSpinner];
    }
                                                                            failure:^(NSError *error) {
                                                                                [self hideSpinner];
                                                                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"FAILED" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
                                                                                [alertView show];
                                                                            }];
    

}

-(void) showSpinner
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = activityItem;
}

-(void) hideSpinner
{
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.segments count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SegmentCell"];

    StravaSegment *segment = self.segments[indexPath.row];
    
    cell.textLabel.text = segment.name;
    
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    StravaSegment *segment = self.segments[indexPath.row];
    
    [segue.destinationViewController setSegmentId:segment.id];
}


@end
