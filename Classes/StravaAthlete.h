//
//  StravaAthlete.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/18/14.
//

#import <Mantle/Mantle.h>

typedef NS_ENUM(NSInteger,kAthleteGender) {
    kAthleteGenderFemale=0,
    kAthleteGenderMale=1
} ;

@interface StravaAthlete : MTLModel<MTLJSONSerializing>

@property (nonatomic, readonly) NSInteger id;
@property (nonatomic, copy, readonly) NSString *firstName;
@property (nonatomic, copy, readonly) NSString *lastName;
@property (nonatomic, copy, readonly) NSString *profileLargeURL;
@property (nonatomic, copy, readonly) NSString *profileMediumURL;
@property (nonatomic, copy, readonly) NSString *country;
@property (nonatomic, copy, readonly) NSString *state;
@property (nonatomic, copy, readonly) NSString *city;
@property (nonatomic, readonly) kAthleteGender sex;


@end
