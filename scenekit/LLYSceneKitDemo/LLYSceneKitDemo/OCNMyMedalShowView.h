//
//  OCNMyMedalShowView.h
//  OpenCourse
//
//  Created by lly on 2017/6/5.
//  Copyright © 2017年 NetEase.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OCNMyMedalListInfoModel;

@interface OCNMyMedalShowView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                       UserId:(NSString *)userId
                   medalModel:(OCNMyMedalListInfoModel *)medalModel;

- (void)showInSuperVC:(UIViewController *)superVC;
- (void)removeFromSuperView;

@end
