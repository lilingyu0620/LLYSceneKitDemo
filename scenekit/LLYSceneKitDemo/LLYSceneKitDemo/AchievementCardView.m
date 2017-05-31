//
//  AchievementCardView.m
//  AchievementCardAniamtion
//
//  Created by lly on 2017/5/19.
//  Copyright © 2017年 lly. All rights reserved.
//

#import "AchievementCardView.h"

@implementation AchievementCardView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"wk"].CGImage);
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

@end
