//
//  AthleteTableViewCell.h
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/17/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AthleteTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *athleteNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *athleteImageView;

@end
