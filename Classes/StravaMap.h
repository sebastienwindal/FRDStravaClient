//
//  StravaMap.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/30/14.
//

#import <Mantle/Mantle.h>
#import "StravaCommon.h"


@interface StravaMap : MTLModel<MTLJSONSerializing>

@property (nonatomic, readonly) NSInteger id;
@property (nonatomic, readonly) NSString *polyline;
@property (nonatomic, readonly) NSString *summaryPolyline;
@property (nonatomic, readonly) kResourceState resourceState;

+ (NSArray *) decodePolyline:(NSString *)encodedPoints;

@end
