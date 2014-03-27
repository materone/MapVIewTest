//
//  FirstViewController.m
//  MapVIewTest
//
//  Created by tony on 14-1-9.
//  Copyright (c) 2014年 tony. All rights reserved.
//	All rights will reserved in 10 years

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
    _clManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [self.clManager startUpdatingLocation];
    _gpsStatus.text = ([CLLocationManager locationServicesEnabled]?@"Yes":@"No");
    
    self.routes = [[NSMutableArray alloc]init];
    
    _filePath = [[NSBundle mainBundle] pathForResource:@"route" ofType:@"trk"];
    self.fileManager = [NSFileManager defaultManager];
    _fileAttr = [_fileManager attributesOfItemAtPath:_filePath error:nil];
    _fileInfo.text = [NSString stringWithFormat:@"%@",[_fileAttr valueForKey:NSFileSize]];
    _fileLastUpdate.text = [NSString stringWithFormat:@"%@",[_fileAttr valueForKey:NSFileModificationDate]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CoreLocation Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *newLocation = [locations lastObject];
    NSString *latitudeStr = [NSString stringWithFormat:@"%.16f\u00B0", newLocation.coordinate.latitude ];
    _latitudeLable.text = latitudeStr;
    NSString *longitudeStr = [NSString stringWithFormat:@"%.16f\u00B0",newLocation.coordinate.longitude];
    _longitudeLable.text = longitudeStr;
    NSString *horiAccuStr = [NSString stringWithFormat:@"%gm",newLocation.horizontalAccuracy];
    _horizoneAccuLable.text = horiAccuStr;
    NSString *altitudeStr = [NSString stringWithFormat:@"%gm",newLocation.altitude];
    _altitudeLable.text = altitudeStr;
    NSString *verticalAccu = [NSString stringWithFormat:@"%gm",newLocation.verticalAccuracy];
    _verticalAccuLable.text = verticalAccu;
    
    _gpsStatus.text = ([CLLocationManager locationServicesEnabled]?@"Yes":@"No");
    
    //if accuracy is too low , drop it
    if(newLocation.horizontalAccuracy <0 || newLocation.verticalAccuracy < -10){
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
    [_routes addObject:[[NSString alloc] initWithFormat:@"%.16f,%.16f",newLocation.coordinate.longitude,newLocation.coordinate.latitude]];
   // NSLog(@"add route %lu",(unsigned long)[_routes count]);
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
- (IBAction)save:(id)sender {
    //alert
    BlockUIAlertView *alert = [[BlockUIAlertView alloc]initWithTitle:@"Save Track File" message:[NSString stringWithFormat:@"Save Counts :%lu",(unsigned long)[_routes count]] cancelButtonTitle:@"Cancel" clickButton:^(NSInteger indexButton) {
        NSLog(@"%d click",indexButton);
        if (indexButton == 0) {
            return ;
        }else{
            NSLog(@"save track file");
            [self saveTrackFile];
        }
    } otherButtonTitles:@"Yes"];
    [alert show];
    [self getCurrentDate];
}

-(void)saveTrackFile{
    _filePath = [[NSBundle mainBundle] pathForResource:@"route" ofType:@"trk"];
    [_routes writeToFile:_filePath atomically:YES];
    _fileAttr = [_fileManager attributesOfItemAtPath:_filePath error:nil];
    _fileInfo.text = [NSString stringWithFormat:@"%@",[_fileAttr valueForKey:NSFileSize]];
    _fileLastUpdate.text = [NSString stringWithFormat:@"%@",[_fileAttr valueForKey:NSFileModificationDate]];
}

- (IBAction)delFile:(id)sender {
    _filePath = [[NSBundle mainBundle] pathForResource:@"route" ofType:@"trk"];
    [_routes removeAllObjects];
    [_routes writeToFile:_filePath atomically:YES];
    _fileAttr = [_fileManager attributesOfItemAtPath:_filePath error:nil];
    _fileInfo.text = [NSString stringWithFormat:@"%@",[_fileAttr valueForKey:NSFileSize]];
    _fileLastUpdate.text = [NSString stringWithFormat:@"%@",[_fileAttr valueForKey:NSFileModificationDate]];
}

-(NSString *)getCurrentDate{
    NSString *ret = nil;
    NSDate *now = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyyMMddHHmmssSSS"];
//    [df setTimeZone:[[NSTimeZone alloc]initWithName:@"CST"]];
    ret = [df stringFromDate:now];
    NSLog(@"Time:%@",ret);
    return ret;
}
@end
