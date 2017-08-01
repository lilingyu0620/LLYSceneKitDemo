//
//  UIImage+OCNImageMerge.m
//  OpenCourse
//
//  Created by lly on 2017/6/12.
//  Copyright © 2017年 NetEase.com, Inc. All rights reserved.
//

#import "UIImage+OCNImageMerge.h"

@implementation UIImage (OCNImageMerge)

+ (UIImage *)mergeWithImage1:(UIImage *)image1 frame1:(CGRect)frame1 Image2:(UIImage *)image2 frame2:(CGRect)frame2{

    UIGraphicsBeginImageContextWithOptions(frame1.size,NO,[UIScreen mainScreen].scale);
    [image1 drawInRect:frame1];
    [image2 drawInRect:frame2];
    UIImage *mergeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return mergeImage;
}

@end
