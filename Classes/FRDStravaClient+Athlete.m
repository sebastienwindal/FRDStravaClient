//
//  FRDStravaClient+Athlete.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/21/14.
//

#import "FRDStravaClient+Athlete.h"
#import <Mantle/Mantle.h>
#import "AFNetworking.h"

@interface AthleteListWrapper : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSArray *athletes;

@end

@implementation AthleteListWrapper

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ @"athletes": @"athletes" };
}

+ (NSValueTransformer *)athletesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[StravaAthlete class]];
}

@end

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


-(void) fetchCurrentAthleteFollowersWithPageSize:(NSInteger)pageSize
                                       pageIndex:(NSInteger)pageIndex
                                         success:(void (^)(NSArray *athletes))success
                                         failure:(void (^)(NSError *error))failure
{
    [self fetchAthleteListAtUrl:@"athlete/followers"
                       pageSize:pageSize
                      pageIndex:pageIndex
                        success:success
                        failure:failure];
}


-(void) fetchCurrentAthleteFriendsWithPageSize:(NSInteger)pageSize
                                     pageIndex:(NSInteger)pageIndex
                                       success:(void (^)(NSArray *athletes))success
                                       failure:(void (^)(NSError *error))failure
{
    [self fetchAthleteListAtUrl:@"athlete/friends"
                       pageSize:pageSize
                      pageIndex:pageIndex
                        success:success
                        failure:failure];
}

-(void) fetchFollowersForAthlete:(NSInteger)athleteId
                        pageSize:(NSInteger)pageSize
                       pageIndex:(NSInteger)pageIndex
                         success:(void (^)(NSArray *athletes))success
                         failure:(void (^)(NSError *error))failure
{
    [self fetchAthleteListAtUrl:[NSString stringWithFormat:@"athletes/%ld/followers", (long)athleteId]
                       pageSize:pageSize
                      pageIndex:pageIndex
                        success:success
                        failure:failure];
}

-(void) fetchFriendsForAthlete:(NSInteger)athleteId
                      pageSize:(NSInteger)pageSize
                     pageIndex:(NSInteger)pageIndex
                       success:(void (^)(NSArray *athletes))success
                       failure:(void (^)(NSError *error))failure
{
    [self fetchAthleteListAtUrl:[NSString stringWithFormat:@"athletes/%ld/friends", (long)athleteId]
                       pageSize:pageSize
                      pageIndex:pageIndex
                        success:success
                        failure:failure];
}

-(void) fetchCommonFollowersOfCurrentAthleteAndAthlete:(NSInteger)athleteId
                                              pageSize:(NSInteger)pageSize
                                             pageIndex:(NSInteger)pageIndex
                                               success:(void (^)(NSArray *athletes))success
                                               failure:(void (^)(NSError *error))failure
{
    [self fetchAthleteListAtUrl:[NSString stringWithFormat:@"athletes/%ld/both-following", (long)athleteId]
                       pageSize:pageSize
                      pageIndex:pageIndex
                        success:success
                        failure:failure];
}


#pragma mark private

-(void) fetchAthleteListAtUrl:(NSString *)url
                     pageSize:(NSInteger)pageSize
                    pageIndex:(NSInteger)pageIndex
                      success:(void (^)(NSArray *athletes))success
                      failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:self.baseURL];
    
    NSMutableDictionary *params = [@{ @"access_token" : self.accessToken,
                                      @"per_page": @(pageSize),
                                      @"page": @(pageIndex) } mutableCopy];

    
    [manager GET:url
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSError *error = nil;
             
             NSDictionary *dict = @{ @"athletes": responseObject };
             
             AthleteListWrapper *wrapper = [MTLJSONAdapter modelOfClass:[AthleteListWrapper class]
                                                     fromJSONDictionary:dict
                                                                  error:&error];
             
             if (error) {
                 failure(error);
             } else {
                 success(wrapper.athletes);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure(error);
         }];
}


@end

