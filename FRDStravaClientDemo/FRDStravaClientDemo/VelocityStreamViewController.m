//
//  VelocityStreamViewController.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/8/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "VelocityStreamViewController.h"
#import "JBBarChartView.h"
#import "ActivityHelper.h"
#import "FRDStravaClient+ActivityStream.h"
#import <MapKit/MapKit.h>


@interface VelocityStreamViewController () <JBBarChartViewDataSource, JBBarChartViewDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet JBBarChartView *speedBarChartView;
@property (nonatomic, strong) NSMutableDictionary *speedRepartition;
@property (nonatomic) CGFloat minSpeed;
@property (nonatomic) CGFloat maxSpeed;
@property (nonatomic) CGFloat speedRangeWidth;
@property (nonatomic) int total;

@property (weak, nonatomic) IBOutlet UILabel *selectedBarValueLabel;

@property (nonatomic, strong) NSMapTable *polylineIndex;

@property (nonatomic, strong) StravaStream *dataStream;

@end

@implementation VelocityStreamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    self.speedRangeWidth = 2/3.6; // so the histogram width is 2 km/h
    self.speedBarChartView.dataSource = self;
    self.speedBarChartView.delegate = self;
    
    [[FRDStravaClient sharedInstance] fetchActivityStreamForActivityId:self.activityId
                                                            resolution:kStravaStreamResolutionMedium
                                                             dataTypes:@[ @(kStravaStreamTypeVelocitySmooth), @(kStravaStreamTypeLatLng) ]
                                                               success:^(NSArray *streams) {
                                                                   StravaStream *locationStream;
                                                                   StravaStream *velocityStream;
                                                                   for (StravaStream *stream in streams) {

                                                                       if (stream.type == kStravaStreamTypeVelocitySmooth) {
                                                                           velocityStream = stream;

                                                                       } else if (stream.type == kStravaStreamTypeLatLng) {
                                                                           locationStream = stream;
                                                                       }
                                                                   }
                                                                   
                                                                   // streams need to be processed in this order
                                                                   // so the overlays added to the map can be added
                                                                   // with the right color.
                                                                   [self processSpeedStream:velocityStream];
                                                                   [self processLatLngStream:locationStream];
                                                               }
                                                               failure:^(NSError *error) {
                                                                   
                                                               }];

    [self didUnselectBarChartView:self.speedBarChartView];
}

-(NSMutableDictionary *) speedRepartition
{
    if (_speedRepartition == nil) {
        _speedRepartition = [[NSMutableDictionary alloc] init];
    }
    return _speedRepartition;
}

-(NSMapTable *) polylineIndex
{
    if (_polylineIndex == nil) {
        _polylineIndex = [[NSMapTable alloc] init];
    }
    return _polylineIndex;
}

-(void) processSpeedStream:(StravaStream *)stream
{
    self.dataStream = stream;
    
    self.minSpeed = 10000;
    self.maxSpeed = 0;
    self.total = 0;
    
    [stream.data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        int speed = (int) floorf([obj floatValue] / self.speedRangeWidth);
        self.maxSpeed = MAX(self.maxSpeed, speed);
        self.minSpeed = MIN(self.minSpeed, speed);
        
        self.speedRepartition[@(speed)] = @([self.speedRepartition[@(speed)] intValue] + 1);
        self.total ++;
    }];
    
    [self.speedBarChartView reloadData];
    [self.mapView.overlays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj setNeedsDisplayInMapRect:MKMapRectMake(0, 0, 320, 200)];
    }];
}

-(void) processLatLngStream:(StravaStream *)stream
{
    #define UNSET_DEGREES 1000.0f;
    CLLocationDegrees minLat = UNSET_DEGREES;
    CLLocationDegrees maxLat = -UNSET_DEGREES;
    CLLocationDegrees minLon = UNSET_DEGREES;
    CLLocationDegrees maxLon = -UNSET_DEGREES;
    
    CLLocationCoordinate2D allCoordinates[stream.data.count];
    
    for (int i=1; i<[stream.data count]; i++) {
        NSArray *coordArr1 = stream.data[i-1];
        NSArray *coordArr2 = stream.data[i];
        
        CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake([coordArr1[0] doubleValue], [coordArr1[1] doubleValue]);
        CLLocationCoordinate2D coord2 = CLLocationCoordinate2DMake([coordArr2[0] doubleValue], [coordArr2[1] doubleValue]);
        
        minLat = MIN(minLat,coord1.latitude);
        minLon = MIN(minLon,coord1.longitude);
        maxLat = MAX(maxLat,coord1.latitude);
        maxLon = MAX(maxLon,coord1.longitude);
        
        CLLocationCoordinate2D coordinates[] = { coord1, coord2 };
        allCoordinates[i-1] = coord1;
        if (i == stream.data.count-1) {
            // last one
            allCoordinates[i] = coord2;
        }
        
        MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:2];
        [self.polylineIndex setObject:@(i-1) forKey:polyLine];
    }
    
    
    MKPolyline *outerOverlay = [MKPolyline polylineWithCoordinates:allCoordinates count:stream.data.count];
    [self.mapView addOverlay:outerOverlay];
    
    for (MKPolyline *polyline in self.polylineIndex.keyEnumerator) {
        // we want that to be added on top of the outerOverlay.
        [self.mapView addOverlay:polyline];
    }
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLat+maxLat)/2.0f, (minLon+maxLon)/2.0f);
    MKCoordinateSpan span = MKCoordinateSpanMake(1.5*(maxLat-minLat), 1.5*(maxLon-minLon));
    
    self.mapView.region = MKCoordinateRegionMake(center, span);
}

- (MKOverlayView *)mapView:(MKMapView *)mapView
            viewForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    
    NSNumber *index = [self.polylineIndex objectForKey:overlay];
    if(index) {
        NSNumber *velocity = self.dataStream.data[index.intValue];
        polylineView.strokeColor = [ActivityHelper colorForSpeed:[velocity floatValue]];
        polylineView.lineWidth = 6.0;
    } else {
        // this is the outside overlay.
        polylineView.strokeColor = [UIColor blackColor];
        polylineView.lineWidth = 9.0;
    }
    
    return polylineView;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    return self.maxSpeed - self.minSpeed + 1;
}

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSUInteger)index
{
    unsigned long speed = self.minSpeed + index;
    int val = [self.speedRepartition[@(speed)] intValue];
    return val;
}

- (NSUInteger)barPaddingForBarChartView:(JBBarChartView *)barChartView
{
    return 1;
}

-(UIView *) barChartView:(JBBarChartView *)barChartView
          barViewAtIndex:(NSUInteger)index
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,1,1)];
    
    v.backgroundColor = [ActivityHelper colorForSpeed:(self.minSpeed + index) * self.speedRangeWidth];
    
    return v;
}

- (void)barChartView:(JBBarChartView *)barChartView didSelectBarAtIndex:(NSUInteger)index
{
    CGFloat speed1 = self.minSpeed + index * self.speedRangeWidth;
    CGFloat speed2 = speed1 + self.speedRangeWidth;
    CGFloat percent = 100.0f * [self.speedRepartition[@(index)] intValue] / self.total;
    
    NSString *str = [NSString stringWithFormat:@"%d-%dkm/h %.1f%%", (int)floorf(speed1*3.6), (int)floorf(speed2*3.6), percent];
    
    self.selectedBarValueLabel.text = str;
}

-(void) didUnselectBarChartView:(JBBarChartView *)barChartView
{
    self.selectedBarValueLabel.text = @"Select bar";
}

@end
