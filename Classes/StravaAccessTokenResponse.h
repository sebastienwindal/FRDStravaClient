//
//  StravaAccessTokenResponse.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/18/14.
//

#import <Mantle/Mantle.h>
#import "StravaAthlete.h"

@interface StravaAccessTokenResponse : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *accessToken;
@property (nonatomic, copy, readonly) StravaAthlete *athlete;

@end
