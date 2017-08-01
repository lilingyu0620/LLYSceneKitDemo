//
//  OCNInsetsLabel.h
//  OpenCourse
//
//  Created by lly on 2017/6/21.
//  Copyright © 2017年 NetEase.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCNInsetsLabel : UILabel

- (id)initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;
- (id)initWithInsets:(UIEdgeInsets) insets;

@end
