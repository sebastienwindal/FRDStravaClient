//
//  FRDStravaClient+ActivityStream.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/5/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "FRDStravaClient+ActivityStream.h"
#import "AFNetworking.h"
#import <Mantle/Mantle.h>

@interface StreamResponse: MTLModel<MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSArray *streams;

@end

@implementation StreamResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"streams": @"streams"
             };
}
+ (NSValueTransformer *)streamsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[StravaStream class]];
}

@end

@implementation FRDStravaClient (ActivityStream)

-(void) fetchActivityStreamForActivityId:(NSInteger)activityId
                              resolution:(kStravaStreamResolution)resolution
                               dataTypes:(NSArray *)dataTypes
                                 success:(void (^)(NSArray *streams))success
                                 failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:self.baseURL];
    
    
    NSMutableString *typesStr = [@"" mutableCopy];
    
    
    for (NSNumber *type in dataTypes) {
        [typesStr appendString:[[StravaStream typeJSONTransformer] reverseTransformedValue:type]];
        [typesStr appendString:@","];
    }
    
    if (typesStr.length > 0) {
        [typesStr deleteCharactersInRange:NSMakeRange(typesStr.length-1, 1)];
    }
    
    [manager GET:[NSString stringWithFormat:@"activities/%ld/streams/%@", (long)activityId, typesStr]
      parameters:@{ @"access_token" : self.accessToken}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSDictionary *wrapper = @{ @"streams": responseObject };
             
             NSError *error = nil;
             
             StreamResponse *response = [MTLJSONAdapter modelOfClass:[StreamResponse class]
                                                  fromJSONDictionary:wrapper
                                                               error:&error];
             
             if (error) {
                 failure(error);
             } else {
                 success(response.streams);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure(error);
         }];

}

@end
