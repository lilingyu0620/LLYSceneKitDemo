//
//  ViewController.m
//  LLYSceneKitDemo
//
//  Created by lly on 2017/5/20.
//  Copyright © 2017年 lly. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>
#import "AchievementCardView.h"

static const CGFloat kAnimationTime = 1;

@interface ViewController ()<CAAnimationDelegate>

@property (nonatomic,strong) SCNScene *myScene;
@property (nonatomic,strong) SCNNode *myNode;
@property (nonatomic,strong) SCNView *myView;

@property (nonatomic,assign) CGFloat lastPtx;
@property (nonatomic,assign) CGFloat curPtx;

@property (nonatomic,assign) SCNMatrix4 rotateYMat;
@property (nonatomic,assign) SCNMatrix4 aniMat;

@property (nonatomic,strong) AchievementCardView *cardView;


@property (nonatomic,strong) UIButton *backBtn;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor blackColor];
    self.aniMat = SCNMatrix4Identity;
    
    [self addAchimentCards];
    
}

- (UIButton *)backBtn{

    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setFrame:CGRectMake(10, 20, 100, 60)];
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backBtn;
}

- (void)backBtnClicked:(id)sender{

//    self.cardView.hidden = NO;
//    [self.myView removeFromSuperview];
    [self.backBtn removeFromSuperview];
    
    CABasicAnimation *scaleAni = [self scaleAnimation:SCNVector3Make(1, 1, 1) toScale:SCNVector3Make(.3, .3, .3) dur:0.5];
    [_myNode addAnimation:scaleAni forKey:@"scaleBackAnimation"];
    
    CABasicAnimation *posAnimation = [self positionAnimationWithCurPos:SCNVector3Make(0, 0, 0) tarPos:SCNVector3Make(-4, 6.5, 0) dur:0.5];
    posAnimation.delegate = self;
    [_myNode addAnimation:posAnimation forKey:@"posBackAnimation"];

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
    
    UIView *card = gesture.view;
    card.hidden = YES;
    
    [self.view addSubview:self.backBtn];
    
    self.myView = [[SCNView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.myView.center = self.view.center;
    self.myView.backgroundColor = [UIColor blackColor];
    self.myView.showsStatistics = NO;
    [self.view insertSubview:self.myView atIndex:0];
    
    
//    [UIView animateWithDuration:kAnimationTime animations:^{
//        self.myView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
//    }];
    
    [self initScene];
    
    CABasicAnimation *scaleAni = [self scaleAnimation:SCNVector3Make(.3, .3, .3) toScale:SCNVector3Make(1, 1, 1) dur:kAnimationTime];
    [_myNode addAnimation:scaleAni forKey:@"scaleAnimation"];
    
    CABasicAnimation *posAnimation = [self positionAnimationWithCurPos:SCNVector3Make(-4, 6.5, 0) tarPos:SCNVector3Make(0, 0, 0) dur:kAnimationTime];
    [_myNode addAnimation:posAnimation forKey:@"posAnimation"];
    
    SCNAction *rotateAct = [SCNAction rotateByX:0 y:M_PI z:0 duration:.5];
    //        rotateAct.timingMode = SCNActionTimingModeEaseInEaseOut;
    [_myNode runAction:[SCNAction repeatAction:rotateAct count:2]];
    
}


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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SCNScene *)myScene{

    if (!_myScene) {
        _myScene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
    }
    return _myScene;

}

//- (SCNView *)myView{
//
//    if (!_myView) {
//        _myView = [[SCNView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
//        _myView.center = self.view.center;
//        
//        
//    }
//    return _myView;
//}


- (void)addGestures{

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle:)];
    [self.view addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHandle:)];
    [self.view addGestureRecognizer:panGesture];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandle:)];
    [self.view addGestureRecognizer:swipeGesture];

}

- (void)tapHandle:(UIGestureRecognizer *)gesture{

    
    
}

- (void)panHandle:(UIGestureRecognizer *)gesture{
    
    

}

- (void)swipeHandle:(UIGestureRecognizer *)gesture{


    

}

- (SCNNode *)myNode{

    if (!_myNode) {
        
        _myNode = [SCNNode new];
        _myNode.geometry = [SCNCylinder cylinderWithRadius:4 height:1];
        _myNode.rotation = SCNVector4Make(1, 0, 0, M_PI_2);
        
        _myNode.position = SCNVector3Make(-4, 6.5, 0);
        
        _myNode.scale = SCNVector3Make(0.3, 0.3, 0.3);

        _myNode.geometry.firstMaterial.multiply.contents = @"wk.png";
        _myNode.geometry.firstMaterial.diffuse.contents = @"wk.png";
        _myNode.geometry.firstMaterial.multiply.intensity = 0.5;
        _myNode.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant;
        _myNode.geometry.firstMaterial.multiply.contentsTransform = SCNMatrix4Mult(SCNMatrix4MakeRotation(-M_PI_2, 0, 0, 1), SCNMatrix4MakeRotation(M_PI, 0, 1, 0));
        _myNode.geometry.firstMaterial.diffuse.contentsTransform = SCNMatrix4Mult(SCNMatrix4MakeRotation(-M_PI_2, 0, 0, 1), SCNMatrix4MakeRotation(M_PI, 0, 1, 0));
        
        _myNode.geometry.firstMaterial.multiply.wrapS =
        _myNode.geometry.firstMaterial.diffuse.wrapS  =
        _myNode.geometry.firstMaterial.multiply.wrapT =
        _myNode.geometry.firstMaterial.diffuse.wrapT  = SCNWrapModeRepeat;
        
        _myNode.geometry.firstMaterial.locksAmbientWithDiffuse   = YES;
    }

    return _myNode;
}

- (void)initScene{
    
    // create and add a camera to the scene
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    [self.myScene.rootNode addChildNode:cameraNode];
    
    // place the camera
    cameraNode.position = SCNVector3Make(0,3,18);
    cameraNode.camera.zFar = 100;
    cameraNode.rotation =  SCNVector4Make(1, 0, 0,-M_PI_4/4);
    
    
    // create and add a light to the scene
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 10, 10);
    [self.myScene.rootNode addChildNode:lightNode];
    
    // create and add an ambient light to the scene
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [self.myScene.rootNode addChildNode:ambientLightNode];

    
    [self.myScene.rootNode addChildNode:self.myNode];
    
    
    // retrieve the ship node
    SCNNode *ship = [self.myScene.rootNode childNodeWithName:@"ship" recursively:YES];
    [ship setHidden:YES];
    
    // set the scene to the view
    self.myView.scene = self.myScene;
    
    // allows the user to manipulate the camera
    // _scnView.allowsCameraControl = YES;

}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self.view];
    self.lastPtx = self.curPtx = pt.x;
   
    self.rotateYMat = self.myNode.pivot;
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self.view];
    self.curPtx = pt.x;

    CGFloat offsetX = fabs(self.lastPtx - self.curPtx);
    CGFloat angle = offsetX/self.view.frame.size.width * M_PI;
    NSLog(@"angle = %f",angle);
    
    if (self.lastPtx > self.curPtx) {
        //左滑
        SCNMatrix4 rotateMat = SCNMatrix4MakeRotation(-angle, 0, 0, 1);
        self.myNode.pivot = SCNMatrix4Mult(self.rotateYMat, rotateMat);
    }
    else if (self.lastPtx < self.curPtx){
    
        //右滑
        SCNMatrix4 rotateMat = SCNMatrix4MakeRotation(angle, 0, 0, 1);
        self.myNode.pivot = SCNMatrix4Mult(self.rotateYMat, rotateMat);
    }

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self.view];
    
    
    CGFloat offsetX = fabs(self.lastPtx - self.curPtx);
    CGFloat angle = offsetX/self.view.frame.size.width * M_PI;
    CGFloat targetAngle = floor(angle / M_PI_2) * M_PI;
    
    NSLog(@"targetAngle = %f",targetAngle);

//    self.rotateYMat = self.myNode.pivot;

    
    CABasicAnimation *rotateAni = [CABasicAnimation animationWithKeyPath:@"pivot"];
    rotateAni.delegate = self;

    if (self.lastPtx > self.curPtx) {
        //左滑
        self.aniMat = SCNMatrix4MakeRotation(-targetAngle, 0, 0, 1);
        
    }
    else if (self.lastPtx < self.curPtx){
        //右滑
        self.aniMat = SCNMatrix4MakeRotation(targetAngle, 0, 0, 1);
    }
    
    rotateAni.duration = 1;
    rotateAni.fromValue = [NSValue valueWithSCNMatrix4:self.rotateYMat];
    rotateAni.toValue = [NSValue valueWithSCNMatrix4:self.aniMat];
    rotateAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotateAni.fillMode = kCAFillModeForwards;
    rotateAni.removedOnCompletion = NO;
//    [self.myNode addAnimation:rotateAni forKey:@"rotateAni"];
    
//    [UIView animateWithDuration:1 animations:^{
//       
//    }];
    
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:0.5];
    [SCNTransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    self.myNode.pivot = SCNMatrix4Mult(self.rotateYMat, self.aniMat);
    
    [SCNTransaction commit];
    
    self.lastPtx = self.curPtx = pt.x;

}


/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    CAAnimation *ani = [self.myNode animationForKey:@"posBackAnimation"];
    
    for(NSString *key in [_myNode animationKeys]){
        NSLog(@"key = %@",key);
    }
    if ([[ani valueForKey:@"keyPath"] isEqualToString:[anim valueForKey:@"keyPath"]]) {
        self.cardView.hidden = NO;
        [self.myView removeFromSuperview];
    }

}








@end
