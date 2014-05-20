//
//  ActivitiesTableViewController.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/30/14.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ActivitiesListModes) {
    ActivitiesListModeCurrentAthlete,
    ActivitiesListModeFeed,
    ActivitiesListModeClub
    
};

@interface ActivitiesTableViewController : UITableViewController

@property (nonatomic) NSInteger clubId;
@property (nonatomic) ActivitiesListModes mode;

@end
