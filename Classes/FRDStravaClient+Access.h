//
//  FRDStravaClient+Access.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/21/14.
//

#import "FRDStravaClient.h"

@interface FRDStravaClient (Access)

/**
 Initiate a OAUTH authorization. This method will launch the Strava OAUTH web page on Safari where users will be prompted to login and grant Strava access to your app. The domain of the callback URL should match the Authorization Callback Domain you configured with Strava (https://www.strava.com/settings/api). The URL scheme should be one you configured in your app plist as Custom URL Scheme.
 
 @param callbackUrl The URL that will be called from Safari upon successful Authentication with the strava website. Typically it will consists of a URL with a URL scheme you registered e.g. myAppRegisteredURLScheme://mydomain.com
 @param stateInfo (optional) a NSString that will be passed back in the callback URL, as a state attribute (...&state=blah).
 */
-(void) authorizeWithCallbackURL:(NSURL *)callbackUrl stateInfo:(NSString *)stateInfo;

-(void) parseStravaAuthCallback:(NSURL *)url
                    withSuccess:(void (^)(NSString *stateInfo, NSString *code))success
                        failure:(void (^)(NSString *stateInfo, NSString *error))error;

-(void) exchangeTokenForCode:(NSString *)code
                     success:(void (^)(StravaAccessTokenResponse *response))success
                     failure:(void (^)(NSError *error))failure;


@end
