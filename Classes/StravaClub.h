//
//  StravaClub.h
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/17/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "StravaCommon.h"

/// Possible club types.
///
/// Strava API maching docs: http://strava.github.io/api/v3/clubs/
typedef NS_ENUM(NSInteger, kStravaClubTypes) {
    kStravaClubTypesUnknown = 0,
    kStravaClubTypeCasualClub,
    kStravaClubTypesRacingTeam,
    kStravaClubTypesShop,
    kStravaClubTypesCompany,
    kStravaClubTypesOther
};

/// Possible sport type for a club.
///
/// Strava API maching docs: http://strava.github.io/api/v3/clubs/
typedef NS_ENUM(NSInteger, kStravaSportTypes) {
    kStravaSportTypesUnknown = 0,
    kStravaSportTypesCycling,
    kStravaSportTypesRunning,
    kStravaSportTypesTriathlon,
    kStravaSportTypesOther
};


///
/// Club object.
///
/// Strava API maching docs: http://strava.github.io/api/v3/clubs/
///
@interface StravaClub : MTLModel<MTLJSONSerializing>

@property (nonatomic, readonly) NSInteger id;
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *profileMedium;
@property (nonatomic, readonly, copy) NSString *profile;
@property (nonatomic, readonly, copy) NSString *clubDescription;
@property (nonatomic, readonly) kStravaClubTypes clubType;
@property (nonatomic, readonly) kStravaSportTypes sportType;
@property (nonatomic, readonly, copy) NSString *city;
@property (nonatomic, readonly, copy) NSString *state;
@property (nonatomic, readonly, copy) NSString *country;
@property (nonatomic, readonly) BOOL private;
@property (nonatomic, readonly) NSInteger memberCount;
@property (nonatomic, readonly) kResourceState resourceState;


@end

