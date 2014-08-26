//
//  StravaMap.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/30/14.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "StravaMap.h"

@implementation StravaMap

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"id": @"id",
             @"polyline": @"polyline",
             @"summaryPolyline": @"summary_polyline",
             @"resourceState": @"resource_state"
             };
}

#define HANDLE_NIL_FOR_KEY(keyname,ivar,value) if ([key isEqualToString:keyname]) { ivar = value; }

-(void) setNilValueForKey:(NSString *)key
{
    HANDLE_NIL_FOR_KEY(@"id",               _id,            0);
    HANDLE_NIL_FOR_KEY(@"resourceState",    _resourceState, kResourceStateUnknown);
}



+ (NSArray *) decodePolyline:(NSString *)encodedPoints
{
    NSString *escapedEncodedPoints = [encodedPoints stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
    
    NSInteger len = [escapedEncodedPoints length];
    NSMutableArray *waypoints = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    CGFloat lat = 0;
    CGFloat lng = 0;

    while (index < len) {
        char b;
        int shift = 0;
        int result = 0;
        do {
            b = [escapedEncodedPoints characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
      
        float dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
      
        shift = 0;
        result = 0;
        do {
            b = [escapedEncodedPoints characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
      
        float dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
      
        float finalLat = lat * 1e-5;
        float finalLong = lng * 1e-5;
      
        CLLocationCoordinate2D newPoint;

        newPoint.latitude = finalLat;
        newPoint.longitude = finalLong;
        [waypoints addObject:[NSValue valueWithMKCoordinate:newPoint]];
    }
    return waypoints;
}

+ (MKPolyline *)decodePolylineToMKPolyline:(NSString *)encodedPoints
{
    const char *bytes = [encodedPoints UTF8String];
    NSUInteger length = [encodedPoints lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
	
    NSUInteger count = length / 4;
    CLLocationCoordinate2D *coords = calloc(count, sizeof(CLLocationCoordinate2D));
    NSUInteger coordIdx = 0;
	
    float latitude = 0;
    float longitude = 0;
    while (idx < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;
		
        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
		
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
		
        shift = 0;
        res = 0;
		
        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
		
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
		
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
		
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
        coords[coordIdx++] = coord;
		
        if (coordIdx == count) {
            NSUInteger newCount = count + 10;
            coords = realloc(coords, newCount * sizeof(CLLocationCoordinate2D));
            count = newCount;
        }
    }
	
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:coordIdx];
    free(coords);
	
    return polyline;
}

@end
