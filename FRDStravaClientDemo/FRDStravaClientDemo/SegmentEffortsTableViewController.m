//
//  SegmentEffortsTableViewController.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/10/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "SegmentEffortsTableViewController.h"
#import "FRDStravaClient+Segment.h"

@interface SegmentEffortsTableViewController ()

@property (nonatomic, strong) NSArray *efforts;

@end

@implementation SegmentEffortsTableViewController

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
    
    [[FRDStravaClient sharedInstance] fetchSegmentEffortsForSegment:self.segmentId
                                                           pageSize:10
                                                          pageIndex:1
                                                            success:^(NSArray *efforts) {
                                                                self.efforts = efforts;
                                                                
                                                                [self.tableView reloadData];
                                                            }
                                                            failure:^(NSError *error) {
                                                                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"FAIL"
                                                            message:error.localizedDescription
                                                            delegate:nil
                                                                                                   cancelButtonTitle:@"Close" otherButtonTitles: nil];
                                                                [av show];
                                                            }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.efforts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SegmentEffortCell"
                                                            forIndexPath:indexPath];
    
    StravaSegmentEffort *effort = self.efforts[indexPath.row];
    cell.textLabel.text = effort.name;
    
    return cell;
}


@end
