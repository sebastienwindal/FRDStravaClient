//
//  ActivityCalendarCollectionViewCell.h
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/15/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCalendarCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberRidesLabel;
@property (nonatomic, strong) NSDate *day;
@end
