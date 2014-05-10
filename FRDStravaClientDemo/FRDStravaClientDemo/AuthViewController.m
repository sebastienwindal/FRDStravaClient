//
//  AuthViewController.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/18/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "AuthViewController.h"
#import "FRDStravaClient.h"
#import "FRDStravaClient+Access.h"
#import "FRDStravaClient+Athlete.h"

#import "SecondTableViewController.h"

#define ACCESS_TOKEN_KEY @"ACCESS_TOKEN_KEY"


@interface AuthViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *authorizeButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation AuthViewController

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
    
    // Get yourself a client secret and client ID from strava http://www.strava.com/developers
    // and configure them here:
    NSString *clientSecret = [[NSUserDefaults standardUserDefaults] objectForKey:@"ClientSecret"];
    NSInteger clientID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ClientID"] integerValue];
    
    // hard-code ID and secret here:
    //clientID = 1234
    //clientSecret = @"ffffffffffffffffffffffffffffffffffffffff";
    
    if (clientSecret.length == 0 || clientID == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"error"
                                                            message:@"Configure the Strava client secret and ID in the Settings or hard-code them in AuthViewController viewDidLoad, and restart the demo app."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        return;
    }
    
    [[FRDStravaClient sharedInstance] initializeWithClientId:clientID
                                                clientSecret:clientSecret];
    
    
    self.statusLabel.text = @"";
    
    NSString *previousToken = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN_KEY];
    
    if ([previousToken length] > 0) {
        // check the user token is still ok by fetching user data
        self.authorizeButton.hidden = YES;
        self.statusLabel.text = @"Checking access token is valid...";
        
        [[FRDStravaClient sharedInstance] setAccessToken:previousToken];
        [[FRDStravaClient sharedInstance] fetchCurrentAthleteWithSuccess:^(StravaAthlete *athlete) {
            self.statusLabel.text = @"ok.";
            [self performSegueWithIdentifier:@"AuthorizeSuccessfulSegue" sender:athlete];
        }
                                                                 failure:^(NSError *error) {
                                                                    self.statusLabel.text = @"Access token invalid, you need to reauthorize.";
                                                                     self.authorizeButton.hidden = NO;
                                                                     [[FRDStravaClient sharedInstance] setAccessToken:nil];
                                                                 }];
    } else {
        self.authorizeButton.hidden = NO;
        // do nothing, this will show the access button.
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)authorizeAction:(id)sender
{
    [[FRDStravaClient sharedInstance] authorizeWithCallbackURL:[NSURL URLWithString:@"FRDStravaClient://www.spinspinapp.com"] stateInfo:nil];
}


-(void) exchangeToken:(NSString *)code
{
    [[FRDStravaClient sharedInstance] exchangeTokenForCode:code
                                                   success:^(StravaAccessTokenResponse *response) {
                                                       [[NSUserDefaults standardUserDefaults] setObject:response.accessToken forKey:ACCESS_TOKEN_KEY];
                                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                                       
                                                       [self performSegueWithIdentifier:@"AuthorizeSuccessfulSegue"
                                                                                 sender:response.athlete];
                                                   } failure:^(NSError *error) {
                                                       [self showAuthFailedWithError:error.localizedDescription];
                                                   }];
}

-(void) showAuthFailedWithError:(NSString *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                        message:error
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    StravaAthlete *athlete = sender;
    UINavigationController *navVC = segue.destinationViewController;
    SecondTableViewController *destinationVC = [navVC.childViewControllers firstObject];
    
    destinationVC.athleteId = athlete.id;
    destinationVC.token = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN_KEY];
}

-(void) logout
{
    [FRDStravaClient sharedInstance].accessToken = nil;
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:ACCESS_TOKEN_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
    self.statusLabel.text = @"you are logged out";
    self.authorizeButton.hidden = NO;
}

- (IBAction)logoutUnwindSegue:(UIStoryboardSegue *)unwindSegue
{
    [self logout];
}

@end
