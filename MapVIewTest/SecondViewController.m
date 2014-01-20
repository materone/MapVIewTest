//
//  SecondViewController.m
//  MapVIewTest
//
//  Created by tony on 14-1-9.
//  Copyright (c) 2014年 tony. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController
@synthesize mapView;
@synthesize btnShowLocation;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    mapView.mapType = MKMapTypeHybrid;
    mapView.showsUserLocation = YES;
    //core location api
    self.clManager = [[CLLocationManager alloc] init];
    _clManager.delegate = self;
    _clManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.clManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)mark:(id)sender {
    NSLog(@"This is a mark test");
    
}

- (IBAction)showLocation:(id)sender {
    NSLog(@"1%@",[btnShowLocation titleForState:UIControlStateNormal]);
    if ([[btnShowLocation titleForState:UIControlStateNormal]
         isEqualToString:@"Show"]) {
        [btnShowLocation setTitle:@"Hide"
                         forState:UIControlStateNormal];
        mapView.showsUserLocation = YES;
    } else {
        [btnShowLocation setTitle:@"Show"
                         forState:UIControlStateNormal];
        mapView.showsUserLocation = NO;
    }
}

#pragma mark - CoreLocation Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *newLocation = [locations lastObject];
    NSString *latitudeStr = [NSString stringWithFormat:@"%g\u00B0",newLocation.coordinate.latitude];
    _latitudeLable.text = latitudeStr;
    NSString *longitudeStr = [NSString stringWithFormat:@"%g\u00B0",newLocation.coordinate.longitude];
    _longitudeLable.text = longitudeStr;
    NSString *horiAccuStr = [NSString stringWithFormat:@"%gm",newLocation.horizontalAccuracy];
    _horizoneAccuLable.text = horiAccuStr;
    NSString *altitudeStr = [NSString stringWithFormat:@"%gm",newLocation.altitude];
    _altitudeLable.text = altitudeStr;
    NSString *verticalAccu = [NSString stringWithFormat:@"%gm",newLocation.verticalAccuracy];
    _verticalAccuLable.text = verticalAccu;
    
    //if accuracy is too low , drop it
    if(newLocation.horizontalAccuracy <0 || newLocation.verticalAccuracy < 0){
        return;
    }
    if(newLocation.horizontalAccuracy >100 || newLocation.verticalAccuracy > 50){
        return;
    }
    if(_startLocation == nil){
        self.startLocation = newLocation;
        self.distanceFromStart = 0;
        Place *start = [[Place alloc] init];
        start.coordinate = newLocation.coordinate;
        start.title = @"Tony's Start Point";
        start.subtitle = @"This is the dream started!";
        [mapView addAnnotation:start];
        MKCoordinateRegion region;
        region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate,100, 100);
        [mapView setRegion:region animated:YES];
    }else{
        self.distanceFromStart = [newLocation distanceFromLocation:_startLocation];
    }
    NSString *distanceStr = [NSString stringWithFormat:@"%gm",_distanceFromStart];
    _distanceLable.text = distanceStr;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSString *errorType = (error.code == kCLErrorDenied) ?
    @"Access Denied" : @"Unknown Error";
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error getting Location"
                          message:errorType
                          delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil];
    [alert show];
}
@end
