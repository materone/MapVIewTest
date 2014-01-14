//
//  FirstViewController.m
//  MapVIewTest
//
//  Created by tony on 14-1-9.
//  Copyright (c) 2014年 tony. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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
    
    if(newLocation.horizontalAccuracy <0 || newLocation.verticalAccuracy < 0){
        return;
    }
    if(newLocation.horizontalAccuracy >100 || newLocation.verticalAccuracy > 50){
        return;
    }
    if(_startLocation == nil){
        self.startLocation = newLocation;
        self.distanceFromStart = 0;
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
