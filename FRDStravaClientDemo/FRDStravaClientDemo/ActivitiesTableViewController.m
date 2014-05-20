//
//  ActivitiesTableViewController.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/30/14.
//

#import "ActivitiesTableViewController.h"
#import "FRDStravaClient+Activity.h"
#import "FRDStravaClient+Club.h"
#import "ActivityTableViewCell.h"
#import "ActivityHelper.h"
#import "IconHelper.h"
#import "UIImageView+WebCache.h"
#import "ActivityDetailsViewController.h"
#import "StravaActivity.h"

@interface ActivitiesTableViewController ()

@property (nonatomic, strong) NSArray *activities;
@property (nonatomic) int pageIndex;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation ActivitiesTableViewController

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
    
    self.activities = @[];
    self.pageIndex = 1;
    [self fetchNextPage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSDateFormatter *) dateFormatter
{
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    }
    return _dateFormatter;
}

-(void) showMoreButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"more"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(moreAction:)];
}

-(void) showSpinner
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = activityItem;
}


-(void) fetchNextPage
{
    [self showSpinner];
    
    void(^successBlock)(NSArray *activities) = ^(NSArray *activities) {
        self.pageIndex++;
        self.activities = [self.activities arrayByAddingObjectsFromArray:activities];
        [self.tableView reloadData];
        NSInteger lastRow = self.activities.count-1;
        if (lastRow > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionMiddle
                                          animated:YES];
        }
        [self showMoreButton];
    };
    
    void(^failureBlock)(NSError *error) = ^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Miserable failure (not you, the call)"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"Close"
                                                  otherButtonTitles:nil];
        [alertView show];
        [self showMoreButton];
    };
    
    if (self.mode == ActivitiesListModeCurrentAthlete) {
        [[FRDStravaClient sharedInstance] fetchActivitiesForCurrentUser:5
                                                              pageIndex:self.pageIndex
                                                                success:successBlock
                                                                failure:failureBlock];
    } else if (self.mode == ActivitiesListModeFeed) {
        [[FRDStravaClient sharedInstance] fetchFriendActivities:5
                                                      pageIndex:self.pageIndex
                                                        success:successBlock
                                                        failure:failureBlock];
    } else if (self.mode == ActivitiesListModeClub) {
        [[FRDStravaClient sharedInstance] fetchActivitiesOfClub:self.clubId
                                                       pageSize:5
                                                      pageIndex:self.pageIndex
                                                        success:successBlock
                                                        failure:failureBlock];
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.activities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"
                                                                  forIndexPath:indexPath];
    
    StravaActivity *activity = self.activities[indexPath.row];
    
    cell.nameLabel.text = activity.name;
    cell.locationLabel.text = activity.locationCity;
    cell.dateLabel.text = [self.dateFormatter stringFromDate:activity.startDate];

    
    NSMutableString *durationStr= [NSMutableString new];
    int hours = (int)floorf(activity.movingTime / 3600);
    int minutes = (activity.movingTime - hours * 3600)/60.0f;
    
    [durationStr appendFormat:@"%dh%02d", hours, minutes];
    cell.typeColorView.backgroundColor = [ActivityHelper colorForActivityType:activity.type];
    cell.typeColorView.layer.cornerRadius = CGRectGetWidth(cell.typeColorView.frame) / 2.0f;
    cell.durationLabel.text = durationStr;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.1fmi", activity.distance / 1609.34];
    [ActivityHelper makeLabel:cell.activityIconLabel activityTypeIconForActivity:activity];
    
    [IconHelper makeThisLabel:cell.chevronIconLabel anIcon:ICON_CHEVRON_RIGHT ofSize:24.0f];
    
    cell.usernameLabel.text = [NSString stringWithFormat:@"%@ %@", activity.athlete.firstName, activity.athlete.lastName];
    cell.usernameLabel.hidden = self.mode == ActivitiesListModeCurrentAthlete;
    [cell.detailViewHeightConstraint setConstant:(self.mode == ActivitiesListModeCurrentAthlete) ? 75 : 100];
    
    [cell.userImageView setImageWithURL:[NSURL URLWithString:activity.athlete.profileMediumURL]];
    cell.userImageView.layer.cornerRadius = CGRectGetWidth(cell.userImageView.frame)/2.0f;
    cell.userImageView.clipsToBounds = YES;
    cell.userImageView.hidden = self.mode == ActivitiesListModeCurrentAthlete;
    cell.userWidthConstraint.constant = (self.mode == ActivitiesListModeCurrentAthlete) ? 0.0f : 42.0f;
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.mode == ActivitiesListModeCurrentAthlete) ? 90.0f : 110.0f;
}

- (IBAction)moreAction:(id)sender
{
    [self fetchNextPage];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setActivityId:)]) {
        
        // find the indexpath of the cell (sender)
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];

        StravaActivity *activity = self.activities[indexPath.row];
        
        [segue.destinationViewController setActivityId:activity.id];
        
    }
}

@end
