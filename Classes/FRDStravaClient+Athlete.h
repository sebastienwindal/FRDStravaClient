//
//  FRDStravaClient+Athlete.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/21/14.
//

#import "FRDStravaClient.h"
#import "StravaAthlete.h"

@interface FRDStravaClient (Athlete)

-(void) fetchAthleteWithId:(NSInteger)athleteId
                   success:(void (^)(StravaAthlete *athlete))success
                   failure:(void (^)(NSError *error))failure;
-(void) fetchCurrentAthleteWithSuccess:(void (^)(StravaAthlete *athlete))success
                              failure:(void (^)(NSError *error))failure;
@end
