//
//  IconHelper.m
//  FRDStravaClient
//
//  Created by Sebastien Windal on 5/1/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "IconHelper.h"

@implementation IconHelper

+(void) makeThisLabel:(UILabel *)label
               anIcon:(char *)iconCode
               ofSize:(CGFloat)size
{
    UIFont *font = [UIFont fontWithName:@"icomoon" size:size];
    
    label.font = font;
    label.text = [NSString stringWithUTF8String:iconCode];
}

+(void) makeThisButton:(UIButton *)button
                anIcon:(char *)iconCode
                ofSize:(CGFloat)size
{
    UIFont *font = [UIFont fontWithName:@"icomoon" size:size];
    
    [button setTitle:[NSString stringWithUTF8String:iconCode] forState:UIControlStateNormal];
    button.titleLabel.font = font;
}

@end
