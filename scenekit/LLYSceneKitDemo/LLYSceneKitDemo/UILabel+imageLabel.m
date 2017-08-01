//
//  UILabel+imageLabel.m
//  LLYSceneKitDemo
//
//  Created by lly on 2017/8/1.
//  Copyright © 2017年 lly. All rights reserved.
//

#import "UILabel+imageLabel.h"
#import "OCNInsetsLabel.h"

@implementation UILabel (imageLabel)

+ (UIImage *)imageLabelWithAttributeText:(NSMutableAttributedString *)text backgroundColor:(UIColor *)backgroundColor frame:(CGRect)frame{
    
    OCNInsetsLabel *myLabel = [[OCNInsetsLabel alloc] initWithFrame:frame andInsets:UIEdgeInsetsMake(-100, 0, 0, 0)];
    myLabel.numberOfLines = 0;
    myLabel.attributedText = text;
    myLabel.textAlignment = NSTextAlignmentCenter;
    myLabel.backgroundColor = backgroundColor;
    
    UIGraphicsBeginImageContextWithOptions(myLabel.bounds.size,NO,[UIScreen mainScreen].scale);
    [myLabel.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *layerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return layerImage;
    
}

@end
