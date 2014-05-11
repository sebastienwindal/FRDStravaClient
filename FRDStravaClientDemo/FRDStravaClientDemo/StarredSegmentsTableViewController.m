//
//  StarredSegmentsTableViewController.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/9/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "StarredSegmentsTableViewController.h"
#import "FRDStravaClient+Segment.h"
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
    
    [[FRDStravaClient sharedInstance] fetchStarredSegmentsForCurrentUserWithSuccess:^(NSArray *segments) {
        self.segments = segments;
        [self.tableView reloadData];
    }
                                                                            failure:^(NSError *error) {
                                                                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"FAILED" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
                                                                                [alertView show];
                                                                            }];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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
