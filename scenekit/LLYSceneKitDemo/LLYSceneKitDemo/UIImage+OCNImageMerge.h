//
//  UIImage+OCNImageMerge.h
//  OpenCourse
//
//  Created by lly on 2017/6/12.
//  Copyright © 2017年 NetEase.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (OCNImageMerge)


/**
 将两个图片合并为一个 注意这里是把image2贴到image1上

 @param image1 它比较大作为合并的图床
 @param frame1 大图的frame
 @param image2 它比较小，合并后的效果是直接贴在了image1上
 @param frame2 小图的frame
 @return 合并后的新图
 */
+ (UIImage *)mergeWithImage1:(UIImage *)image1 frame1:(CGRect)frame1 Image2:(UIImage *)image2 frame2:(CGRect)frame2;

@end
