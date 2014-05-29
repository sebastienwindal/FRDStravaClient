//
//  AthleteHeadShotsCollectionViewController.h
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/17/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HeadShotListType) {
    HeadShotListTypeCommonFollowers,
    HeadShotListTypeClubMembers,
    HeadShotListTypeKudoers,
};

@interface AthleteHeadShotsCollectionViewController : UICollectionViewController

@property (nonatomic) NSInteger athleteId;
@property (nonatomic) NSInteger clubId;
@property (nonatomic) NSInteger activityId;

@property (nonatomic) HeadShotListType headShotListType;

@end
