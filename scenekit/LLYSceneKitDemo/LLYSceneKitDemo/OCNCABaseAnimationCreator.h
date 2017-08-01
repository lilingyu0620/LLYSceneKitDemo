//
//  OCNCABaseAnimationCreator.h
//  OpenCourse
//
//  Created by lly on 2017/6/30.
//  Copyright © 2017年 NetEase.com, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OCNCABaseAnimationCreator : NSObject


/**
 UIView的scale动画

 @param fromScale 初始值
 @param toScale 目标值
 @param dura 时长
 @param isRemove 动画结束后是否自动移除
 @return 动画对象
 */
+ (CABasicAnimation *)viewScaleAnimation:(id)fromScale toScale:(id)toScale dur:(CGFloat)dura removeOnCompletion:(BOOL)isRemove;



/**
 UIView的alpha动画

 @param fromValue 初始值
 @param toValue 目标值
 @param dura 时长
 @param isRemove 动画结束后是否自动移除
 @return 动画对象
 */
+ (CABasicAnimation *)viewAlphaAnimation:(id)fromValue toValue:(id)toValue dur:(CGFloat)dura removeOnCompletion:(BOOL)isRemove;



/**
 UIView的ZPosition动画

 @param fromValue 初始值
 @param toValue 目标值
 @param dura 时长
 @param isRemove 动画结束后是否自动移除
 @return 动画对象
 */
+ (CABasicAnimation *)viewZPositionAnimation:(id)fromValue toValue:(id)toValue dur:(CGFloat)dura removeOnCompletion:(BOOL)isRemove;




/**
 UIView的Path动画

 @param path 动画路径
 @param dura 时长
 @param isRemove 动画结束后是否自动移除
 @return 动画对象
 */
+ (CAKeyframeAnimation *)viewPathAnimation:(UIBezierPath *)path dur:(CGFloat)dura removeOnCompletion:(BOOL)isRemove;


/**
 UIView的Position动画
 
 @param fromValue 初始值
 @param toValue 目标值
 @param dura 时长
 @param isRemove 动画结束后是否自动移除
 @return 动画对象
 */
+ (CABasicAnimation *)viewPositionAnimation:(id)fromValue toValue:(id)toValue dur:(CGFloat)dura removeOnCompletion:(BOOL)isRemove;

@end
