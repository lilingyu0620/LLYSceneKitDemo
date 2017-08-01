//
//  ViewController.m
//  LLYSceneKitDemo
//
//  Created by lly on 2017/5/20.
//  Copyright © 2017年 lly. All rights reserved.
//

#import "ViewController.h"
#import "AchievementCardView.h"
#import "OCNMyMedalShowView.h"

#define OCWidth ([UIScreen mainScreen].bounds.size.width)
#define OCHeight ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()

@property (nonatomic,strong) AchievementCardView *cardView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor blackColor];
    [self addAchimentCards];
}

- (void)addAchimentCards{
    
    self.cardView = [[AchievementCardView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.cardView.center = CGPointMake(50, 100);
    self.cardView.layer.cornerRadius = 40;
    [self.view addSubview:_cardView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cardClicked:)];
    [_cardView addGestureRecognizer:tapGesture];
}

- (void)cardClicked:(UIGestureRecognizer *)gesture{
    
    OCNMyMedalShowView *medalView = [[OCNMyMedalShowView alloc]initWithFrame:CGRectMake(0, 0, OCWidth, OCHeight)
                                                                      UserId:@""
                                                                  medalModel:nil];
    [medalView showInSuperVC:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
