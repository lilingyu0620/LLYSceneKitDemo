//
//  UIButton+OCNEnlargeArea.h
//  OpenCourse
//
//  Created by lly on 2017/6/12.
//  Copyright © 2017年 NetEase.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

//修改button的热区

@interface UIButton (OCNEnlargeArea)

- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end
