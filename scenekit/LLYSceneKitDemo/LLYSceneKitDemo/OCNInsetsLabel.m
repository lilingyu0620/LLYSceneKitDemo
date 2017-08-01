//
//  OCNInsetsLabel.m
//  OpenCourse
//
//  Created by lly on 2017/6/21.
//  Copyright © 2017年 NetEase.com, Inc. All rights reserved.
//

#import "OCNInsetsLabel.h"

@interface OCNInsetsLabel ()

@property(nonatomic) UIEdgeInsets insets;

@end

@implementation OCNInsetsLabel

-(id) initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if(self){
        self.insets = insets;
    }
    return self;
}

-(id) initWithInsets:(UIEdgeInsets)insets {
    self = [super init];
    if(self){
        self.insets = insets;
    }
    return self;
}

-(void) drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

@end
