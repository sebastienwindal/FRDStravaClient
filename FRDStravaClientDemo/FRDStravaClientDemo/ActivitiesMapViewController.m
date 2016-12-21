//
//  ActivitiesMapViewController.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/1/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "ActivitiesMapViewController.h"
#import "FRDStravaClientImports.h"
#import <MapKit/MapKit.h>
#import "ActivityHelper.h"


@interface ActivitiesMapViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) int pageIndex;
@property (nonatomic, strong) NSMutableDictionary *activityTypeForOverlay;
@property (weak, nonatomic) IBOutlet UILabel *iconListLabel;
@property (nonatomic, strong) NSMutableSet *activityTypes;

@end

@implementation ActivitiesMapViewController
{
    CLLocationDegrees minLat;
    CLLocationDegrees maxLat;
    CLLocationDegrees minLon;
    CLLocationDegrees maxLon;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#define UNSET_DEGREES 1000.0f;

- (void)viewDidLoad
{
    [super viewDidLoad];

    minLat = UNSET_DEGREES;
    maxLat = -UNSET_DEGREES;
    minLon = UNSET_DEGREES;
    maxLon = -UNSET_DEGREES;
    
    self.activityTypeForOverlay = [NSMutableDictionary new];
    self.pageIndex = 1;
    self.iconListLabel.font = [UIFont fontWithName:@"icomoon" size:14.0f];
    [self fetchNextPage];
}

-(void) showMoreButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"more"
                                                                              style:UIBarButtonItemStylePlain
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableSet *) activityTypes
{
    if (_activityTypes == nil) {
        _activityTypes = [[NSMutableSet alloc] init];
    }
    return _activityTypes;
}

-(void) fetchNextPage
{
    [self showSpinner];
    [[FRDStravaClient sharedInstance] fetchActivitiesForCurrentAthleteWithPageSize:10
                                                          pageIndex:self.pageIndex
                                                            success:^(NSArray *activities) {
                                                                self.pageIndex++;
                                              
                                                                [self addPolylineForActivities:activities];
                                                                [self showMoreButton];
                                                            }
                                                            failure:^(NSError *error) {
                                                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Miserable failure"
                                                                                                      message:error.localizedDescription
                                                                                                     delegate:nil
                                                                                            cancelButtonTitle:@"Close"
                                                                                            otherButtonTitles:nil];
                                                                [alertView show];
                                                                [self showMoreButton];
                                                            }];
}


-(void) addPolylineForActivities:(NSArray *)activities
{
    for (StravaActivity *activity in activities) {
    
        NSArray *arr = [StravaMap decodePolyline:activity.map.summaryPolyline];
        
        if ([arr count] > 0) {
            
            CLLocationDegrees activityMinLat = UNSET_DEGREES;
            CLLocationDegrees activityMaxLat = -UNSET_DEGREES;
            CLLocationDegrees activityMinLon = UNSET_DEGREES;
            CLLocationDegrees activityMaxLon = -UNSET_DEGREES;
            
            CLLocationCoordinate2D coordinates[[arr count]];
            int i=0;
            for (NSValue *val in arr) {
                coordinates[i] = [val MKCoordinateValue];
                activityMinLat = MIN(activityMinLat, coordinates[i].latitude);
                activityMinLon = MIN(activityMinLon, coordinates[i].longitude);
                activityMaxLat = MAX(activityMaxLat, coordinates[i].latitude);
                activityMaxLon = MAX(activityMaxLon, coordinates[i].longitude);
                i++;
            }
            
            CLLocationCoordinate2D center = CLLocationCoordinate2DMake((activityMinLat+activityMaxLat)/2.0f,
                                                                       (activityMinLon+activityMaxLon)/2.0f);
            
            MKCircle *circle = [MKCircle circleWithCenterCoordinate:center
                                                             radius:activity.distance/8.0f];
            self.activityTypeForOverlay[@(circle.hash)] = @(activity.type);

            [self.mapView addOverlay:circle];
            
            minLat = MIN(activityMinLat, minLat);
            minLon = MIN(activityMinLon, minLon);
            maxLat = MAX(activityMaxLat, maxLat);
            maxLon = MAX(activityMaxLon, maxLon);
        }
        
        [self.activityTypes addObject:@(activity.type)];
    }
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLat+maxLat)/2.0f, (minLon+maxLon)/2.0f);
    MKCoordinateSpan span = MKCoordinateSpanMake(1.5*(maxLat-minLat), 1.5*(maxLon-minLon));
    
    self.mapView.region = MKCoordinateRegionMake(center, span);
    
    [self updateActivityTypesLabel];
}

-(void) updateActivityTypesLabel
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    
    for (NSNumber *activityType in self.activityTypes) {
        const char *iconCode = [ActivityHelper iconCodeForActivityType:activityType.integerValue];
        CGFloat fontSize = [ActivityHelper fontSizeFactorForActivityType:activityType.integerValue] * 14;
        
        NSString *iconStr = [NSString stringWithFormat:@"%@  ", [NSString stringWithUTF8String:iconCode]];
        NSMutableAttributedString *subStr = [[NSMutableAttributedString alloc] initWithString:iconStr];
    
        [subStr addAttribute:NSForegroundColorAttributeName
                       value:[ActivityHelper colorForActivityType:activityType.intValue]
                       range:NSMakeRange(0, 1)];
        [subStr addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"icomoon" size:fontSize]
                       range:NSMakeRange(0, 1)];
        [str appendAttributedString:subStr];
    }
    
    self.iconListLabel.attributedText = str;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    kActivityType type = [self.activityTypeForOverlay[@(overlay.hash)] integerValue];
    UIColor *color = [ActivityHelper colorForActivityType:type];
    
    MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithCircle:overlay];
    circleView.strokeColor = color;
    
    circleView.lineWidth = 3.0;
    circleView.fillColor = [color colorWithAlphaComponent:0.1];
    
    return circleView;
}

- (IBAction)moreAction:(id)sender
{
    [self fetchNextPage];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.mapView removeFromSuperview];
    self.mapView = nil;
}

@end
