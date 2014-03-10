//
//  SecondViewController.h
//  MapVIewTest
//
//  Created by tony on 14-1-9.
//  Copyright (c) 2014年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "Place.h"

@interface SecondViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate>
{
    IBOutlet UIButton *btnShowLocation;
    IBOutlet MKMapView *mapView;
    NSMutableArray *routeData;
}

@property (strong,nonatomic) CLLocationManager *clManager;
@property (strong,nonatomic) CLLocation *startLocation;
@property (assign,nonatomic) CLLocationDistance distanceFromStart;
@property (strong,nonatomic) MKPolyline *routeLine;
@property (strong,nonatomic) MKPolylineView *routeLineView;
@property (assign,nonatomic) MKMapRect routeRect;

@property (weak,nonatomic) IBOutlet UILabel *latitudeLable;
@property (weak,nonatomic) IBOutlet UILabel *longitudeLable;
@property (weak,nonatomic) IBOutlet UILabel *horizoneAccuLable;
@property (weak,nonatomic) IBOutlet UILabel *altitudeLable;
@property (weak,nonatomic) IBOutlet UILabel *verticalAccuLable;
@property (weak,nonatomic) IBOutlet UILabel *distanceLable;

@property (nonatomic, retain) UIButton *btnShowLocation;
@property (nonatomic, retain) MKMapView *mapView;

-(IBAction)mark:(id)sender;
-(IBAction) showLocation:(id) sender;
@end
