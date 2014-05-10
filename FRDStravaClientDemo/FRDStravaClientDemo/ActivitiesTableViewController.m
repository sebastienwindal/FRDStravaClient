//
//  ActivitiesTableViewController.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/30/14.
//

#import "ActivitiesTableViewController.h"
#import "FRDStravaClient+Activity.h"
#import "ActivityTableViewCell.h"
#import <MapKit/MapKit.h>
#import "ActivityHelper.h"
#import "IconHelper.h"
#import "UIImageView+WebCache.h"
#import "ActivityDetailsViewController.h"
#import "StravaActivity.h"

@interface ActivitiesTableViewController () <MKMapViewDelegate>

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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Miserable failure"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"Close"
                                                  otherButtonTitles:nil];
        [alertView show];
        [self showMoreButton];
    };
    
    if (self.showAthleteActivitiesOnly) {
        [[FRDStravaClient sharedInstance] fetchActivitiesForCurrentUser:5
                                                              pageIndex:self.pageIndex
                                                                success:successBlock
                                                                failure:failureBlock];
    } else {
        [[FRDStravaClient sharedInstance] fetchFriendActivities:5
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
    cell.mapView.userInteractionEnabled = NO;
    cell.mapView.delegate = self;
    
    NSMutableString *durationStr= [NSMutableString new];
    int hours = (int)floorf(activity.movingTime / 3600);
    int minutes = (activity.movingTime - hours * 3600)/60.0f;
    
    [durationStr appendFormat:@"%dh%02d", hours, minutes];
    cell.typeColorView.backgroundColor = [ActivityHelper colorForActivityType:activity.type];
    cell.durationLabel.text = durationStr;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.1fmi", activity.distance / 1609.34];
    [ActivityHelper makeLabel:cell.activityIconLabel activityTypeIconForActivity:activity];
    
    [IconHelper makeThisLabel:cell.chevronIconLabel anIcon:ICON_CHEVRON_RIGHT ofSize:24.0f];
    
    [self configureCellMap:cell.mapView forActivity:activity];
    
    cell.usernameLabel.text = [NSString stringWithFormat:@"%@ %@", activity.athlete.firstName, activity.athlete.lastName];
    cell.usernameLabel.hidden = self.showAthleteActivitiesOnly;
    [cell.detailViewHeightConstraint setConstant:self.showAthleteActivitiesOnly ? 75 : 100];
    
    [cell.userImageView setImageWithURL:[NSURL URLWithString:activity.athlete.profileMediumURL]];
    cell.userImageView.layer.cornerRadius = CGRectGetWidth(cell.userImageView.frame)/2.0f;
    cell.userImageView.clipsToBounds = YES;
    cell.userImageView.hidden = self.showAthleteActivitiesOnly;
    cell.userWidthConstraint.constant = self.showAthleteActivitiesOnly ? 0.0f : 42.0f;
    return cell;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView
            viewForOverlay:(id <MKOverlay>)overlay
{
    CGRect frame = [mapView convertRect:mapView.bounds toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:frame.origin];
    
    StravaActivity *activity = self.activities[indexPath.row];
    
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [ActivityHelper colorForActivityType:activity.type];
    
    polylineView.lineWidth = 5.0;
    
    return polylineView;
}


-(void) configureCellMap:(MKMapView *)mapView forActivity:(StravaActivity *)activity
{
    [mapView removeOverlays:mapView.overlays];
    
    NSArray *arr = [StravaMap decodePolyline:activity.map.summaryPolyline];
    
    if ([arr count] > 0) {
        
        CLLocationDegrees minLat = 1000.0f;
        CLLocationDegrees maxLat = -1000.0f;
        CLLocationDegrees minLon = 1000.0f;
        CLLocationDegrees maxLon = -1000.0f;

        CLLocationCoordinate2D coordinates[[arr count]];
        int i=0;
        for (NSValue *val in arr) {
            coordinates[i] = [val MKCoordinateValue];
            minLat = MIN(minLat, coordinates[i].latitude);
            minLon = MIN(minLon, coordinates[i].longitude);
            maxLat = MAX(maxLat, coordinates[i].latitude);
            maxLon = MAX(maxLon, coordinates[i].longitude);
            i++;
        }
        
        MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:[arr count]];
        [mapView addOverlay:polyLine];
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLat+maxLat)/2.0f, (minLon+maxLon)/2.0f);
        MKCoordinateSpan span = MKCoordinateSpanMake(1.5*(maxLat-minLat), 1.5*(maxLon-minLon));
        mapView.region = MKCoordinateRegionMake(center, span);
    }
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
