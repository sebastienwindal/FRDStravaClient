//
//  ZoneTableViewCell.h
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/25/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBBarChartView.h"


@interface ZoneTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *zoneLabel;
@property (weak, nonatomic) IBOutlet JBBarChartView *chartView;

@end
