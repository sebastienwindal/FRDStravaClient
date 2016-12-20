//
//  AthleteDetaislViewController.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/29/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "AthleteDetailsTableViewController.h"
#import "UIImageView+WebCache.h"
#import "FRDStravaClientImports.h"


@interface AthleteDetailsTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *athleteImageView;
@property (weak, nonatomic) IBOutlet UITextView *athleteTextView;
@end

@implementation AthleteDetailsTableViewController

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
                                                     [self.athleteImageView sd_setImageWithURL:[NSURL URLWithString:athlete.profileLargeURL]];
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

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setAthleteId:)]) {
        [segue.destinationViewController setAthleteId:self.athleteId];
    }
}

@end
