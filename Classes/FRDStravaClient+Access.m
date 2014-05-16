//
//  FRDStravaClient+Access.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/21/14.
//

#import "FRDStravaClient+Access.h"
#import "AFNetworking.h"

@implementation FRDStravaClient (Access)

-(void) authorizeWithCallbackURL:(NSURL *)callbackUrl stateInfo:(NSString *)stateInfo
{
    NSAssert(self.clientId != 0, @"clientID is 0, did you call initializeWithClientId:clientSecred: ?");
    NSAssert(self.clientSecret.length != 0, @"clientSecret is empty, did you call initializeWithClientId:clientSecred: ?");
    
    if (stateInfo == nil) {
        stateInfo = @"";
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"https://www.strava.com/oauth/authorize?client_id=%ld&response_type=code&redirect_uri=%@&scope=write&state=%@&approval_prompt=force", (long)self.clientId, [callbackUrl absoluteString], [stateInfo stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
                                                                                                                                                                                                                                             
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    [[UIApplication sharedApplication] openURL:url];
}


const NSString *kStravaAuthCode = @"code";
const NSString *kStravaAuthState = @"state";
const NSString *kStravaAuthURLError = @"error";


-(void) parseStravaAuthCallback:(NSURL *)url
                    withSuccess:(void (^)(NSString *stateInfo, NSString *code))success
                        failure:(void (^)(NSString *stateInfo, NSString *error))failure
{
    NSDictionary *dict = [self gh_queryStringToDictionary:url];
    
    if ([dict[kStravaAuthURLError] length] > 0) {
        failure(dict[kStravaAuthState], dict[kStravaAuthURLError]);
    } else {
        success(dict[kStravaAuthState], dict[kStravaAuthCode]);
    }
}


-(void) exchangeTokenForCode:(NSString *)code
                     success:(void (^)(StravaAccessTokenResponse *response))success
                     failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSDictionary *parameters = @{
                                 @"client_id": @(self.clientId),
                                 @"client_secret": self.clientSecret,
                                 @"code": code
                                 };
    
    [manager POST:@"https://www.strava.com/oauth/token"
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSError *error = nil;
              StravaAccessTokenResponse *authResponse = [MTLJSONAdapter modelOfClass:StravaAccessTokenResponse.class
                                                            fromJSONDictionary:responseObject
                                                                         error:&error];
              
              if (error) {
                  failure(error);
              } else {
                  self.accessToken = authResponse.accessToken;
                  success(authResponse);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(error);
          }];
}


#pragma mark URL parsing

// code below "borrowed" from https://github.com/gabriel/gh-kit

-(NSDictionary *)gh_queryStringToDictionary:(NSURL *)url
{
    NSString *string = [url query];
    
	NSArray *queryItemStrings = [string componentsSeparatedByString:@"&"];
    
	NSMutableDictionary *queryDictionary = [NSMutableDictionary dictionaryWithCapacity:[queryItemStrings count]];
	for(NSString *queryItemString in queryItemStrings) {
		NSRange range = [queryItemString rangeOfString:@"="];
		if (range.location != NSNotFound) {
			NSString *key = [self gh_decode:[queryItemString substringToIndex:range.location]];
			NSString *value = [self gh_decode:[queryItemString substringFromIndex:range.location + 1]];
			[queryDictionary setObject:value forKey:key];
		}
	}
	return queryDictionary;
}

- (NSString *)gh_decode:(NSString *)s {
	
    if (!s) return nil;
    
    NSString *str;
    
	str = CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapes(NULL, (CFStringRef)s, CFSTR("")));
    
    return str;
}



@end
