//
//  StreamBaseViewController.h
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/12/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "JBBarChartView.h"
#import "StravaStream.h"

@interface StreamBaseViewController : UIViewController <JBBarChartViewDataSource, JBBarChartViewDelegate, MKMapViewDelegate>

@property (nonatomic) NSInteger activityId;
@property (nonatomic) kStravaStreamType valueStreamType;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet JBBarChartView *barChartView;
@property (weak, nonatomic) IBOutlet UILabel *selectedBarValueLabel;
@property (nonatomic) CGFloat dataRangeWidth;

-(UIColor *) colorForBarAtIndex:(int)index;

-(void) fetchStreams;

@end
