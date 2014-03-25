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
    annos = [[NSMutableArray alloc]init];
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
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"route" ofType:@"csv"];
    [self caculateRoute:filePath isArray:NO];
    [self updateRouteView];
    [self centerMap];
}

- (IBAction)clear:(id)sender {
    [mapView removeOverlays:mapView.overlays];
    [mapView removeAnnotations:mapView.annotations];
    //some time func
    NSCalendar *now = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit |NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDate *date = [NSDate date];
    NSDateComponents *comps = [now components:unitFlags fromDate:date];
    NSLog(@"%02ld:%02ld:%02ld",(long)[comps hour] ,(long)[comps minute] ,(long)[comps second] );
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    NSLog(@"formattedDateString: %@", formattedDateString);
}

- (IBAction)liveShow:(id)sender {
    NSLog(@"Click live button");
    //caculate route
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"route" ofType:@"trk"];
    [self caculateRoute:filePath isArray:YES];
    //if count of routes == 0 then return , can not update the map
    if([routes count] == 0){
        return ;
    }
    [self updateRouteView];
    [self centerMap];
}

-(void)caculateRoute :(NSString*) filePath isArray:(BOOL)flag{
    NSString* fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray* pointStrings = nil;
    if(flag){
        pointStrings = [[NSArray alloc]initWithContentsOfFile:filePath];
    }else{
        pointStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    if (pointStrings == nil) {
        return;
    }
    
    //show
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Load Track File" message:[NSString stringWithFormat:@"Point Counts :%lu",(unsigned long)[pointStrings count]] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [alert show];
    
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
    //calculate distance
    CLLocationDistance distance = 0;
    int countOfAnno = 0;
    
    for (int i = 0; i < [routes count]; i++) {
        CLLocationCoordinate2D coords;
        CLLocation *loc = [routes objectAtIndex:i];
        //make a china map modify
        if (![WGS84TOGCJ02 isLocationOutOfChina:[loc coordinate]]) {
            //转换后的coord
            coords = [WGS84TOGCJ02 transformFromWGSToGCJ:[loc coordinate]];
        }else{
            coords = [loc coordinate];
        }
        pointsToUse[i] = coords;
        
        //calculate annotations
        if (i == 0) {
            from = loc;
            anno = [[Place alloc]init];
            anno.Name = [[NSString alloc]initWithFormat:@"%i",countOfAnno++] ;
            anno.title = anno.Name;
            anno.coordinate = coords;
        }else{
            to = loc;
            distance += [to distanceFromLocation:from];
            //NSLog(@"distance :%f",distance);
            if (distance >= 1000.00f) {
                anno = [[Place alloc]init];
                anno.Name = [[NSString alloc]initWithFormat:@"%i",countOfAnno++] ;
                anno.title = anno.Name;
                anno.coordinate = coords;
                distance = 0;
            }
            from = to;
        }
        [annos addObject:anno];
    }
    MKPolyline *lineOne = [MKPolyline polylineWithCoordinates:pointsToUse count:[routes count]];
    [mapView addOverlay:lineOne];
    [mapView addAnnotations:annos];
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
        lineview.lineWidth=6.0;
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
