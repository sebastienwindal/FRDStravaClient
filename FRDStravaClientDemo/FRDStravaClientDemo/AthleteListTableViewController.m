//
//  AthleteListTableViewController.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/17/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "AthleteListTableViewController.h"
#import "FRDStravaClient+Athlete.h"

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AthleteCell" forIndexPath:indexPath];
    
    StravaAthlete *athlete = self.athletes[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", athlete.firstName, athlete.lastName];
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
