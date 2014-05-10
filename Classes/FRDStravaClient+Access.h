//
//  FRDStravaClient+Access.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/21/14.
//

#import "FRDStravaClient.h"

@interface FRDStravaClient (Access)

-(void) authorizeWithCallbackURL:(NSURL *)callbackUrl stateInfo:(NSString *)stateInfo;

-(void) parseStravaAuthCallback:(NSURL *)url
                    withSuccess:(void (^)(NSString *stateInfo, NSString *code))success
                        failure:(void (^)(NSString *stateInfo, NSString *error))error;

-(void) exchangeTokenForCode:(NSString *)code
                     success:(void (^)(StravaAccessTokenResponse *response))success
                     failure:(void (^)(NSError *error))failure;


@end
