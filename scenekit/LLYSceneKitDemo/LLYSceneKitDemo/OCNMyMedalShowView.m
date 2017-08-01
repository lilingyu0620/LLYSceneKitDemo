//
//  OCNMyMedalShowView.m
//  OpenCourse
//
//  Created by lly on 2017/6/5.
//  Copyright © 2017年 NetEase.com, Inc. All rights reserved.
//

#import "OCNMyMedalShowView.h"
#import <SceneKit/SceneKit.h>
#import "UIImage+OCNImageMerge.h"
#import "UIButton+OCNEnlargeArea.h"
#import "UILabel+imageLabel.h"
#import "OCNCABaseAnimationCreator.h"
#import "UIImage+Crop.h"

static const CGFloat kAnimationTime = 1;
static const CGFloat kImageViewAnimationTime = 0.5;

#define OCWidth ([UIScreen mainScreen].bounds.size.width)

@interface OCNMyMedalShowView ()<CAAnimationDelegate,SCNSceneRendererDelegate>

@property (nonatomic,strong) SCNScene *myScene;
@property (nonatomic,strong) SCNNode *myNode;
@property (nonatomic,strong) SCNView *myView;

@property (nonatomic,strong) SCNNode *leftLightNode;
@property (nonatomic,strong) SCNNode *rightLightNode;
@property (nonatomic,strong) SCNNode *spotNode;
@property (nonatomic,strong) SCNNode *omniNode;
@property (nonatomic,strong) SCNNode *cameraNode;
@property (nonatomic,strong) SCNNode *particleNode;

@property (nonatomic,assign) CGFloat lastPtx;
@property (nonatomic,assign) CGFloat curPtx;
@property (nonatomic,assign) CGFloat curAngle;

@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UIButton *shareBtn;

@property (nonatomic,strong) UILabel *medalNameLabel;
@property (nonatomic,strong) UILabel *medalTimeLabel;
@property (nonatomic,strong) UILabel *medalDescribeLabel;

@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UIImageView *rightImageView;
@property (nonatomic,strong) UIImageView *notGetImageView;
@property (nonatomic,strong) UIImageView *backgroundImageView;

@property (nonatomic,strong) UIViewController *superVC;

@end


@implementation OCNMyMedalShowView

#pragma mark - life cycle
- (void)dealloc{
    NSLog(@"%@--dealloced",NSStringFromClass([self class]));
}
- (instancetype)initWithFrame:(CGRect)frame
                       UserId:(NSString *)userId
                   medalModel:(OCNMyMedalListInfoModel *)medalModel{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
        self.alpha = 0;
    }
    return self;
}

#pragma mark - private method

- (void)showInSuperVC:(UIViewController *)superVC{
    
    self.superVC = superVC;
    [self initUI];
    [self initScene];
    [superVC.view addSubview:self];
    
    [UIView animateWithDuration:kImageViewAnimationTime animations:^{
        self.alpha = 1;
    }];
}

- (void)removeFromSuperView{

    //所有的SceneKit相关对象必须手动释放，不然会造成循环引用导致self不能被释放
    self.myScene = nil;
    self.myNode = nil;;
    self.myView = nil;
    
    self.leftLightNode = nil;
    self.rightLightNode = nil;
    self.spotNode = nil;
    self.omniNode = nil;
    self.cameraNode = nil;
    self.particleNode = nil;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];

}

- (void)initUI{
    
    [self addSubview:self.backBtn];
    
    [self addSubview:self.backgroundImageView];
    self.backgroundImageView.center = self.center;
    
    [self addSubview:self.myView];
    self.myView.center = self.center;
}

- (void)initScene{

    //给场景添加相机
    [self.myScene.rootNode addChildNode:self.cameraNode];
    //勋章左上角点光源
    [self.myScene.rootNode addChildNode:self.leftLightNode];
    //勋章右上角点光源
    [self.myScene.rootNode addChildNode:self.rightLightNode];
    //聚光灯
    [self.myScene.rootNode addChildNode:self.spotNode];
    //点光源
    [self.myScene.rootNode addChildNode:self.omniNode];
    //勋章模型
    [self.myScene.rootNode addChildNode:self.myNode];
    //粒子
    [self.myNode addChildNode:self.particleNode];

    
    //隐藏原场景中的灰机模型
    SCNNode *ship = [self.myScene.rootNode childNodeWithName:@"ship" recursively:YES];
    [ship setHidden:YES];
    //绑定场景
    self.myView.scene = self.myScene;
    //勋章入场动画
    [self medalAppearAnimation];
}

#pragma mark - lazy load
//返回按钮
- (UIButton *)backBtn{
    
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setFrame:CGRectMake(16, 20, 20, 36)];
        [_backBtn setImage:[UIImage imageNamed:@"me_medal_white_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setEnlargeEdgeWithTop:32 right:64 bottom:64 left:32];
    }
    
    return _backBtn;
}
- (void)backBtnClicked:(id)sender{
    
    //兼容一下模型加载失败情况
    if (_myNode != nil) {
        [self medalDisappearAnimation];
    }
    else{
        [self removeFromSuperView];
    }
}


- (UIImageView *)backgroundImageView{

    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, OCWidth, OCWidth)];
        _backgroundImageView.image = [UIImage imageNamed:@"medal_pop_back"];
        _backgroundImageView.clipsToBounds = YES;
        _backgroundImageView.layer.contentsGravity = kCAGravityResizeAspect;
        _backgroundImageView.layer.zPosition = -10;
    }
    
    return _backgroundImageView;
}


- (SCNScene *)myScene{
    
    if (!_myScene) {
        _myScene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
    }
    return _myScene;
    
}

- (SCNView *)myView{
    
    if (!_myView) {
        
        _myView = [[SCNView alloc]initWithFrame:CGRectMake(0, 0, 360, 360)];
        _myView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        _myView.showsStatistics = NO;
        _myView.autoenablesDefaultLighting = YES;
        _myView.playing = YES;
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHandle:)];
        [_myView addGestureRecognizer:panGesture];
    }
    return _myView;
}


- (SCNNode *)myNode{
    
    if (!_myNode) {

        NSURL *bundlePathUrl = [[NSBundle mainBundle] bundleURL];
        bundlePathUrl = [bundlePathUrl URLByAppendingPathComponent:@"art.scnassets/666.dae"];
        
        SCNScene *scene = [SCNScene sceneWithURL:bundlePathUrl options:nil error:nil];
        _myNode = [scene.rootNode childNodeWithName:@"medal" recursively:YES];
        
        {
            
            _myNode.position = SCNVector3Make(0, 0, 0);
            _myNode.scale = SCNVector3Make(0.01, 0.01, 0.01);
            _myNode.geometry.firstMaterial.doubleSided = YES;
            _myNode.geometry.firstMaterial.locksAmbientWithDiffuse = YES;
            _myNode.castsShadow = YES;
            
            
            {
                //将勋章信息写入label然后截图
                NSString *userName = [NSString stringWithFormat:@"%@\n\n",@"lilingyu"];
                NSString *rankStr = [NSString stringWithFormat:@"全球第%@枚\n",@1];
                NSString *timeStr = @"2017/06/20";
                NSString *medalStr = [NSString stringWithFormat:@"%@%@%@",userName,rankStr,timeStr];
                NSDictionary *attrDic = @{
                                          NSFontAttributeName: [UIFont systemFontOfSize:12],
                                          NSForegroundColorAttributeName: [UIColor blackColor]
                                          };
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:medalStr attributes:attrDic];
                [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:[medalStr rangeOfString:userName]];
                [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:[medalStr rangeOfString:rankStr]];
                
                //label生成的文本图片
                UIImage *layerImage = [UILabel imageLabelWithAttributeText:attString backgroundColor:[UIColor clearColor] frame:CGRectMake(0, 0, 200, 200)];
                UIImage *wkImage = [UIImage imageNamed:@"wk"];
                UIImage *smallImage = [UIImage image:wkImage scaleToSize:CGSizeMake(64, 64)];
                UIImage *logoImage = [smallImage circleImage];

                //合并后的图片
                UIImage *mergeImage = [UIImage mergeWithImage1:layerImage frame1:CGRectMake(0, 0, layerImage.size.width, layerImage.size.height) Image2:logoImage frame2:CGRectMake(70, 120, logoImage.size.width, logoImage.size.height)];
                
                SCNMaterial *lastMaterial = _myNode.geometry.materials.lastObject;
                lastMaterial.diffuse.contents = mergeImage;
                lastMaterial.diffuse.wrapS = SCNWrapModeClamp;
                lastMaterial.diffuse.wrapT = SCNWrapModeClamp;
                lastMaterial.doubleSided = NO;
                lastMaterial.locksAmbientWithDiffuse = YES;
                lastMaterial.transparencyMode = SCNTransparencyModeAOne;
                
            }
        }
    }
    return _myNode;
}

- (SCNNode *)particleNode{
    
    if (!_particleNode) {
        _particleNode = [SCNNode node];
        
        SCNParticleSystem *particleSystem = [SCNParticleSystem particleSystemNamed:@"art.scnassets/stars.scnp" inDirectory:nil];
        particleSystem.emittingDirection = SCNVector3Make(0, 1, 0);
        particleSystem.emissionDuration = 20;
        particleSystem.particleSize = 0.05;
        _particleNode.scale = SCNVector3Make(100, 100, 100);
        [_particleNode addParticleSystem:particleSystem];
    }
    
    return _particleNode;
}


- (SCNNode *)leftLightNode{
    
    if (!_leftLightNode) {
        
        _leftLightNode = [SCNNode node];
        SCNLight *light = [SCNLight light];
        light.type = SCNLightTypeOmni;
        light.castsShadow = true;
        light.color = [UIColor grayColor];
        light.shadowMode = SCNShadowModeForward;
        _leftLightNode.light = light;
        _leftLightNode.position = SCNVector3Make(-10, 10, 0);
        _leftLightNode.rotation = SCNVector4Make(1, 0, 0, -M_PI_2);
    }
    
    return _leftLightNode;
}

- (SCNNode *)rightLightNode{
    
    if (!_rightLightNode) {
        
        _rightLightNode = [SCNNode node];
        SCNLight *light = [SCNLight light];
        light.type = SCNLightTypeOmni;
        light.castsShadow = true;
        light.color = [UIColor grayColor];
        light.shadowMode = SCNShadowModeForward;
        _rightLightNode.light = light;
        _rightLightNode.position = SCNVector3Make(10, 10, 0);
        _rightLightNode.rotation = SCNVector4Make(1, 0, 0, M_PI_2);
    }
    
    return _rightLightNode;
}

- (SCNNode *)spotNode{
    if (!_spotNode) {
        SCNLight *spotLight = [SCNLight light];
        spotLight.type = SCNLightTypeSpot;
        spotLight.color = [UIColor whiteColor];
        spotLight.castsShadow = YES;
        spotLight.shadowMode = SCNShadowModeForward;
        spotLight.shadowRadius = 5;
        spotLight.shadowSampleCount = 100;
        _spotNode = [SCNNode node];
        _spotNode.position = SCNVector3Make(-12, 12, 12);
        _spotNode.rotation = SCNVector4Make(1, 1, 0, -M_PI/3);
        _spotNode.light  = spotLight;
        
    }
    
    return _spotNode;
}

- (SCNNode *)omniNode{
    if (!_omniNode) {
        SCNLight *omniLight = [SCNLight light];
        omniLight.type = SCNLightTypeOmni;
        omniLight.color = [UIColor whiteColor];
        omniLight.castsShadow = YES;
        omniLight.shadowMode = SCNShadowModeForward;
        omniLight.attenuationStartDistance = 10;//衰减开始距离
        omniLight.attenuationEndDistance = 13;//衰减结束距离
        _omniNode = [SCNNode node];
        _omniNode.position = SCNVector3Make(-4, 5, 10);
        _omniNode.light  = omniLight;
    }
    return _omniNode;
}

- (SCNNode *)cameraNode{
    
    if (!_cameraNode) {
        _cameraNode = [SCNNode node];
        _cameraNode.camera = [SCNCamera camera];
        _cameraNode.position = SCNVector3Make(0,0,18);
        _cameraNode.camera.zFar = 100;
    }
    
    return _cameraNode;
}


#pragma mark - CAAnimation Method

- (CABasicAnimation *)scaleAnimation:(SCNVector3)fromScale toScale:(SCNVector3)toScale dur:(CGFloat)dura{
    
    CABasicAnimation *scaleAni = [CABasicAnimation animationWithKeyPath:@"scale"];
    scaleAni.fromValue = [NSValue valueWithSCNVector3:fromScale];
    scaleAni.toValue = [NSValue valueWithSCNVector3:toScale];
    scaleAni.duration = dura;
    scaleAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAni.removedOnCompletion = NO;
    scaleAni.fillMode = kCAFillModeForwards;
    
    return scaleAni;
}

- (CABasicAnimation *)positionAnimationWithCurPos:(SCNVector3)curPos tarPos:(SCNVector3)tarPos dur:(CGFloat)dura{
    
    CABasicAnimation *positionAni = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAni.fromValue = [NSValue valueWithSCNVector3:curPos];
    positionAni.toValue = [NSValue valueWithSCNVector3:tarPos];
    positionAni.duration = dura;
    positionAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    positionAni.removedOnCompletion = NO;
    positionAni.fillMode = kCAFillModeForwards;
    
    return positionAni;
}

- (void)medalAppearAnimation{
    
    CABasicAnimation *scaleAni = [self scaleAnimation:SCNVector3Make(.01, .01, .01) toScale:SCNVector3Make(0.03, 0.03, 0.03) dur:kAnimationTime];
    scaleAni.delegate = self;
    [_myNode addAnimation:scaleAni forKey:@"scaleAnimation"];
    
    //勋章弹出动画
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:kAnimationTime];
    [SCNTransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [SCNTransaction setCompletionBlock:^{
        
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:0.2];
        [SCNTransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [SCNTransaction setCompletionBlock:^{
            
            [SCNTransaction begin];
            [SCNTransaction setAnimationDuration:0.2];
            [SCNTransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            self.myNode.rotation = SCNVector4Make(0, 1, 0, M_PI * 2);
            self.curAngle = M_PI * 2;
            [SCNTransaction commit];
        }];
        self.myNode.rotation = SCNVector4Make(0, 1, 0, M_PI * 2 - M_PI_2/5);
        [SCNTransaction commit];
    }];
    self.myNode.rotation = SCNVector4Make(0, 1, 0, M_PI * 2 + M_PI_2/2);;
    [SCNTransaction commit];
    
}

- (void)medalDisappearAnimation{
    
    CABasicAnimation *scaleAni = [self scaleAnimation:SCNVector3Make(.03, .03, .03) toScale:SCNVector3Make(.01, .01, .01) dur:kAnimationTime];
    scaleAni.beginTime = CACurrentMediaTime() + 0.4;
    scaleAni.delegate = self;
    [_myNode addAnimation:scaleAni forKey:@"scaleBackAnimation"];

    //勋章退出动画
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:0.2];
    [SCNTransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [SCNTransaction setCompletionBlock:^{
        
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:0.2];
        [SCNTransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [SCNTransaction setCompletionBlock:^{
            
            [SCNTransaction begin];
            [SCNTransaction setAnimationDuration:kAnimationTime];
            [SCNTransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            self.myNode.rotation = SCNVector4Make(0, 1, 0, self.curAngle + M_PI * 2);
            [SCNTransaction commit];
        }];
        self.myNode.rotation = SCNVector4Make(0, 1, 0, self.curAngle - M_PI_2/5);
        [SCNTransaction commit];
    }];
    self.myNode.rotation = SCNVector4Make(0, 1, 0, self.curAngle + M_PI_2/2);;
    [SCNTransaction commit];
}


- (void)medalNotGetImageViewAppearAnimation{
    
    CABasicAnimation *scaleAnimation = [OCNCABaseAnimationCreator viewScaleAnimation:@(0.1) toScale:@(1) dur:kImageViewAnimationTime removeOnCompletion:NO];
    [self.notGetImageView.layer addAnimation:scaleAnimation forKey:@"imageViewAnimation"];
    
}
- (void)medalNotGetImageViewDisAppearAnimation{
    CABasicAnimation *scaleAnimation = [OCNCABaseAnimationCreator viewScaleAnimation:@(1) toScale:@(0.1) dur:kImageViewAnimationTime removeOnCompletion:NO];
    scaleAnimation.delegate = self;
    [self.notGetImageView.layer addAnimation:scaleAnimation forKey:@"imageViewBackScaleAnimation"];
}


#pragma mark - CAAnimation Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    CAAnimation *scaleBackani = [self.myNode animationForKey:@"scaleBackAnimation"];
    if ([[scaleBackani valueForKey:@"keyPath"] isEqualToString:[anim valueForKey:@"keyPath"]]) {
        [self removeFromSuperView];
    }
    
    CAAnimation *scaleAnimation = [self.notGetImageView.layer animationForKey:@"imageViewBackScaleAnimation"];
    if ([[scaleAnimation valueForKey:@"keyPath"] isEqualToString:[anim valueForKey:@"keyPath"]]) {
        [self removeFromSuperView];
    }
}


#pragma mark - UIGesture

- (void)panHandle:(UIPanGestureRecognizer *)gesture{
    
    CGPoint pt = [gesture locationInView:self];
    
    CGPoint velocityPt = [gesture velocityInView:self];
    NSLog(@"velocityPt x = %f , y = %f",velocityPt.x,velocityPt.y);
    CGFloat velocityX = fabs(velocityPt.x);
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSLog(@"pan began");
            
            self.lastPtx = self.curPtx = pt.x;
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            NSLog(@"pan changed");
            
            self.curPtx = pt.x;
            
            CGFloat offsetX = self.curPtx - self.lastPtx;
            CGFloat angle = offsetX/OCWidth * M_PI;
            
            angle += self.curAngle;
            NSLog(@"angle = %f",angle);
            self.myNode.rotation = SCNVector4Make(0, 1, 0, angle);
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            NSLog(@"pan end");
            
            CGFloat offsetX = self.curPtx - self.lastPtx;
            CGFloat angle = fabs(offsetX)/self.frame.size.width * M_PI;
            CGFloat targetAngle = floor(angle / M_PI_2) * M_PI;
            
            if (200 < velocityX && velocityX < 1000) {
                targetAngle = M_PI;
            }
            else if (1000 <= velocityX && velocityX < 2000){
                targetAngle = M_PI*2;
            }
            else if (2000 <= velocityX && velocityX < 4000){
                targetAngle = M_PI*3;
            }
            else if (4000 <= velocityX){
                targetAngle = M_PI*4;
            }
            
            CGFloat curAngleInt = floor(self.curAngle/M_PI) * M_PI;
            if (velocityPt.x < 0) {
                targetAngle = -targetAngle;
            }
            
            //勋章动画
            [SCNTransaction begin];
            [SCNTransaction setAnimationDuration:0.5];
            [SCNTransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [SCNTransaction setCompletionBlock:^{
                
                [SCNTransaction begin];
                [SCNTransaction setAnimationDuration:0.2];
                [SCNTransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                [SCNTransaction setCompletionBlock:^{
                    
                    [SCNTransaction begin];
                    [SCNTransaction setAnimationDuration:0.2];
                    [SCNTransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                    
                    self.myNode.rotation = SCNVector4Make(0, 1, 0, targetAngle + curAngleInt);
                    [SCNTransaction commit];
                }];
                
                SCNVector4 rotationVec;
                //targetAngle = 0为慢速滑动,否则为快速滑动
                if (targetAngle == 0) {
                    if (offsetX < 0) {
                        rotationVec = SCNVector4Make(0, 1, 0, curAngleInt - M_PI_2/5);
                    }
                    else{
                        rotationVec = SCNVector4Make(0, 1, 0, curAngleInt + M_PI_2/5);
                    }
                }
                else{
                    if (targetAngle > 0) {
                        rotationVec = SCNVector4Make(0, 1, 0, targetAngle + curAngleInt - M_PI_2/5);
                    }
                    else{
                        rotationVec = SCNVector4Make(0, 1, 0, targetAngle + curAngleInt + M_PI_2/5);
                    }
                }
                self.myNode.rotation = rotationVec;
                [SCNTransaction commit];
            }];
            
            SCNVector4 rotationVec;
            if (targetAngle == 0) {
                if (offsetX < 0) {
                    rotationVec = SCNVector4Make(0, 1, 0, curAngleInt + M_PI_2/2);
                }
                else{
                    rotationVec = SCNVector4Make(0, 1, 0, curAngleInt - M_PI_2/2);
                }
                
            }else{
                if (targetAngle > 0) {
                    rotationVec = SCNVector4Make(0, 1, 0, targetAngle + curAngleInt + M_PI_2/2);
                }
                else{
                    rotationVec = SCNVector4Make(0, 1, 0, targetAngle + curAngleInt - M_PI_2/2);
                }
            }
            self.myNode.rotation = rotationVec;
            [SCNTransaction commit];
            //保存当前模型的角度值
            self.curAngle = curAngleInt + targetAngle;
        }
            break;
            
        default:
            break;
    }
}

@end
