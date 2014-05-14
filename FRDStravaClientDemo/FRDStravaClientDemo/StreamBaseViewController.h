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

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet JBBarChartView *barChartView;
@property (weak, nonatomic) IBOutlet UILabel *selectedBarValueLabel;


-(UIColor *) colorForBarAtIndex:(int)index;

-(void) fetchStreams;

// StreamBaseViewController is an abstract class. Those 2 methods must be overriden
// in subclasses.
-(kStravaStreamType) valueStreamType;
-(CGFloat) dataRangeWidth;
// Don't be lazy, implement those 2 as well:
-(NSString *)stringForRangeStartingWith:(CGFloat)value1 endingWith:(CGFloat)value percent:(CGFloat)percent
;
-(UIColor *) colorForValue:(CGFloat)value;

@end
