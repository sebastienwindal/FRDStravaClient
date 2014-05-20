//
//  ClubsTableViewController.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/17/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "ClubsTableViewController.h"
#import "FRDStravaClient+Club.h"
#import "UIImageView+WebCache.h"
#import "ClubDetailsTableViewController.h"


@interface ClubsTableViewController ()

@property (nonatomic, strong) NSArray *clubs;

@end

@implementation ClubsTableViewController

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
    
    [[FRDStravaClient sharedInstance] fetchClubsForCurrentAthleteWithSuccess:^(NSArray *clubs) {
        self.clubs = clubs;
        [self.tableView reloadData];
        }
                                                                     failure:^(NSError *error) {
                                                                         [[[UIAlertView alloc] initWithTitle:@"Failed" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
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
    return [self.clubs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClubCell" forIndexPath:indexPath];
    
    StravaClub *club = self.clubs[indexPath.row];
    
    cell.textLabel.text = club.name;
    [cell.imageView setImageWithURL:[NSURL URLWithString:club.profileMedium]];

    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    StravaClub *club = self.clubs[indexPath.row];
    
    [segue.destinationViewController setClubId:club.id];
}

@end
