# FRDStravaClient

## The library

### overview

FRDStravaClient is an objective-C library to the [Strava v3 API](http://strava.github.io/api/).
It was developed for iOS, it may work on OSX, I have not tried.

It supports read operations for most endpoints as well as activity upload.

The library was originaly developed to support my app [SpinSpin](http://www.spinspinapp.com), an indoor cycling app, and open-sourced
for prosperity (MIT license). It is not affiliated with Strava. [SpinSpin](http://www.spinspinapp.com) uses only a small subset of
the library, so I also made a quick test demo app described in the second half of this page.

FRDStravaClient uses [AFNetworking](https://github.com/AFNetworking/AFNetworking) for networking,
and [Mantle](https://github.com/Mantle/Mantle) to convert the JSON NSDictionary responses into usable model objects.

It consists of a bunch of model objects `StravaXXX` (e.g. `StravaActivity`,
`StravaAthlete`, etc...) and a client class `FRDStravaClient` that encapsulates the AFHTTPRequestOperationManager calls.

Model objects are all subclasses of `MTLModel`, and they closely follow the structure of the Strava API response objects.
FRDStravaClient is a singleton object (use `[FRDStravaClient sharedInstance]`) with a bunch of methods that match closely
the Rest API endpoints. FRDStravaClient calls are grouped into 9 categories `FRDStravaClient+XXX` e.g. `FRDStravaClient+Activity`,
`FRDStravaClient+Athlete`, etc... They all follow the same pattern:

```
-(void) fetchActivitiesForCurrentAthleteWithPageSize:(NSInteger)pageSize
                                           pageIndex:(NSInteger)pageIndex
                                             success:(void (^)(NSArray *activities))success
                                             failure:(void (^)(NSError *error))failure;

-(void) fetchAthleteWithId:(NSInteger)athleteId
                   success:(void (^)(StravaAthlete *athlete))success
                   failure:(void (^)(NSError *error))failure;
```

### Installation

Using cocoapods:

`pod FRDStravaClient ~> 0.0.6`

By hand:

You need all the stuff in the `Classes/` folder, `AFNetworking` version x.x and `Mantle` version x.x.x.

### reference

The header files have appledoc comments, see documentation is on 
[FRDStravaClient Cocoadocs page](http://cocoadocs.org/docsets/FRDStravaClient/0.0.6/).


describe auth flow here.

## The test App

This is an ugly, quick and dirty app, done for testing purpose only. Copy and paste at your own risk.

