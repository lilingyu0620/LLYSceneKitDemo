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
@property (nonatomic,strong) SCNNode *lightNode;
@property (nonatomic,strong) SCNNode *ambientLightNode;
@property (nonatomic,strong) SCNNode *spotNode;

@property (nonatomic,strong) SCNNode *cameraNode;
@property (nonatomic,strong) CALayer *textLayer;
@property (nonatomic,strong) SCNNode *particleNode;

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
    
    CABasicAnimation *scaleAni = [self scaleAnimation:SCNVector3Make(.03, .03, .03) toScale:SCNVector3Make(.01, .01, .01) dur:kAnimationTime];
    scaleAni.delegate = self;
    [_myNode addAnimation:scaleAni forKey:@"scaleBackAnimation"];
    
//    CABasicAnimation *posAnimation = [self positionAnimationWithCurPos:SCNVector3Make(0, 0, 0) tarPos:SCNVector3Make(-4.3, 7.3, 0) dur:0.5];
//    posAnimation.delegate = self;
//    [_myNode addAnimation:posAnimation forKey:@"posBackAnimation"];
    
    CABasicAnimation *opacityAni = [self opacityAnimationWithCurOpacity:1 tarOpacity:0 dur:kAnimationTime];
    [_myNode addAnimation:opacityAni forKey:@"opacityBackAnimation"];
    
    SCNAction *rotateAct = [SCNAction rotateByX:0 y:M_PI z:0 duration:.5];
    //        rotateAct.timingMode = SCNActionTimingModeEaseInEaseOut;
    [_myNode runAction:[SCNAction repeatAction:rotateAct count:2]];


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
    
    [self.view insertSubview:self.myView atIndex:0];
    
    [self initScene];
    
    CABasicAnimation *scaleAni = [self scaleAnimation:SCNVector3Make(.01, .01, .01) toScale:SCNVector3Make(.03, 0.03, .03) dur:kAnimationTime];
//    CABasicAnimation *scaleAni = [self scaleAnimation:SCNVector3Make(.1, .1, .1) toScale:SCNVector3Make(.4, .4, .4) dur:kAnimationTime];
    [_myNode addAnimation:scaleAni forKey:@"scaleAnimation"];
    
//    CABasicAnimation *posAnimation = [self positionAnimationWithCurPos:SCNVector3Make(-4.3, 7.3, 0) tarPos:SCNVector3Make(0, 0, 0) dur:kAnimationTime];
//    [_myNode addAnimation:posAnimation forKey:@"posAnimation"];
    
    
    CABasicAnimation *opacityAni = [self opacityAnimationWithCurOpacity:0 tarOpacity:1 dur:kAnimationTime];
    [_myNode addAnimation:opacityAni forKey:@"opacityAnimation"];
    
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

- (CABasicAnimation *)opacityAnimationWithCurOpacity:(CGFloat)curOpacity tarOpacity:(CGFloat)tarOpacity dur:(CGFloat)dura{

    CABasicAnimation *opacityAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAni.fromValue = @(curOpacity);
    opacityAni.toValue = @(tarOpacity);
    opacityAni.duration = dura;
    opacityAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAni.removedOnCompletion = NO;
    opacityAni.fillMode = kCAFillModeForwards;
    
    return opacityAni;

    
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

- (SCNView *)myView{

    if (!_myView) {

        _myView = [[SCNView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _myView.center = self.view.center;
        _myView.backgroundColor = [UIColor blackColor];
        _myView.showsStatistics = NO;

    }
    return _myView;
}


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
        
//        _myNode = [SCNNode new];
//        _myNode.geometry = [SCNCylinder cylinderWithRadius:4 height:1];
//        _myNode.rotation = SCNVector4Make(1, 0, 0, M_PI_2);
//        
////        _myNode.position = SCNVector3Make(-4.2, 6.7, 0);
//        _myNode.position = SCNVector3Make(0, 0, 0);
//        
//        _myNode.scale = SCNVector3Make(0.3, 0.3, 0.3);
//
////        _myNode.geometry.firstMaterial.multiply.contents = @"wk.png";
////        _myNode.geometry.firstMaterial.diffuse.contents = @"wk.png";
//        
//        _myNode.geometry.firstMaterial.multiply.contents = self.textLayer;
//        _myNode.geometry.firstMaterial.diffuse.contents = self.textLayer;
//        
//        _myNode.geometry.firstMaterial.multiply.intensity = 0;
//        _myNode.geometry.firstMaterial.lightingModelName = SCNLightingModelLambert;
//        _myNode.geometry.firstMaterial.multiply.contentsTransform = SCNMatrix4Mult(SCNMatrix4MakeRotation(-M_PI_2, 0, 0, 1), SCNMatrix4MakeRotation(M_PI, 0, 1, 0));
//        _myNode.geometry.firstMaterial.diffuse.contentsTransform = SCNMatrix4Mult(SCNMatrix4MakeRotation(-M_PI_2, 0, 0, 1), SCNMatrix4MakeRotation(M_PI, 0, 1, 0));
//        
//        _myNode.geometry.firstMaterial.multiply.wrapS =
//        _myNode.geometry.firstMaterial.diffuse.wrapS  =
//        _myNode.geometry.firstMaterial.multiply.wrapT =
//        _myNode.geometry.firstMaterial.diffuse.wrapT  = SCNWrapModeRepeat;
//        
//        _myNode.geometry.firstMaterial.locksAmbientWithDiffuse   = YES;
        
        NSURL *bundlePathUrl = [[NSBundle mainBundle] bundleURL];
        //    NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/art.scnassets/ship.dae",bundlePath]];
        bundlePathUrl = [bundlePathUrl URLByAppendingPathComponent:@"art.scnassets/medle1.dae"];
        
        
        SCNSceneSource *sceneSource = [SCNSceneSource sceneSourceWithURL:bundlePathUrl options:nil];
        
        
//        SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/medle1.dae"];
//        _myNode = [scene.rootNode childNodeWithName:@"medle1" recursively:YES];
//
//        for (SCNNode *node in _myNode.childNodes) {
//            NSLog(@"%@ %@",node.name,node.geometry);
//        }
//        
////        node.scale = SCNVector3Make(0.01, 0.01, 0.01);
//        
//        SCNNode *tmpNode = _myNode.childNodes[0];
//        SCNGeometry *geo = tmpNode.geometry;
//        _myNode = [SCNNode nodeWithGeometry:geo];
//        
//        // Get reference to the cube node
        _myNode = [sceneSource entryWithIdentifier:@"ID4" withClass:[SCNNode class]];
        _myNode.position = SCNVector3Make(0, 0, 0);
        _myNode.scale = SCNVector3Make(0.01, 0.01, 0.01);
//
//        
//        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
//        myLabel.text = @"Hello world 12345667890";
//        myLabel.textAlignment = NSTextAlignmentCenter;
//        myLabel.font = [UIFont systemFontOfSize:18];
//        myLabel.textColor = [UIColor blackColor];
//        myLabel.backgroundColor = [UIColor whiteColor];
//        
//        UIGraphicsBeginImageContext(myLabel.bounds.size);
//        
//        //        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, 30);
//        //
//        //        CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
//        
//        [myLabel.layer renderInContext:UIGraphicsGetCurrentContext()];
//        
//        UIImage *layerImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        SCNMaterial *firstMaterial = [SCNMaterial material];
//        firstMaterial.diffuse.contents = layerImage;
//        firstMaterial.locksAmbientWithDiffuse = YES;
//        
//        SCNMaterial *secondMaterial = [SCNMaterial material];
//        UIImage *secondImage = [UIImage imageNamed:@"art.scnassets/texture.png"];
//        secondMaterial.diffuse.contents = secondImage;
//        secondMaterial.locksAmbientWithDiffuse = YES;
//        
//        
//        
//        SCNMaterial *greenMaterial              = [SCNMaterial material];
//        greenMaterial.diffuse.contents          = [UIColor greenColor];
//        greenMaterial.locksAmbientWithDiffuse   = YES;
//        
//        SCNMaterial *redMaterial                = [SCNMaterial material];
//        redMaterial.diffuse.contents            = [UIColor redColor];
//        redMaterial.locksAmbientWithDiffuse     = YES;
//        
//        SCNMaterial *blueMaterial               = [SCNMaterial material];
//        blueMaterial.diffuse.contents           = [UIColor blueColor];
//        blueMaterial.locksAmbientWithDiffuse    = YES;
//        
//        SCNMaterial *yellowMaterial             = [SCNMaterial material];
//        yellowMaterial.diffuse.contents         = [UIColor yellowColor];
//        yellowMaterial.locksAmbientWithDiffuse  = YES;
//        
//        SCNMaterial *purpleMaterial             = [SCNMaterial material];
//        purpleMaterial.diffuse.contents         = [UIColor purpleColor];
//        purpleMaterial.locksAmbientWithDiffuse  = YES;
//        
//        
//        _myNode.geometry.firstMaterial.diffuse.contents = secondImage;
//        _myNode.geometry.firstMaterial.diffuse.wrapS = SCNWrapModeRepeat;
//        _myNode.geometry.firstMaterial.diffuse.wrapT = SCNWrapModeRepeat;
//        _myNode.geometry.firstMaterial.doubleSided = false;
//        _myNode.geometry.firstMaterial.locksAmbientWithDiffuse = true;
//        
//        _myNode.geometry.firstMaterial.multiply.contents = layerImage;
//        
//        

        
//        _myNode.geometry.firstMaterial.multiply.contentsTransform = SCNMatrix4MakeScale(.1, .1, .1);
//        [_myNode.geometry replaceMaterialAtIndex:1 withMaterial:silverMaterial];
        
        
//        SCNBox *box = [SCNBox boxWithWidth:6 height:6 length:6 chamferRadius:0];
//        geo.materials = @[secondMaterial,firstMaterial];
//        _myNode = [SCNNode nodeWithGeometry:box];
//        _myNode.position = SCNVector3Make(0, 0, 0);
        
        
    }

    return _myNode;
}


- (CALayer *)textLayer{

    if (!_textLayer) {
        _textLayer = [CALayer layer];
        [_textLayer setFrame:CGRectMake(0, 0, 100, 100)];
        _textLayer.backgroundColor = [UIColor whiteColor].CGColor;
        
        
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        myLabel.text = @"Hello world!";
        myLabel.font = [UIFont systemFontOfSize:18];
        myLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
        myLabel.backgroundColor = [UIColor clearColor];
        
        UIGraphicsBeginImageContext(myLabel.bounds.size);
        
        //        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, 30);
        //
        //        CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
        
        [myLabel.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage *layerImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        _textLayer.contents = layerImage;
    }
    
    return _textLayer;
}

- (SCNNode *)particleNode{

    if (!_particleNode) {
        _particleNode = [SCNNode node];
        
        SCNParticleSystem *particleSystem = [SCNParticleSystem particleSystemNamed:@"stars.scnp" inDirectory:nil];
        // 2.创建一个节点添加粒子系统
        particleSystem.emittingDirection = SCNVector3Make(0, 1, 0);
        particleSystem.emissionDuration = 10;
        _particleNode.scale = SCNVector3Make(30, 30, 30);
        [_particleNode addParticleSystem:particleSystem];
    }
    
    return _particleNode;
}

- (SCNNode *)lightNode{

    if (!_lightNode) {
        
        _lightNode = [SCNNode node];
        SCNLight *light = [SCNLight light];
        light.type = SCNLightTypeOmni;
        light.castsShadow = true;
        light.color = [UIColor redColor];
        light.shadowMode = SCNShadowModeForward;
        _lightNode.light = light;
        //    lightNode.orientation = SCNVector4(0.0, 0.0, 1.0, 0.0);
        _lightNode.position = SCNVector3Make(0, 100, 100);
        _lightNode.rotation = SCNVector4Make(1, 0, 0, -M_PI_2);
        //    lightNode.light.intensity = 3000;
        //    lightNode.light.shadowRadius = 20;
    }
    
    return _lightNode;
}


- (SCNNode *)ambientLightNode{

    if (!_ambientLightNode) {
        _ambientLightNode = [SCNNode node];
        _ambientLightNode.light = [SCNLight light];
        _ambientLightNode.light.type = SCNLightTypeAmbient;
        _ambientLightNode.light.color = [UIColor redColor];
        _ambientLightNode.position = SCNVector3Make(0, 100, 100);
    }
    return _ambientLightNode;
}

- (SCNNode *)spotNode{

    if (!_spotNode) {
        
        
        SCNLight *spotLight = [SCNLight light];// 创建光对象
        spotLight.type = SCNLightTypeSpot;// 设置类型
        spotLight.color = [UIColor whiteColor]; // 设置光的颜色
        spotLight.castsShadow = TRUE;// 捕捉阴影
        spotLight.attenuationStartDistance = 0;
        spotLight.attenuationEndDistance = 100;
        spotLight.attenuationFalloffExponent = 2;
        spotLight.spotInnerAngle = 0;
        spotLight.spotOuterAngle = 30;
        _spotNode = [SCNNode node];
        _spotNode.position = SCNVector3Make(0, 2, 10); //设置光源节点的位置
        _spotNode.light  = spotLight;
    }
    
    return _spotNode;
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

- (void)initScene{
    
    // create and add a camera to the scene
    [self.myScene.rootNode addChildNode:self.cameraNode];
    
    // place the camera
//    cameraNode.rotation =  SCNVector4Make(1, 0, 0,-M_PI_4/4);
    
    // create and add a light to the scene
    [self.myScene.rootNode addChildNode:self.lightNode];
    
    // create and add an ambient light to the scene
    [self.myScene.rootNode addChildNode:self.ambientLightNode];
    
    //聚光灯
    [self.myScene.rootNode addChildNode:self.spotNode];
    
    [self.myScene.rootNode addChildNode:self.myNode];
    
    [self.myNode addChildNode:self.particleNode];

    
    // retrieve the ship node
    SCNNode *ship = [self.myScene.rootNode childNodeWithName:@"ship" recursively:YES];
    [ship setHidden:YES];
    
    
    // set the scene to the view
    self.myView.scene = self.myScene;
    
    // allows the user to manipulate the camera
//     self.myView.allowsCameraControl = YES;
    
    self.myView.showsStatistics = YES;
    self.myView.autoenablesDefaultLighting = YES;

}

- (void)removeChildNode{

    [self.lightNode removeFromParentNode];
    [self.ambientLightNode removeFromParentNode];
    [self.cameraNode removeFromParentNode];
    [self.myNode removeFromParentNode];

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
        SCNMatrix4 rotateMat = SCNMatrix4MakeRotation(angle, 0, 1, 0);
        self.myNode.pivot = SCNMatrix4Mult(self.rotateYMat, rotateMat);
    }
    else if (self.lastPtx < self.curPtx){
    
        //右滑
        SCNMatrix4 rotateMat = SCNMatrix4MakeRotation(-angle, 0, 1, 0);
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

    if (self.lastPtx > self.curPtx) {
        //左滑
        self.aniMat = SCNMatrix4MakeRotation(targetAngle, 0, 1, 0);
        
    }
    else if (self.lastPtx < self.curPtx){
        //右滑
        self.aniMat = SCNMatrix4MakeRotation(-targetAngle, 0, 1, 0);
    }
    
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

    CAAnimation *ani = [self.myNode animationForKey:@"scaleBackAnimation"];
    
    for(NSString *key in [_myNode animationKeys]){
        NSLog(@"key = %@",key);
    }
    if ([[ani valueForKey:@"keyPath"] isEqualToString:[anim valueForKey:@"keyPath"]]) {
        self.cardView.hidden = NO;
        [self.myView removeFromSuperview];
    }

}








@end
