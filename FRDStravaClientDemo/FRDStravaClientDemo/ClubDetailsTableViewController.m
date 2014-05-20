//
//  ClubDetailsTableViewController.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/18/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "ClubDetailsTableViewController.h"
#import "FRDStravaClient+Club.h"
#import "AthleteHeadShotsCollectionViewController.h"
#import "ActivitiesTableViewController.h"


@interface ClubDetailsTableViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) StravaClub *club;
@end

@implementation ClubDetailsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[FRDStravaClient sharedInstance] fetchClubWithID:self.clubId
                                              success:^(StravaClub *club) {
                                                  self.textView.text = club.description;
                                                  self.club = club;
                                              }
                                              failure:^(NSError *error) {
                                                  self.textView.text = error.localizedDescription;
                                              }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ClubToMembers"]) {
        AthleteHeadShotsCollectionViewController *vc = [[segue.destinationViewController childViewControllers] firstObject];
        
        vc.headShotListType = HeadShotListTypeClubMembers;
        vc.clubId = self.club.id;
    } else if ([segue.identifier isEqualToString:@"ClubToActivities"]) {
        ActivitiesTableViewController *vc = segue.destinationViewController;
        
        vc.mode = ActivitiesListModeClub;
        vc.clubId = self.club.id;
    }
}
@end
