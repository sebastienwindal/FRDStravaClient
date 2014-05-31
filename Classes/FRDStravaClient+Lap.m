//
//  FRDStravaClient+Lap.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/24/14.
//

#import <Mantle/Mantle.h>
#import "AFNetworking.h"
#import "FRDStravaClient+Lap.h"
#import "StravaActivityLap.h"

@interface LapsResponse: MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSArray *laps;

@end

@implementation LapsResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"laps": @"laps"
             };
}
+ (NSValueTransformer *)lapsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[StravaActivityLap class]];
}

@end


@implementation FRDStravaClient (Lap)

-(void) fetchLapsForActivity:(NSInteger)activityId
                     success:(void (^)(NSArray *laps))success
                     failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:self.baseURL];
    
    [manager GET:[NSString stringWithFormat:@"activities/%ld/laps", (long)activityId]
      parameters:@{ @"access_token" : self.accessToken}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSDictionary *wrapper = @{ @"laps": responseObject };
             
             NSError *error = nil;
             
             LapsResponse *response = [MTLJSONAdapter modelOfClass:[LapsResponse class]
                                                fromJSONDictionary:wrapper
                                                             error:&error];
             
             
             if (error) {
                 failure(error);
             } else {
                 success(response.laps);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure(error);
         }];
}
@end
