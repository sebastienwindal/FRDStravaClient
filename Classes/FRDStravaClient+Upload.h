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
    kUploadDataTypesGPX,
    kUploadDataTypesTCX
};

@interface FRDStravaClient (Upload)

-(void) uploadActivity:(NSURL *)fileURL
                  name:(NSString *)name
          activityType:(kActivityType)activityType
              dataType:(kUploadDataType)dataType
               private:(BOOL)private
               success:(void (^)(StravaActivityUploadStatus *uploadStatus))success
               failure:(void (^)(NSError *error))failure;



@end
