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
 */
@interface FRDStravaClient : NSObject

@property (nonatomic, strong) NSString *clientSecret;
@property (nonatomic) NSInteger clientId;

@property (nonatomic, strong) NSString *accessToken;

@property (nonatomic, strong, readonly) NSURL *baseURL;

+(FRDStravaClient *) sharedInstance;

-(void) initializeWithClientId:(NSInteger)clientId clientSecret:(NSString *)clientSecret;


@end
