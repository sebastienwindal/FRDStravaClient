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

@interface SegmentExplorerViewController () <UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate>

@property (nonatomic, strong) NSArray *segments;
@property (weak, nonatomic) IBOutlet UITableView *segmentsTableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation SegmentExplorerViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.segmentsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
	
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(39.8373177,2.8104037), 10000, 10000);
	[self.mapView setRegion:region];
}

- (void)clearSegments
{
	[self.mapView removeOverlays:self.mapView.overlays];
	
	NSMutableArray *indexes = [NSMutableArray array];
    for(int i=0; i<[self.segments count]; i++)
    {
        [indexes addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
	
	self.segments = nil;
	
	[self.segmentsTableView deleteRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)loadSegments
{
	[self showSpinner];
	
	[self clearSegments];
	
	[[FRDStravaClient sharedInstance] fetchSegmentsWithRegion:self.mapView.region activityType:kActivityTypeRide minCat:0 maxCat:0 success:^(NSArray *segments) {

		[self hideSpinner];
		self.segments = segments;
		[self.segmentsTableView reloadData];
		[self plotAllSegments];
		
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

- (void)plotSegment:(StravaSegment *)segment
{	
	MKPolyline *segmentOverlay = [StravaMap decodePolylineToMKPolyline:segment.points];
    [self.mapView addOverlay:segmentOverlay];
}

- (void)plotAllSegments
{
	for (StravaSegment *segment in self.segments)
	{
		[self plotSegment:segment];
	}
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

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
	[self loadSegments];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    
	polylineView.strokeColor = [UIColor redColor];
	polylineView.lineWidth = 5.0;
    
    return polylineView;
}


@end
