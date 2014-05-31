//
//  StravaAccessTokenResponse.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/18/14.
//

#import <Mantle/Mantle.h>
#import "StravaAthlete.h"

///
/// Response object to a token exchange REST call.
///
/// Strava API maching docs: http://strava.github.io/api/v3/oauth/
///
/// @see -exchangeTokenForCode:success:failure:
///
@interface StravaAccessTokenResponse : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *accessToken;
@property (nonatomic, copy, readonly) StravaAthlete *athlete;

@end
