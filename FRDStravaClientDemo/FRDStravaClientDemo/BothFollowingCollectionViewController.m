//
//  BothFollowingCollectionViewController.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/17/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "BothFollowingCollectionViewController.h"
#import "BothFollowingCollectionViewCell.h"
#import "FRDStravaClient+Athlete.h"
#import "UIImageView+WebCache.h"


@interface BothFollowingCollectionViewController ()

@property (nonatomic, strong) NSArray *athletes;

@end

@implementation BothFollowingCollectionViewController

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
    
    [[FRDStravaClient sharedInstance] fetchCommonFollowersOfCurrentAthleteAndAthlete:self.athleteId
                                                                            pageSize:50
                                                                           pageIndex:1
                                                                             success:^(NSArray *athletes) {
                                                                                 self.athletes = athletes;
                                                                                 [self.collectionView reloadData];
                                                                             }
                                                                             failure:^(NSError *error) {
                                                                                 UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"FAILED" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                                                                 [av show];
                                                                             }];
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
    BothFollowingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BothFollowingCollectionViewCell" forIndexPath:indexPath];
    
    StravaAthlete *athlete = self.athletes[indexPath.row];
    
    [cell.athelteImageView setImageWithURL:[NSURL URLWithString:athlete.profileLargeURL]];
    cell.athelteImageView.clipsToBounds = YES;
    cell.athelteImageView.layer.cornerRadius = CGRectGetWidth(cell.athelteImageView.bounds) / 2.0f;
    
    return cell;
}


@end
