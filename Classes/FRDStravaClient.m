//
//  FRDStravaClient.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/18/14.
//

#import "FRDStravaClient.h"
#import "AFNetworking.h"

@interface FRDStravaClient()


@end



@implementation FRDStravaClient


+(FRDStravaClient *) sharedInstance
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void) initializeWithClientId:(NSInteger)clientId clientSecret:(NSString *)clientSecret
{
    self.clientId = clientId;
    self.clientSecret = clientSecret;
}

-(NSURL *) baseURL
{
    return [NSURL URLWithString:@"https://www.strava.com/api/v3"];
}

@end
