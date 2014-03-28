//
//  RouteDataViewer.h
//  MapVIewTest
//
//  Created by tony on 14-2-28.
//  Copyright (c) 2014年 tony. All rights reserved.
//  2014-03-10

#import <UIKit/UIKit.h>

@interface RouteDataViewer : UITableViewController{
    NSArray *routesLat;
    NSArray *routesLong;
    NSMutableArray *files;
    NSString *DocDir;
    NSFileManager *fm;
    NSDictionary *fileAttr;
}
@property (strong, nonatomic) IBOutlet UITableView *tabView;

@property (strong,nonatomic) NSString *data;

- (IBAction)doBack:(id)sender;

@end
