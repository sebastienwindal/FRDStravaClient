//
//  StravaActivityUploadStatus.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/27/14.
//

#import <Mantle/Mantle.h>

///
/// Activity Upload Status object.
///
/// Strava API maching docs: http://strava.github.io/api/v3/uploads/#post-file
///
@interface StravaActivityUploadStatus : MTLModel<MTLJSONSerializing>

@property (nonatomic, readonly) NSInteger id;
@property (nonatomic, readonly, copy) NSString *externalId;
@property (nonatomic, readonly, copy) NSString *error;
@property (nonatomic, readonly, copy) NSString *status;
@property (nonatomic, readonly) NSInteger activityId;

@end
