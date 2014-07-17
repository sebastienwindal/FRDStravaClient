//
//  FRDStravaClient+Upload.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/27/14.
//

#import "FRDStravaClient+Upload.h"
#import <Mantle/Mantle.h>
#import "AFNetworking.h"
#import "StravaActivityUploadStatus.h"
#import "StravaCommon.h"

@implementation FRDStravaClient (Upload)

-(void) uploadActivity:(NSURL *)fileURL
                  name:(NSString *)name
          activityType:(kActivityType)activityType
              dataType:(kUploadDataType)dataType
               private:(BOOL)private
               success:(void (^)(StravaActivityUploadStatus *uploadStatus))success
               failure:(void (^)(NSError *error))failure
{
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:self.baseURL];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken]
                     forHTTPHeaderField:@"Authorization"];

    NSString *activityTypeStr = [[[StravaCommon activityTypeJSONTransformer] reverseTransformedValue:@(activityType)] lowercaseString];
    
    NSDictionary *dict = @{     @(kUploadDataTypeFIT): @"fit",
                                @(kUploadDataTypeGPX): @"gpx",
                                @(kUploadDataTypeTCX): @"tcx",
                                @(kUploadDataTypeFITGZ): @"fit.gz",
                                @(kUploadDataTypeGPXGZ): @"gpx.gz",
                                @(kUploadDataTypeTCXGZ): @"tcx.gz"
                                };
    
    NSString *dataTypeStr = dict[@(dataType)];
    
    // AFNetworking does not parse JSON contained in a 400 response,
    // instead if just call the failure block.
    // Add the 4xx indexes in acceptable status codes just for upload so we do know why our
    // upload failed. This problem was encountered specifically when attempting to upload an activity
    // that was already been uploaded before.
    NSMutableIndexSet *indexset = [[NSMutableIndexSet alloc] initWithIndexSet:manager.responseSerializer.acceptableStatusCodes];
    [indexset addIndexesInRange:NSMakeRange(400, 99)];
    
    manager.responseSerializer.acceptableStatusCodes = indexset;
    
    [manager POST:@"uploads"
       parameters:nil
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
            [formData appendPartWithFormData:[private ? @"1" : @"0" dataUsingEncoding:NSUTF8StringEncoding] name:@"private"];
            [formData appendPartWithFormData:[activityTypeStr dataUsingEncoding:NSUTF8StringEncoding] name:@"activity_type"];
            [formData appendPartWithFormData:[dataTypeStr dataUsingEncoding:NSUTF8StringEncoding] name:@"data_type"];

            NSError *error;
    
            [formData appendPartWithFileURL:fileURL
                                       name:@"file"
                                   fileName:name
                                   mimeType:@"application/octet-stream"
                                      error:&error];
        }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSError *error;
              StravaActivityUploadStatus *status = [MTLJSONAdapter modelOfClass:[StravaActivityUploadStatus class]
                                                       fromJSONDictionary:responseObject
                                                                    error:&error];
              
              if (error) {
                  failure(error);
              } else {
                  if (status.error.length > 0) {
                      error = [[NSError alloc] initWithDomain:@"FRDStravaClientDomain"
                                                         code:1
                                                     userInfo:@{NSLocalizedDescriptionKey: status.error}];
                      failure(error);
                  } else {
                      success(status);
                  }
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(error);
          }];
     
}


-(void) checkStatusOfUpload:(NSInteger)uploadId
                    success:(void (^)(StravaActivityUploadStatus *uploadStatus))success
                    failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:self.baseURL];
    
    NSDictionary *params = @{ @"access_token" : self.accessToken };

    [manager GET:[NSString stringWithFormat:@"uploads/%ld", (long)uploadId]
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSError *error;
             StravaActivityUploadStatus *status = [MTLJSONAdapter modelOfClass:[StravaActivityUploadStatus class]
                                                            fromJSONDictionary:responseObject
                                                                         error:&error];
             
             if (error) {
                 failure(error);
             } else {
                 if (status.error.length > 0) {
                     error = [[NSError alloc] initWithDomain:@"FRDStravaClientDomain"
                                                        code:1
                                                    userInfo:@{NSLocalizedDescriptionKey: status.error}];
                     failure(error);
                 }
             }
             success(status);
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure(error);
         }];
}

@end
