//
//  UILabel+imageLabel.h
//  LLYSceneKitDemo
//
//  Created by lly on 2017/8/1.
//  Copyright © 2017年 lly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (imageLabel)


//将label转为图片资源，在勋章显示时需要使用
+ (UIImage *)imageLabelWithAttributeText:(NSMutableAttributedString *)text backgroundColor:(UIColor *)backgroundColor frame:(CGRect)frame;


@end
