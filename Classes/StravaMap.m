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

@end
