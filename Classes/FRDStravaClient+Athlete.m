//
//  FRDStravaClient+Athlete.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/21/14.
//

#import "FRDStravaClient+Athlete.h"
#import <Mantle/Mantle.h>
#import "AFNetworking.h"

@implementation FRDStravaClient (Athlete)

-(void) fetchAthleteWithId:(NSInteger)athleteId
                   success:(void (^)(StravaAthlete *athlete))success
                   failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:self.baseURL];
    
    NSString *url;
    if (athleteId == NSNotFound) {
        url = @"athlete";
    } else {
        url = [NSString stringWithFormat:@"athletes/%ld", (long)athleteId];
    }
    
    [manager GET:url
      parameters:@{ @"access_token" : self.accessToken}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSError *error = nil;
             
             StravaAthlete *athlete = [MTLJSONAdapter modelOfClass:[StravaAthlete class]
                                            fromJSONDictionary:responseObject
                                                         error:&error];
             
             if (error) {
                 failure(error);
             } else {
                 success(athlete);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure(error);
         }];

}

-(void) fetchCurrentAthleteWithSuccess:(void (^)(StravaAthlete *athlete))success
                               failure:(void (^)(NSError *error))failure
{
    [self fetchAthleteWithId:NSNotFound success:success failure:failure];
}




@end
