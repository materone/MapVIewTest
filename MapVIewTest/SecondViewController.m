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
    mapView.delegate = self;
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
    NSLog(@"This is a mark test,will show a track");    
//    [self loadRoute];
//    [self.mapView setVisibleMapRect:_routeRect];
//    [self.mapView addOverlay:self.routeLine];
    
    CLLocation *location0 = [[CLLocation alloc] initWithLatitude:39.954245 longitude:116.312455];
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:30.247871 longitude:120.127683];
    NSArray *array = [NSArray arrayWithObjects:location0, location1, nil];
    [self drawLineWithLocationArray:array];
}

#pragma mark -

- (void)drawLineWithLocationArray:(NSArray *)locationArray
{
    int pointCount = [locationArray count];
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < pointCount; ++i) {
        CLLocation *location = [locationArray objectAtIndex:i];
        coordinateArray[i] = [location coordinate];
    }
    
    self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    [self.mapView setVisibleMapRect:[self.routeLine boundingMapRect]];
    [self.mapView addOverlay:self.routeLine];
    
    free(coordinateArray);
    coordinateArray = NULL;
}
#pragma mark - MKMapViewDelegate

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if(overlay == self.routeLine) {
        if(nil == self.routeLineView) {
            self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine] ;
            self.routeLineView.fillColor = [UIColor redColor];
            self.routeLineView.strokeColor = [UIColor redColor];
            self.routeLineView.lineWidth = 5;
        }
        return self.routeLineView;
    }
    return nil;
}

-(void) loadRoute
{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"route" ofType:@"csv"];
    NSString* fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray* pointStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // while we create the route points, we will also be calculating the bounding box of our route
    // so we can easily zoom in on it.
    MKMapPoint northEastPoint;
    MKMapPoint southWestPoint;
    
    // create a c array of points.
    MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * pointStrings.count);
    
    for(int idx = 0; idx < pointStrings.count; idx++)
    {
        // break the string down even further to latitude and longitude fields.
        NSString* currentPointString = [pointStrings objectAtIndex:idx];
        NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        
        CLLocationDegrees latitude = [[latLonArr objectAtIndex:0] doubleValue];
        CLLocationDegrees longitude = [[latLonArr objectAtIndex:1] doubleValue];
        NSLog(@"LAT:%f",[[latLonArr objectAtIndex:0] doubleValue]);
        
        // create our coordinate and add it to the correct spot in the array
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        MKMapPoint point = MKMapPointForCoordinate(coordinate);
        
        //
        // adjust the bounding box
        //
        
        // if it is the first point, just use them, since we have nothing to compare to yet.
        if (idx == 0) {
            northEastPoint = point;
            southWestPoint = point;
        }
        else
        {
            if (point.x > northEastPoint.x)
                northEastPoint.x = point.x;
            if(point.y > northEastPoint.y)
                northEastPoint.y = point.y;
            if (point.x < southWestPoint.x)
                southWestPoint.x = point.x;
            if (point.y < southWestPoint.y)
                southWestPoint.y = point.y;
        }
        
        pointArr[idx] = point;
        
    }
    
    // create the polyline based on the array of points.
    self.routeLine = [MKPolyline polylineWithPoints:pointArr count:pointStrings.count];
    
    _routeRect = MKMapRectMake(southWestPoint.x, southWestPoint.y, northEastPoint.x - southWestPoint.x, northEastPoint.y - southWestPoint.y);
    
    // clear the memory allocated earlier for the points
    free(pointArr);
    
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay1:(id )overlay
{
    MKOverlayView* overlayView = nil;
    
    if(overlay == self.routeLine)
    {
        //if we have not yet created an overlay view for this overlay, create it now.
        if(nil == self.routeLineView)
        {
            self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine] ;
            self.routeLineView.fillColor = [UIColor redColor];
            self.routeLineView.strokeColor = [UIColor redColor];
            self.routeLineView.lineWidth = 3;
        }
        
        overlayView = self.routeLineView;
        
    }
    
    return overlayView;
    
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
