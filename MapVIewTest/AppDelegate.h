//
//  AppDelegate.h
//  MapVIewTest
//
//  Created by tony on 14-1-9.
//  Copyright (c) 2014年 tony. All rights reserved.
//  @mod 20140310 for ignor file update from xcode

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    BOOL bShowmap;
    NSString *fileRoutePath;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) NSString *fileRoutePath;
@property (nonatomic)BOOL bShowmap;
@end
