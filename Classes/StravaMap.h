//
//  StravaMap.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/30/14.
//

#import <Mantle/Mantle.h>
#import "StravaCommon.h"


///
/// Activity Map object.
///
/// Strava API maching docs: http://strava.github.io/api/v3/activities/
///
@interface StravaMap : MTLModel<MTLJSONSerializing>

@property (nonatomic, readonly) NSInteger id;
/// Lat and lon points, encoded in Google http://strava.github.io/api/#polylines, @see +decodePolyline:
@property (nonatomic, readonly) NSString *polyline;
/// Summary Lat and lon points, encoded in Google http://strava.github.io/api/#polylines, @see +decodePolyline:
@property (nonatomic, readonly) NSString *summaryPolyline;
@property (nonatomic, readonly) kResourceState resourceState;

///
/// Helper methods to decode a polyline encoded in google polyline format. The returned NSArray contains MapKit friendly
/// CLLocationCoordinate2D structs, wrapped into NSData objects. Use the `NSValue` `MKCoordinateValue` property on
/// the elements of the NSArray to get the CLLocationCoordinate2D struct back.
///
/// Matching Strava Api documentation: http://strava.github.io/api/#polylines
///
/// @param encodedPoints A NSString, as returned by the Rest API, containing a list of GPS coordinates encoded Google polyline algorithm format
///
/// @return a NSArray of NSValue wrapped CLLocationCoordinate2D structs.
///
+ (NSArray *) decodePolyline:(NSString *)encodedPoints;

@end
