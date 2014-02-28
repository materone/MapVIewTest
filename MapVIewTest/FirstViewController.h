//
//  FirstViewController.h
//  MapVIewTest
//
//  Created by tony on 14-1-9.
//  Copyright (c) 2014年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FirstViewController : UIViewController <CLLocationManagerDelegate>

@property (weak,nonatomic) IBOutlet UILabel *gpsStatus;
@property (strong,nonatomic) CLLocationManager *clManager;
@property (strong,nonatomic) CLLocation *startLocation;
@property (assign,nonatomic) CLLocationDistance distanceFromStart;

@property (weak,nonatomic) IBOutlet UILabel *latitudeLable;
@property (weak,nonatomic) IBOutlet UILabel *longitudeLable;
@property (weak,nonatomic) IBOutlet UILabel *horizoneAccuLable;
@property (weak,nonatomic) IBOutlet UILabel *altitudeLable;
@property (weak,nonatomic) IBOutlet UILabel *verticalAccuLable;
@property (weak,nonatomic) IBOutlet UILabel *distanceLable;


@end
