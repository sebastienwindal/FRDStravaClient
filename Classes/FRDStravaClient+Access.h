//
//  FRDStravaClient+Access.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/21/14.
//

#import "FRDStravaClient.h"

/**

The Access category provides methods to authorize your app with the Strava Rest service.
 
Strava API maching docs: http://strava.github.io/api/v3/oauth/ 

## OAuth Flow

The typical authorization flow should look like this:

1. iOS app calls `authorizeWithCallbackURL:stateInfo:`.
2. Upon success your app is launched back by Safari. In your AppDelegate `application:handleOpenURL:`, call `parseStravaAuthCallback:withSuccess:failure:` to parse the callback URL.
3. In the success block of `parseStravaAuthCallback:withSuccess:failure:` call `exchangeTokenForCode:success:failure:`
4. Upon success you are now good to go for this session... The `accessToken` in the shared instance of FRDStravaClient was automatically set and all REST calls issued by the FRDStravaClient sharedInstance should be sent with the required token. You may also want at this point to save the access token somewhere safely in your app persistent storage (like the keychain), for future run of your app, to be able to bypass that whole painful OAuth dance. Call the `setAccessToken:` method of the `[FRDStravaClient sharedInstance]` with your saved access token...
 
 */

@interface FRDStravaClient (Access)

/**
Initiate a OAUTH authorization with Strava. This method will launch Safari at the Strava OAUTH web page where you will be prompted to login and grant Strava access to your app. The domain of the callback URL must match the Authorization Callback Domain you configured with Strava (at this location: https://www.strava.com/settings/api ). The URL scheme should be one you configured in your app plist as Custom URL Scheme, so your app can be launched back by Safari upon success.
 
After the user successfuly authorized your app, Safari will open your app by launching the passed `callbackUrl`, you can use `parseStravaAuthCallback:withSuccess:failure` to parse the callback data, including the authorization code required to get an access token to complete the Oauth Flow.
 
@param callbackUrl The URL that will be called from Safari upon successful Authentication with the strava OAuth authorization web page. Typically you want your app to be launched back, so it should consist of a URL with a scheme you registered e.g. myAppRegisteredURLScheme://mydomain.com.
@param stateInfo (optional) a NSString that will be passed back in the callback URL, as a state attribute (...&state=blah).
 */
-(void) authorizeWithCallbackURL:(NSURL *)callbackUrl stateInfo:(NSString *)stateInfo;

/**
 Method used in step #2 of the OAuth flow. See authorizeWithCallbackURL:stateInfo for detailed description.
 This method will parse the callback URL your app was launched with from Safari OAuth authentication page,
 and extract the authentication code you must use in step #3: exchangeTokenForCode:success:failure:.
 
 @param url the callback nsurl
 @param success Called with the authorization when OAuth was successful.
 @param failure Called when OAuth failed
 
 @see -authorizeWithCallbackURL:stateInfo:
 */
-(void) parseStravaAuthCallback:(NSURL *)url
                    withSuccess:(void (^)(NSString *stateInfo, NSString *code))success
                        failure:(void (^)(NSString *stateInfo, NSString *error))error;

/**
 To be called in the final step of the OAuth flow.
 
 @param code the authorization code we just got in Step #2
 @param success Called when OAuth token exchange was successful. StravaAccessTokenResponse object contains the response token.
 @param failure Called when the OAuth token exchanged failed
 
 @see -authorizeWithCallbackURL:stateInfo:
 */
-(void) exchangeTokenForCode:(NSString *)code
                     success:(void (^)(StravaAccessTokenResponse *response))success
                     failure:(void (^)(NSError *error))failure;


@end
