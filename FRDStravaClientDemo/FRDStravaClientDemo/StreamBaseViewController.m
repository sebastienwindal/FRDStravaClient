//
//  StreamBaseViewController.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/12/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "StreamBaseViewController.h"
#import "StravaStream.h"
#import "FRDStravaClient+ActivityStream.h"

@interface StreamBaseViewController ()

@property (nonatomic, strong) NSMutableDictionary *dataRepartition;
@property (nonatomic) CGFloat minData;
@property (nonatomic) CGFloat maxData;


@property (nonatomic, strong) NSMapTable *polylineIndex;

@property (nonatomic, strong) StravaStream *dataStream;

@property (nonatomic) int total;

@end


@implementation StreamBaseViewController

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
    
    self.barChartView.dataSource = self;
    self.barChartView.delegate = self;
    
    self.mapView.delegate = self;
    
    [self didUnselectBarChartView:self.barChartView];
    
    [self fetchStreams];
}

-(kStravaStreamType) valueStreamType
{
    NSAssert(FALSE, @"StreamBaseViewController is an abstract class, override valueStreamtype");
    return kStravaStreamTypeUnknown;
}

-(CGFloat) dataRangeWidth
{
    NSAssert(FALSE, @"StreamBaseViewController is an abstract class, override dataRangeWidth");
    return 0.0f;
}

-(void) fetchStreams
{
    [[FRDStravaClient sharedInstance] fetchActivityStreamForActivityId:self.activityId
                                                            resolution:kStravaStreamResolutionMedium
                                                             dataTypes:@[ @(self.valueStreamType), @(kStravaStreamTypeLatLng) ]
                                                               success:^(NSArray *streams) {
                                                                   StravaStream *locationStream;
                                                                   StravaStream *valueStream;
                                                                   for (StravaStream *stream in streams) {
                                                                       
                                                                       if (stream.type == self.valueStreamType) {
                                                                           valueStream = stream;
                                                                           
                                                                       } else if (stream.type == kStravaStreamTypeLatLng) {
                                                                           locationStream = stream;
                                                                       }
                                                                   }
                                                                   
                                                                   // streams need to be processed in this order
                                                                   // so the overlays added to the map can be added
                                                                   // with the right color.
                                                                   [self processValueStream:valueStream];
                                                                   [self processLatLngStream:locationStream];
                                                               }
                                                               failure:^(NSError *error) {
                                                                   
                                                               }];

}

-(NSMutableDictionary *) dataRepartition
{
    if (_dataRepartition == nil) {
        _dataRepartition = [[NSMutableDictionary alloc] init];
    }
    return _dataRepartition;
}

-(NSMapTable *) polylineIndex
{
    if (_polylineIndex == nil) {
        _polylineIndex = [[NSMapTable alloc] init];
    }
    return _polylineIndex;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    return self.maxData - self.minData + 1;
}


-(UIView *) barChartView:(JBBarChartView *)barChartView
          barViewAtIndex:(NSUInteger)index
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,1,1)];
    
    v.backgroundColor = [self colorForBarAtIndex:index];
    
    return v;
}

-(NSString *)stringForRangeStartingWith:(CGFloat)value1 endingWith:(CGFloat)value percent:(CGFloat)percent
{
    return @"";
}

- (void)barChartView:(JBBarChartView *)barChartView didSelectBarAtIndex:(NSUInteger)index
{
    CGFloat value1 = (self.minData + index) * self.dataRangeWidth;
    CGFloat value2 = value1 + self.dataRangeWidth;
    CGFloat percent = 100.0f * [self.dataRepartition[@(index)] intValue] / self.total;
    
    self.selectedBarValueLabel.text = [self stringForRangeStartingWith:value1 endingWith:value2 percent:percent];
}

-(UIColor *) colorForBarAtIndex:(int)index
{
    return [self colorForValue:(self.minData + index) * self.dataRangeWidth];
}

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSUInteger)index
{
    unsigned long value = self.minData + index;
    int val = [self.dataRepartition[@(value)] intValue];
    return val;
}



-(void) processValueStream:(StravaStream *)stream
{
    self.dataStream = stream;
    
    self.minData = 10000;
    self.maxData = 0;
    self.total = 0;
    
    [stream.data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        int value = (int) floorf([obj floatValue] / self.dataRangeWidth);
        if (value != 0 || ![self ignoreZeroValues]) {
            self.maxData = MAX(self.maxData, value);
            self.minData = MIN(self.minData, value);
            
            self.dataRepartition[@(value)] = @([self.dataRepartition[@(value)] intValue] + 1);
            self.total ++;
        }
    }];
    
    [self.barChartView reloadData];
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
        NSNumber *value = self.dataStream.data[index.intValue];
        polylineView.strokeColor = [self colorForValue:[value floatValue]];
        polylineView.lineWidth = 6.0;
    } else {
        // this is the outside overlay.
        polylineView.strokeColor = [UIColor blackColor];
        polylineView.lineWidth = 9.0;
    }
    
    return polylineView;
}

-(UIColor *) colorForValue:(CGFloat)value
{
    return [UIColor blackColor];
}

-(BOOL) ignoreZeroValues
{
    return NO;
}

- (NSUInteger)barPaddingForBarChartView:(JBBarChartView *)barChartView
{
    return 1;
}


-(void) didUnselectBarChartView:(JBBarChartView *)barChartView
{
    self.selectedBarValueLabel.text = @"Select bar";
}


@end
