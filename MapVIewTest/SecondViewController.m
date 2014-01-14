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
@end
