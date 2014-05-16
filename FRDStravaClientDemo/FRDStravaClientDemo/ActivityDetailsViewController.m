//
//  ActivityDetailsViewController.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/5/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "ActivityDetailsViewController.h"
#import "FRDStravaClient+Activity.h"
#import "JBLineChartView.h"
#import "JBBarChartView.h"
#import "ActivityHelper.h"

@interface ActivityDetailsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *rawTextView;

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
                                                  }
                                                  failure:^(NSError *error) {
                                                      [self hideSpinner];
                                                      UIAlertView *av = [[UIAlertView alloc] initWithTitle:@""
                                                  message:nil
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
