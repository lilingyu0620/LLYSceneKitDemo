//
//  OCNCABaseAnimationCreator.m
//  OpenCourse
//
//  Created by lly on 2017/6/30.
//  Copyright © 2017年 NetEase.com, Inc. All rights reserved.
//

#import "OCNCABaseAnimationCreator.h"

@implementation OCNCABaseAnimationCreator


+ (CABasicAnimation *)viewScaleAnimation:(id)fromScale toScale:(id)toScale dur:(CGFloat)dura removeOnCompletion:(BOOL)isRemove{

    CABasicAnimation *scaleAni = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAni.fromValue = fromScale;
    scaleAni.toValue = toScale;
    scaleAni.duration = dura;
    scaleAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAni.removedOnCompletion = isRemove;
    scaleAni.fillMode = kCAFillModeForwards;
    
    return scaleAni;
}


+ (CABasicAnimation *)viewAlphaAnimation:(id)fromValue toValue:(id)toValue dur:(CGFloat)dura removeOnCompletion:(BOOL)isRemove{
    
    CABasicAnimation *scaleAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
    scaleAni.fromValue = fromValue;
    scaleAni.toValue = toValue;
    scaleAni.duration = dura;
    scaleAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAni.removedOnCompletion = isRemove;
    scaleAni.fillMode = kCAFillModeForwards;
    
    return scaleAni;
}

+ (CABasicAnimation *)viewZPositionAnimation:(id)fromValue toValue:(id)toValue dur:(CGFloat)dura removeOnCompletion:(BOOL)isRemove{
    
    CABasicAnimation *scaleAni = [CABasicAnimation animationWithKeyPath:@"zPosition"];
    scaleAni.fromValue = fromValue;
    scaleAni.toValue = toValue;
    scaleAni.duration = dura;
    scaleAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAni.removedOnCompletion = isRemove;
    scaleAni.fillMode = kCAFillModeForwards;
    
    return scaleAni;
}

+ (CAKeyframeAnimation *)viewPathAnimation:(UIBezierPath *)path dur:(CGFloat)dura removeOnCompletion:(BOOL)isRemove{
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = isRemove;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.path = (__bridge CGPathRef _Nullable)(path);

    return pathAnimation;

}

+ (CABasicAnimation *)viewPositionAnimation:(id)fromValue toValue:(id)toValue dur:(CGFloat)dura removeOnCompletion:(BOOL)isRemove{

    CABasicAnimation *posAni = [CABasicAnimation animationWithKeyPath:@"position"];
    posAni.fromValue = fromValue;
    posAni.toValue = toValue;
    posAni.duration = dura;
    posAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    posAni.removedOnCompletion = isRemove;
    posAni.fillMode = kCAFillModeForwards;
    
    return posAni;
    
}

@end
