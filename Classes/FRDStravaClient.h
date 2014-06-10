//
//  FRDStravaClient.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/18/14.
//

#import <Foundation/Foundation.h>
#import "StravaAccessTokenResponse.h"

/**
 `FRDStravaClient`. 
 
 This is a singleton, use [FRDStravaClient sharedInstance].
 Initialization steps:
 
    1. call initializeWithClientId:clientSecret: passing your app data.
    2. If you don't have any saved access token from a previous successful OAUTH authorization, follow the flow described in FRDStravaClient+Access.h.
       If you do, set your access token using [[FRDStravaClient sharedInstance] setAccessToken:yourSavedToken];
 */
@interface FRDStravaClient : NSObject

@property (nonatomic, strong) NSString *clientSecret;
@property (nonatomic) NSInteger clientId;

@property (nonatomic, strong) NSString *accessToken;

@property (nonatomic, strong, readonly) NSURL *baseURL;

+(FRDStravaClient *) sharedInstance;

-(void) initializeWithClientId:(NSInteger)clientId clientSecret:(NSString *)clientSecret;


@end
