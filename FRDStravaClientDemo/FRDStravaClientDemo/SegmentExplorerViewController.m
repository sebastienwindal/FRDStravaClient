//
//  SegmentExplorerViewController.m
//  FRDStravaClientDemo
//
//  Created by Matt Price on 26/08/2014.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "SegmentExplorerViewController.h"
#import "FRDStravaClientImports.h"
#import <MapKit/MapKit.h>

NSString * const CELL_IDENTIFIER = @"segmentCell";

@interface SegmentExplorerViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *segments;
@property (weak, nonatomic) IBOutlet UITableView *segmentsTableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation SegmentExplorerViewController


- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.segmentsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
	
	[self showSpinner];
	
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(53.315044, -1.8052778), 5000, 5000);
	
	[self.mapView setRegion:region];
	
	[[FRDStravaClient sharedInstance] fetchSegmentsWithRegion:region activityType:kActivityTypeRide minCat:0 maxCat:0 success:^(NSArray *segments) {
		[self hideSpinner];
		self.segments = segments;
		[self.segmentsTableView reloadData];
		
	} failure:^(NSError *error) {
		
		[self hideSpinner];
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"FAIL"
													 message:error.localizedDescription
													delegate:nil
										   cancelButtonTitle:@"Close" otherButtonTitles: nil];
		[av show];
	}];
}

- (void)showSpinner
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = activityItem;
}

- (void)hideSpinner
{
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_segments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
	
	StravaSegment *segment = self.segments[indexPath.row];
	cell.textLabel.text = segment.name;
	
	return cell;
}

@end
