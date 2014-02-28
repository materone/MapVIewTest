//
//  RouteDataViewer.h
//  MapVIewTest
//
//  Created by tony on 14-2-28.
//  Copyright (c) 2014年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteDataViewer : UITableViewController{
    NSArray *routesLat;
    NSArray *routesLong;
}

@property (strong,nonatomic) NSString *data;

- (IBAction)doBack:(id)sender;

@end
