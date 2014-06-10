//
//  ActivityDetailsViewController.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/5/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "ActivityDetailsViewController.h"
#import "FRDStravaClientImports.h"
#import "GearViewController.h"
#import "JBLineChartView.h"
#import "JBBarChartView.h"
#import "ActivityHelper.h"
#import "AthleteHeadShotsCollectionViewController.h"


@interface ActivityDetailsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *rawTextView;

@property (nonatomic, strong) StravaActivity *activity;

@end

@implementation ActivityDetailsViewController


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
    
    [self showSpinner];
    
    [[FRDStravaClient sharedInstance] fetchActivityWithId:self.activityId
                                        includeAllEfforts:NO
                                                  success:^(StravaActivity *activity) {
                                                      [self hideSpinner];
                                                      self.rawTextView.text = [activity description];
                                                      self.activity = activity;
                                                  }
                                                  failure:^(NSError *error) {
                                                      [self hideSpinner];
                                                      UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"FAILED"
                                                  message:error.localizedDescription
                                                  delegate:nil
                                                  cancelButtonTitle:@"Close"
                                                                                         otherButtonTitles: nil];
                                                      [av show];
                                                  }];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setActivityId:)]) {
        [segue.destinationViewController setActivityId:self.activityId];
    }
    if ([segue.destinationViewController respondsToSelector:@selector(setGearId:)]) {
        [segue.destinationViewController setGearId:self.activity.gearId];
    }
    if ([segue.identifier isEqualToString:@"ActivityToKudoers"]) {
        UINavigationController *navVC = segue.destinationViewController;
        AthleteHeadShotsCollectionViewController *vc = navVC.childViewControllers.firstObject;
        vc.activityId = self.activityId;
        vc.headShotListType = HeadShotListTypeKudoers;
    }
}

-(void) showSpinner
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = activityItem;
}

-(void) hideSpinner
{
    self.navigationItem.rightBarButtonItem = nil;
}
@end
