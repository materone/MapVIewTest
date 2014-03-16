//
//  RouteViewController.h
//  MapVIewTest
//
//  Created by tony on 14-2-26.
//  Copyright (c) 2014年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WGS84TOGCJ02.h"
#import "Place.h"

@interface RouteViewController : UIViewController<MKMapViewDelegate>{
    NSArray* routes;
    CLLocation *from;
    CLLocation *to;
    NSMutableArray * annos;
    Place *anno;
}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)markroute:(id)sender;
- (IBAction)clear:(id)sender;
- (IBAction)liveShow:(id)sender;

@end
