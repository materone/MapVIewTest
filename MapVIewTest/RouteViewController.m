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
    [mapView setDelegate:self];
    mapView.mapType = MKMapTypeHybrid;
    mapView.showsUserLocation = YES;
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
    [self centerMap];
}

-(void)caculateRoute {
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"route" ofType:@"csv"];
    NSString* fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray* pointStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // create a c array of points.
    NSMutableArray *pts = [[NSMutableArray alloc]init];
    
    for(int idx = 0; idx < pointStrings.count; idx++)
    {
        // break the string down even further to latitude and longitude fields.
        NSString* currentPointString = [pointStrings objectAtIndex:idx];
        NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        
        CLLocationDegrees longitude = [[latLonArr objectAtIndex:0] doubleValue];
        CLLocationDegrees latitude = [[latLonArr objectAtIndex:1] doubleValue];
        
        //NSLog(@"LAT:%f Lon:%f",latitude,longitude);
        // create our coordinate and add it to the correct spot in the array
        CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
        
        pts[idx] = location;
        
    }
    routes = pts;
}

-(void) updateRouteView {
    [mapView removeOverlays:mapView.overlays];
    
    CLLocationCoordinate2D pointsToUse[[routes count]];
    for (int i = 0; i < [routes count]; i++) {
        CLLocationCoordinate2D coords;
        CLLocation *loc = [routes objectAtIndex:i];
//        coords.latitude = loc.coordinate.latitude;
//        coords.longitude = loc.coordinate.longitude;
        //NSLog(@"AAL:%f AAM:%f",loc.coordinate.latitude,loc.coordinate.longitude);
        //make a china map modify
        if (![WGS84TOGCJ02 isLocationOutOfChina:[loc coordinate]]) {
            //转换后的coord
            coords = [WGS84TOGCJ02 transformFromWGSToGCJ:[loc coordinate]];
        }
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
	[mapView setRegion: region animated:YES];
   
}

#pragma mark MapView delegate functions


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView *lineview=[[MKPolylineView alloc] initWithOverlay:overlay] ;
        //路线颜色
        lineview.strokeColor=[UIColor colorWithRed:69.0f/255.0f green:212.0f/255.0f blue:255.0f/255.0f alpha:0.9];
        lineview.lineWidth=2.0;
        return lineview;
    }
    return nil;
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"the segue is %@",segue.identifier);
    UIViewController *dest = segue.destinationViewController;
    if([dest respondsToSelector:@selector(setData:)]){
        NSLog(@"in dest %@",[dest description]);
        [dest setValue:@"route.csv" forKey:@"data"];
    }
}

@end
