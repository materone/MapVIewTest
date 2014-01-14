//
//  SecondViewController.h
//  MapVIewTest
//
//  Created by tony on 14-1-9.
//  Copyright (c) 2014年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SecondViewController : UIViewController
{
    IBOutlet UIButton *btnShowLocation;
    IBOutlet MKMapView *mapView;
}

@property (nonatomic, retain) UIButton *btnShowLocation;
@property (nonatomic, retain) MKMapView *mapView;

-(IBAction)mark:(id)sender;
-(IBAction) showLocation:(id) sender;
@end
