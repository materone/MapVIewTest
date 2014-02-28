//
//  DetailVC.h
//  MapVIewTest
//
//  Created by tony on 14-2-28.
//  Copyright (c) 2014年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailVC : UITableViewController

@property (nonatomic,strong) NSString *data;
@property (strong, nonatomic) IBOutlet UILabel *dataContent;
- (IBAction)closeView:(id)sender;

@end
