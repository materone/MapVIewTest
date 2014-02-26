//
//  RouteViewController.m
//  MapVIewTest
//
//  Created by tony on 14-2-26.
//  Copyright (c) 2014年 tony. All rights reserved.
//

#import "RouteViewController.h"

@interface RouteViewController ()

@end

@implementation RouteViewController

@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)markroute:(id)sender {
    NSLog(@"Click route button");
    //caculate route
    [self caculateRoute];
    [self updateRouteView];
    //[self centerMap];
}

-(void)caculateRoute {
//    NSString *routeFilePath = [[NSBundle mainBundle] pathForResource:@"route" ofType:@"dat"] ;
//    NSString *strRoute = [NSString stringWithContentsOfFile:routeFilePath];
    CLLocation *start= [[CLLocation alloc]initWithLatitude:113.9368209838867188 longitude:22.5176277160644531];
    CLLocation *end= [[CLLocation alloc]initWithLatitude:113.9277038574218750 longitude:22.5169353485107422];
    routes = [NSArray arrayWithObjects:start, end,nil];
}

-(void) updateRouteView {
    [mapView removeOverlays:mapView.overlays];
    
    CLLocationCoordinate2D pointsToUse[[routes count]];
    for (int i = 0; i < [routes count]; i++) {
        CLLocationCoordinate2D coords;
        CLLocation *loc = [routes objectAtIndex:i];
        coords.latitude = loc.coordinate.latitude;
        coords.longitude = loc.coordinate.longitude;
        pointsToUse[i] = coords;
    }
    MKPolyline *lineOne = [MKPolyline polylineWithCoordinates:pointsToUse count:[routes count]];
    [mapView addOverlay:lineOne];
}

-(void) centerMap {
    
	MKCoordinateRegion region;
    
	CLLocationDegrees maxLat = -90;
	CLLocationDegrees maxLon = -180;
	CLLocationDegrees minLat = 90;
	CLLocationDegrees minLon = 180;
	for(int idx = 0; idx < routes.count; idx++)
	{
		CLLocation* currentLocation = [routes objectAtIndex:idx];
		if(currentLocation.coordinate.latitude > maxLat)
			maxLat = currentLocation.coordinate.latitude;
		if(currentLocation.coordinate.latitude < minLat)
			minLat = currentLocation.coordinate.latitude;
		if(currentLocation.coordinate.longitude > maxLon)
			maxLon = currentLocation.coordinate.longitude;
		if(currentLocation.coordinate.longitude < minLon)
			minLon = currentLocation.coordinate.longitude;
	}
	region.center.latitude     = (maxLat + minLat) / 2;
	region.center.longitude    = (maxLon + minLon) / 2;
	region.span.latitudeDelta  = maxLat - minLat + 0.018;
	region.span.longitudeDelta = maxLon - minLon + 0.018;
    
	[mapView setRegion:region animated:YES];
}

#pragma mark MapView delegate functions


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView *lineview=[[MKPolylineView alloc] initWithOverlay:overlay] ;
        //路线颜色
        lineview.strokeColor=[UIColor colorWithRed:69.0f/255.0f green:212.0f/255.0f blue:255.0f/255.0f alpha:0.9];
        lineview.lineWidth=8.0;
        return lineview;
    }
    return nil;
}
@end
