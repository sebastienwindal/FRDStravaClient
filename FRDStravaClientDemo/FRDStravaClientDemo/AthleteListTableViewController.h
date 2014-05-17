//
//  AthleteListTableViewController.h
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/17/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AthleteListMode) {
    AthleteListModeFollowers,
    AthleteListModeFriends,
    AthleteListModeBothFollowing
};

@interface AthleteListTableViewController : UITableViewController

@property (nonatomic) AthleteListMode mode;

@end
