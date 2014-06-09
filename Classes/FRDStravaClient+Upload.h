//
//  FRDStravaClient+Upload.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/27/14.
//

#import "FRDStravaClient.h"
#import "StravaCommon.h"
#import "StravaActivityUploadStatus.h"

typedef NS_ENUM(NSInteger, kUploadDataType) {
    kUploadDataTypeFIT,
    kUploadDataTypeGPX,
    kUploadDataTypeTCX,
    kUploadDataTypeFITGZ,
    kUploadDataTypeGPXGZ,
    kUploadDataTypeTCXGZ
};

@interface FRDStravaClient (Upload)

/**
 Upload an activity file.
 
 Strava API related documentation: http://strava.github.io/api/v3/uploads/#post-file
 
 Once upload successfuly completed, you can check the upload activity status of that ride by calling checkStatusOfUpload:success:failure:
 using the uploadStatus.id passed in the callback.
 
 @param fileURL URL of the new activity file, TCP/FIT or GPX.
 @param name activity name
 @param activityType activity type
 @param dataType upload data type (TCX, GPX, FIT)
 @param private wether the new activity should be private or not
 @param success Success callback
 @param failure Failure callback
 */
-(void) uploadActivity:(NSURL *)fileURL
                  name:(NSString *)name
          activityType:(kActivityType)activityType
              dataType:(kUploadDataType)dataType
               private:(BOOL)private
               success:(void (^)(StravaActivityUploadStatus *uploadStatus))success
               failure:(void (^)(NSError *error))failure;

/**
 Check the status of a previous upload.
 
 Strava API related documentation: http://strava.github.io/api/v3/uploads/#get-status
 
 A non zero activityId in the StravaActivityUploadStatus response object indicates the upload processing is complete.
 Success callback being call does not mean the upload was successful, just the call to get the status was.
 
 @param fileURL URL of the new activity file, TCP/FIT or GPX.
 @param name activity name
 @param activityType activity type
 @param dataType upload data type (TCX, GPX, FIT)
 @param private wether the new activity should be private or not
 @param success Success callback
 @param failure Failure callback
 */
-(void) checkStatusOfUpload:(NSInteger)uploadId
                    success:(void (^)(StravaActivityUploadStatus *uploadStatus))success
                    failure:(void (^)(NSError *error))failure;

@end
