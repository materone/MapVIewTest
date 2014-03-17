//
//  BlockUIAlertView.h
//  MapVIewTest
//
//  Created by tony on 14-3-17.
//  Copyright (c) 2014年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertBlock)(NSInteger);
@interface BlockUIAlertView : UIAlertView

@property(nonatomic,copy) AlertBlock block;

-(id)initWithTitle:(NSString *)title
           message:(NSString *)message
 cancelButtonTitle:(NSString *)cancelButtonTitle
       clickButton:(AlertBlock)_block
 otherButtonTitles:(NSString *)otherButtonTitles;

@end
