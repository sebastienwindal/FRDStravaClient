//
//  ActivityTableViewCell.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/30/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapkit/MapKit.h>

@interface ActivityTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *chevronIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UIView *typeColorView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userWidthConstraint;
@end
