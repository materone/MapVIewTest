//
//  BlockUIAlertView.m
//  MapVIewTest
//
//  Created by tony on 14-3-17.
//  Copyright (c) 2014年 tony. All rights reserved.
//

#import "BlockUIAlertView.h"

@implementation BlockUIAlertView
@synthesize block;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle clickButton:(AlertBlock)_block otherButtonTitles:(NSString *)otherButtonTitles{
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if(self){
        self.block = _block;
    }
    return self;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    self.block(buttonIndex);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
