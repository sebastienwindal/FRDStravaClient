//
//  AthleteListTableViewController.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/17/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "AthleteListTableViewController.h"
#import "FRDStravaClient+Athlete.h"
#import "AthleteTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AthleteDetaislViewController.h"
#import "AthleteHeadShotsCollectionViewController.h"

@interface AthleteListTableViewController ()

@property (nonatomic, strong) NSArray *athletes;
@property (nonatomic) int pageIndex;

@end

@implementation AthleteListTableViewController

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
    
    [self fetchNextPage];
}

-(NSArray *) athletes
{
    if (_athletes == nil) {
        _athletes = @[];
    }
    return _athletes;
}


-(void) fetchNextPage
{
    [self showSpinner];
    
    void(^successBlock)(NSArray *athletes) = ^(NSArray *athletes) {
        self.athletes = [self.athletes arrayByAddingObjectsFromArray:athletes];
        [self.tableView reloadData];
        
        [self showMoreButton];
        self.pageIndex++;
    };
    
    void(^failureBlock)(NSError *error) = ^(NSError *error) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                     message:error.localizedDescription
                                                    delegate:nil
                                           cancelButtonTitle:@"Close"
                                           otherButtonTitles: nil];
        [av show];
        
        [self showMoreButton];
    };
    
    if (self.mode == AthleteListModeFollowers) {
        [[FRDStravaClient sharedInstance] fetchCurrentAthleteFollowersWithPageSize:10
                                                                         pageIndex:self.pageIndex
                                                                           success:successBlock
                                                                           failure:failureBlock];
    } else if (self.mode == AthleteListModeFriends) {
        [[FRDStravaClient sharedInstance] fetchCurrentAthleteFriendsWithPageSize:10
                                                                       pageIndex:self.pageIndex
                                                                         success:successBlock
                                                                         failure:failureBlock];
    }
}

-(void) showMoreButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"more"
                                                                              style:UIBarButtonItemStyleBordered
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
    return [self.athletes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AthleteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AthleteCell" forIndexPath:indexPath];
    
    StravaAthlete *athlete = self.athletes[indexPath.row];
    
    cell.athleteNameLabel.text = [NSString stringWithFormat:@"%@ %@", athlete.firstName, athlete.lastName];
    cell.locationLabel.text = [NSString stringWithFormat:@"%@ %@ %@", athlete.city, athlete.state, athlete.country];
    [cell.athleteImageView setImageWithURL:[NSURL URLWithString:athlete.profileMediumURL]];
    
    cell.athleteImageView.layer.cornerRadius = CGRectGetWidth(cell.athleteImageView.bounds)/2.0f;
    cell.athleteImageView.clipsToBounds = YES;
    
    return cell;
}



#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setAthleteId:)]) {
        NSIndexPath *indexPath = indexPath = [self.tableView indexPathForCell:sender];
        StravaAthlete *athlete =  self.athletes[indexPath.row];
        [segue.destinationViewController setAthleteId:athlete.id];
    } else {
        CGRect buttonFrame = [sender convertRect:((UIButton *)sender).bounds toView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonFrame.origin];
        
        StravaAthlete *athlete =  self.athletes[indexPath.row];
        
        UINavigationController *navVC = segue.destinationViewController;
        AthleteHeadShotsCollectionViewController *vc = navVC.childViewControllers.firstObject;
        
        vc.athleteId = athlete.id;
        vc.headShotListType = HeadShotListTypeCommonFollowers;
    }
}


@end
