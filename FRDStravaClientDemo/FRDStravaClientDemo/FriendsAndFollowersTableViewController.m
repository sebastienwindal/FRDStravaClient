//
//  FriendsAndFollowersTableViewController.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/17/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "FriendsAndFollowersTableViewController.h"
#import "AthleteListTableViewController.h"

@interface FriendsAndFollowersTableViewController ()

@end

@implementation FriendsAndFollowersTableViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FriendsSegue"]) {
        [segue.destinationViewController setMode:AthleteListModeFriends];
    } else if ([segue.identifier isEqualToString:@"FollowersSegue"]) {
        [segue.destinationViewController setMode:AthleteListModeFollowers];
    }
}


@end
