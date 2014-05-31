//
//  FRDStravaClient+Access.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/21/14.
//

#import "FRDStravaClient.h"

@interface FRDStravaClient (Access)

/**
 Initiate a OAUTH authorization with Strava. This method will launch Safari at the Strava OAUTH web page where you will be prompted to login and grant Strava access to your app. The domain of the callback URL must match the Authorization Callback Domain you configured with Strava (at this location: https://www.strava.com/settings/api ). The URL scheme should be one you configured in your app plist as Custom URL Scheme, so your app can be launched back by Safari upon success.
 
     After the user successfuly authorized your app, Safari will open your app by launching the passed callbackUrl,
     you can use parseStravaAuthCallback:withSuccess:failure to parse the callback data, including the authorization
     code required to get an access token to complete the Oauth Flow.
 
    The typical initial authorization flow should look like this:
    * iOS app calls authorizeCallbackURL:stateInfo:
    * upon success your app is launched back by Safari. In your AppDelegate application:handleOpenURL:, call 
      parseStravaAuthCallback:withSuccess:failure to parse the callback URL.
    * In the success block of parseStravaAuthCallback:withSuccess:failure call exchangeTokenForCode:success:failure:
    * Upon success you are now good to go for this session... The accessToken in the shared instance of FRDStravaClient
      was automatically set. All REST calls issued by the FRDStravaClient sharedInstance will include it in the REST
      request. You may also want at this point to save the response token somewhere safely in your app
      persistent storage (like the keychain), for future run of your app, to be able to bypass the oauth dance. 
      Call the setAccessToken: method of the [FRDStravaClient sharedInstance] with that saved access token...
 
 @param callbackUrl The URL that will be called from Safari upon successful Authentication with the strava OAuth authorization web page. Typically you want your app to be launched back, so it should consist of a URL with a scheme you registered e.g. myAppRegisteredURLScheme://mydomain.com.
 @param stateInfo (optional) a NSString that will be passed back in the callback URL, as a state attribute (...&state=blah).
 */
-(void) authorizeWithCallbackURL:(NSURL *)callbackUrl stateInfo:(NSString *)stateInfo;

/**
 Method used in step #2 of the OAuth flow. See authorizeWithCallbackURL:stateInfo for detailed description.
 This method will parse the callback URL your app was launched with from Safari OAuth authentication page,
 and extract the authentication code you must use in step #3: exchangeTokenForCode:success:failure:.
 
 @params url the callback nsurl
 @params success Called with the authorization when OAuth was successful.
 @params failure Called when OAuth failed
 */
-(void) parseStravaAuthCallback:(NSURL *)url
                    withSuccess:(void (^)(NSString *stateInfo, NSString *code))success
                        failure:(void (^)(NSString *stateInfo, NSString *error))error;

/**
 To be called in the final step of the OAuth flow.
 
 @params code the authorization code we just got in Step #2
 @params success Called when OAuth token exchange was successful. StravaAccessTokenResponse object contains the response token.
 @params failure Called when the OAuth token exchanged failed
 */
-(void) exchangeTokenForCode:(NSString *)code
                     success:(void (^)(StravaAccessTokenResponse *response))success
                     failure:(void (^)(NSError *error))failure;


@end
