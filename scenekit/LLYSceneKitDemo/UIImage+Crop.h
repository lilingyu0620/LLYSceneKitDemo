//
//  UIImage+Crop.h
//  LLYSceneKitDemo
//
//  Created by lly on 2017/6/10.
//  Copyright © 2017年 lly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Crop)
+(UIImage*)image:(UIImage *)image scaleToSize:(CGSize)size;
- (UIImage *)circleImage;
@end
