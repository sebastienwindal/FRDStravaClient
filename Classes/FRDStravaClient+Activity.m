//
//  FRDStravaClient+Activity.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/21/14.
//

#import "FRDStravaClient+Activity.h"
#import "AFNetworking.h"
#import "StravaActivity.h"
#import <Mantle/Mantle.h>


@interface ActivityResponse: MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSArray *activities;
@property (nonatomic, copy, readonly) NSArray *photos;
@property (nonatomic, copy, readonly) NSArray *zones;
@property (nonatomic, copy, readonly) NSArray *comments;
@property (nonatomic, copy, readonly) NSArray *kudoers;

@end

@implementation ActivityResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ @"activities": @"activities",
              @"photos": @"photos",
              @"zones": @"zones",
              @"comments": @"comments",
              @"kudoers": @"kudoers"
              };
}

+ (NSValueTransformer *)activitiesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[StravaActivity class]];
}

+ (NSValueTransformer *)photosJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[StravaActivityPhoto class]];
}

+ (NSValueTransformer *)zonesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[StravaActivityZone class]];
}

+ (NSValueTransformer *)commentsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[StravaActivityComment class]];
}

+ (NSValueTransformer *)kudoersJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[StravaAthlete class]];
}

@end

@implementation FRDStravaClient (Activity)

-(void) fetchActivityWithId:(NSInteger)activityId
          includeAllEfforts:(BOOL)includeAllEfforts
                    success:(void (^)(StravaActivity *))success
                    failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:self.baseURL];
    
    NSMutableDictionary *params = [@{ @"access_token" : self.accessToken } mutableCopy];
    if (includeAllEfforts) {
        params[@"include_all_efforts"] = @(TRUE);
    }
    
    [manager GET:[NSString stringWithFormat:@"activities/%ld", (long)activityId]
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSError *error = nil;
             
             StravaActivity *activity = [MTLJSONAdapter modelOfClass:[StravaActivity class]
                                                  fromJSONDictionary:responseObject
                                                               error:&error];
             
             if (error) {
                 failure(error);
             } else {
                 success(activity);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure(error);
         }];
}

-(void) fetchActivitiesForCurrentAthleteWithSuccess:(void (^)(NSArray *activities))success
                                         failure:(void (^)(NSError *error))failure
{
    [self fetchActivitiesWithParameters:nil
                             forFriends:NO
                                success:success
                                failure:failure];
}

-(void) fetchActivitiesForCurrentAthleteWithPageSize:(NSInteger)pageSize
                            pageIndex:(NSInteger)pageIndex
                              success:(void (^)(NSArray *activities))success
                              failure:(void (^)(NSError *error))failure
{
    NSDictionary *params = @{ @"page": @(pageIndex),
                              @"per_page": @(pageSize) };
    
    [self fetchActivitiesWithParameters:params forFriends:NO success:success failure:failure];
}

-(void) fetchActivitiesForCurrentAthleteAfterDate:(NSDate *)date
                                       success:(void (^)(NSArray *activities))success
                                       failure:(void (^)(NSError *error))failure
{
    NSTimeInterval sec = [date timeIntervalSince1970];
    
    NSDictionary *params = @{ @"after": @((NSUInteger) sec) };
    
    [self fetchActivitiesWithParameters:params forFriends:NO success:success failure:failure];
}

-(void) fetchActivitiesForCurrentAthleteBeforeDate:(NSDate *)date
                                        success:(void (^)(NSArray *activities))success
                                        failure:(void (^)(NSError *error))failure
{
    NSTimeInterval sec = [date timeIntervalSince1970];
    
    NSDictionary *params = @{ @"before": @((NSUInteger) sec) };

    [self fetchActivitiesWithParameters:params forFriends:NO success:success failure:failure];
}


-(void) fetchFriendActivitiesWithSuccess:(void (^)(NSArray *activities))success
                                 failure:(void (^)(NSError *error))failure
{
    [self fetchActivitiesWithParameters:nil
                             forFriends:YES
                                success:success
                                failure:failure];

}

-(void) fetchFriendActivitiesWithPageSize:(NSInteger)pageSize
                    pageIndex:(NSInteger)pageIndex
                      success:(void (^)(NSArray *activities))success
                      failure:(void (^)(NSError *error))failure
{
    NSDictionary *params = @{ @"page": @(pageIndex),
                              @"per_page": @(pageSize) };
    
    [self fetchActivitiesWithParameters:params forFriends:YES success:success failure:failure];
}


-(void) fetchPhotosForActivity:(NSInteger)activityId
                       success:(void (^)(NSArray *photos))success
                       failure:(void (^)(NSError *error))failure
{
    NSDictionary *params = @{ @"access_token" : self.accessToken };
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:self.baseURL];
    
    [manager GET:[NSString stringWithFormat:@"activities/%ld/photos", (long) activityId]
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             if (responseObject == nil) {
                 success(@[]);
                 return;
             }
             
             NSError *error = nil;
             
             NSDictionary *wrapper = @{ @"photos": responseObject };
             
             ActivityResponse *response = [MTLJSONAdapter modelOfClass:[ActivityResponse class]
                                                    fromJSONDictionary:wrapper
                                                                 error:&error];
             
             if (error) {
                 failure(error);
             } else {
                 NSArray *arr = response.photos;
                 success(arr);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure(error);
         }];

}

-(void) fetchZonesForActivity:(NSInteger)activityId
                      success:(void (^)(NSArray *zones))success
                      failure:(void (^)(NSError *error))failure
{
    NSDictionary *params = @{ @"access_token" : self.accessToken };
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:self.baseURL];
    
    [manager GET:[NSString stringWithFormat:@"activities/%ld/zones", (long) activityId]
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             if (responseObject == nil) {
                 success(@[]);
                 return;
             }
             
             NSError *error = nil;
             
             NSDictionary *wrapper = @{ @"zones": responseObject };
             
             ActivityResponse *response = [MTLJSONAdapter modelOfClass:[ActivityResponse class]
                                                    fromJSONDictionary:wrapper
                                                                 error:&error];
             
             if (error) {
                 failure(error);
             } else {
                 NSArray *arr = response.zones;
                 success(arr);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure(error);
         }];

}

// activity comments

-(void) fetchCommentsForActivity:(NSInteger)activityId
                        markdown:(BOOL)markdown
                        pageSize:(NSInteger)pageSize
                       pageIndex:(NSInteger)pageIndex
                         success:(void (^)(NSArray *comments))success
                         failure:(void (^)(NSError *error))failure
{
    NSDictionary *params = @{ @"access_token" : self.accessToken,
                              @"page": @(pageIndex),
                              @"per_page": @(pageSize) };
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:self.baseURL];
    
    [manager GET:[NSString stringWithFormat:@"activities/%ld/comments", (long) activityId]
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             if (responseObject == nil) {
                 success(@[]);
                 return;
             }
             
             NSError *error = nil;
             
             NSDictionary *wrapper = @{ @"comments": responseObject };
             
             ActivityResponse *response = [MTLJSONAdapter modelOfClass:[ActivityResponse class]
                                                    fromJSONDictionary:wrapper
                                                                 error:&error];
             
             if (error) {
                 failure(error);
             } else {
                 NSArray *arr = response.comments;
                 success(arr);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure(error);
         }];

}

// kudos

-(void) fetchKudoersForActivity:(NSInteger)activityId
                       pageSize:(NSInteger)pageSize
                      pageIndex:(NSInteger)pageIndex
                        success:(void (^)(NSArray *athletes))success
                        failure:(void (^)(NSError *error))failure
{
    NSDictionary *params = @{ @"access_token" : self.accessToken,
                              @"page": @(pageIndex),
                              @"per_page": @(pageSize)  };
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:self.baseURL];
    
    [manager GET:[NSString stringWithFormat:@"activities/%ld/kudos", (long) activityId]
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             if (responseObject == nil) {
                 success(@[]);
                 return;
             }
             
             NSError *error = nil;
             
             NSDictionary *wrapper = @{ @"kudoers": responseObject };
             
             ActivityResponse *response = [MTLJSONAdapter modelOfClass:[ActivityResponse class]
                                                    fromJSONDictionary:wrapper
                                                                 error:&error];
             
             if (error) {
                 failure(error);
             } else {
                 NSArray *arr = response.kudoers;
                 success(arr);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure(error);
         }];

}



#pragma private 

-(void) fetchActivitiesWithParameters:(NSDictionary *)params
                           forFriends:(BOOL)showFriends
                              success:(void (^)(NSArray *activities))success
                              failure:(void (^)(NSError *error))failure
{
    if (params == nil) {
        params = @{};
    }

    // add the access token to the provided params dictionary.
    NSMutableDictionary *mutableParams = [params mutableCopy];
    
    [mutableParams addEntriesFromDictionary:@{ @"access_token" : self.accessToken }];

    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:self.baseURL];

    [manager GET:showFriends ? @"activities/following" : @"activities"
      parameters:mutableParams
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSError *error = nil;
             
             NSDictionary *wrapper = @{ @"activities": responseObject };
             
             ActivityResponse *response = [MTLJSONAdapter modelOfClass:[ActivityResponse class]
                                                    fromJSONDictionary:wrapper
                                                                 error:&error];

             if (error) {
                 failure(error);
             } else {
                 NSArray *arr = response.activities;
                 success(arr);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure(error);
         }];
}



@end
