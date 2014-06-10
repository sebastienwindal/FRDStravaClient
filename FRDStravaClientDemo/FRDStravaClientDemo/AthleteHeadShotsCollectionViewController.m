//
//  AthleteHeadShotsCollectionViewController.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/17/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "AthleteHeadShotsCollectionViewController.h"
#import "FRDStravaClientImports.h"
#import "HeadShotCollectionViewCell.h"
#import "UIImageView+WebCache.h"


@interface AthleteHeadShotsCollectionViewController ()

@property (nonatomic, strong) NSArray *athletes;

@end

@implementation AthleteHeadShotsCollectionViewController

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
    
    
    void(^successBlock)(NSArray *athletes) = ^(NSArray *athletes) {
        self.athletes = athletes;
        [self.collectionView reloadData];
    };
    
    void(^failBlock)(NSError *error) = ^(NSError *error) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"FAILED"
                                                     message:error.localizedDescription
                                                    delegate:nil
                                           cancelButtonTitle:@"Ok"
                                           otherButtonTitles:nil];
        [av show];
    };
    
    
    if (self.headShotListType == HeadShotListTypeCommonFollowers) {
        [[FRDStravaClient sharedInstance] fetchCommonFollowersOfCurrentAthleteAndAthlete:self.athleteId
                                                                                pageSize:50
                                                                               pageIndex:1
                                                                                 success:successBlock
                                                                                 failure:failBlock];
    } else if (self.headShotListType == HeadShotListTypeClubMembers) {
        [[FRDStravaClient sharedInstance] fetchMembersOfClub:self.clubId
                                                    pageSize:50
                                                   pageIndex:1
                                                     success:successBlock
                                                     failure:failBlock];
    } else if (self.headShotListType == HeadShotListTypeKudoers) {
        [[FRDStravaClient sharedInstance] fetchKudoersForActivity:self.activityId
                                                         pageSize:50
                                                        pageIndex:1
                                                          success:successBlock
                                                          failure:failBlock];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.athletes count];
}

- (IBAction)closeAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HeadShotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BothFollowingCollectionViewCell" forIndexPath:indexPath];
    
    StravaAthlete *athlete = self.athletes[indexPath.row];
    
    [cell.athelteImageView setImageWithURL:[NSURL URLWithString:athlete.profileLargeURL]];
    cell.athelteImageView.clipsToBounds = YES;
    cell.athelteImageView.layer.cornerRadius = CGRectGetWidth(cell.athelteImageView.bounds) / 2.0f;
    
    return cell;
}


@end
