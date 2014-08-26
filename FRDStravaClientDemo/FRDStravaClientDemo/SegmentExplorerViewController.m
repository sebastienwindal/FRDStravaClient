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

@interface SegmentAnnotation : NSObject <MKAnnotation>

- (instancetype)initWithSegment:(StravaSegment *)segment;

@end

@implementation SegmentAnnotation

@synthesize coordinate, title;

- (instancetype)initWithSegment:(StravaSegment *)segment
{
    self = [super init];
	
    if (self)
	{
		coordinate = segment.startLocation;
		title = segment.name;
    }
	
    return self;
}

@end


@interface SegmentStartAnnotation : SegmentAnnotation
@end

@implementation SegmentStartAnnotation

@synthesize subtitle;

- (instancetype)initWithSegment:(StravaSegment *)segment
{
    self = [super initWithSegment:segment];
	
    if (self)
	{
		subtitle = @"Start";
    }
	
    return self;
}

@end


@interface SegmentEndAnnotation : SegmentAnnotation
@end

@implementation SegmentEndAnnotation

@synthesize subtitle;

- (instancetype)initWithSegment:(StravaSegment *)segment
{
    self = [super initWithSegment:segment];
	
    if (self)
	{
		subtitle = @"End";
    }
	
    return self;
}

@end


@interface SegmentAnnotationView : MKAnnotationView

- (instancetype)initWithAnnotation:(SegmentAnnotation *)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@end

@implementation SegmentAnnotationView

- (instancetype)initWithAnnotation:(SegmentAnnotation *)annotation reuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
	if (self)
	{
        self.canShowCallout = YES;
		self.enabled = YES;
		self.image = [annotation isKindOfClass:[SegmentStartAnnotation class]] ? [UIImage imageNamed:@"segExpStart"] : [UIImage imageNamed:@"segExpFinish"];
    }
	
    return self;
}

@end


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
	[self.mapView removeAnnotations:self.mapView.annotations];
	
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

- (void)plotSegmentOverlay:(StravaSegment *)segment
{
	MKPolyline *segmentOverlay = [StravaMap decodePolylineToMKPolyline:segment.points];
    [self.mapView addOverlay:segmentOverlay];
}

- (void)plotSegmentAnnotations:(StravaSegment *)segment
{
	[self.mapView addAnnotation:[[SegmentStartAnnotation alloc] initWithSegment:segment]];
	[self.mapView addAnnotation:[[SegmentEndAnnotation alloc] initWithSegment:segment]];
}

- (void)plotAllSegments
{
	for (StravaSegment *segment in self.segments)
	{
		[self plotSegmentOverlay:segment];
		[self plotSegmentAnnotations:segment];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	StravaSegment *segment = self.segments[indexPath.row];
	
	for (SegmentAnnotation *annotation in self.mapView.annotations)
	{
		if ([annotation isKindOfClass:[SegmentStartAnnotation class]])
		{
			if ([annotation.title isEqualToString:segment.name])
			{
				[self.mapView selectAnnotation:annotation animated:YES];
			}
		}
	}
	
	[self.segmentsTableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	static NSString *startID = @"StartAnnotation";
	static NSString *endID = @"EndAnnotation";
	
	BOOL isStart = [annotation isKindOfClass:[SegmentStartAnnotation class]] ? YES : NO;
	
	NSString *identifier = isStart ? startID : endID;
	
	SegmentAnnotationView *annotationView = (SegmentAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
	
	if (annotationView == nil)
	{
		annotationView = [[SegmentAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
	}
	else
	{
		annotationView.annotation = annotation;
	}
	
	return annotationView;
}

@end
