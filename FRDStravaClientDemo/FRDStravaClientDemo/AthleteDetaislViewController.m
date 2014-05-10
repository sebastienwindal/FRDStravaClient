//
//  AthleteDetaislViewController.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/29/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "AthleteDetaislViewController.h"
#import "FRDStravaClient+Athlete.h"
#import "UIImageView+WebCache.h"


@interface AthleteDetaislViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *athleteImageView;
@property (weak, nonatomic) IBOutlet UITextView *athleteTextView;
@end

@implementation AthleteDetaislViewController

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
    
    [[FRDStravaClient sharedInstance] fetchAthleteWithId:self.athleteId
                                                 success:^(StravaAthlete *athlete) {

                                                     self.athleteTextView.text = [athlete description];
                                                     [self.athleteImageView setImageWithURL:[NSURL URLWithString:athlete.profileLargeURL]];
                                                 }
                                                 failure:^(NSError *error) {
                                                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"error"
                                                                                                         message:error.localizedDescription
                                                                                                        delegate:nil
                                                                                               cancelButtonTitle:@"Close"
                                                                                               otherButtonTitles:nil];
                                                     
                                                     [alertView show];
                                                 }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
