//
//  DFHeader.m
//  MJRefreshExample
//
//  Created by Apple on 16/3/31.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "DFHeader.h"
@interface DFHeader()
@property (strong, nonatomic)UIImageView *backgroundImageView;
@property (strong, nonatomic)UIImageView *cityImageView;
@property (strong, nonatomic)UIImageView *supermanImageView;
@property (strong, nonatomic)UIImageView *ferrisWheelImageView;
@end
@implementation DFHeader

- (void)prepare
{
    [super prepare];

    self.mj_h = 100;
    _backgroundImageView = [[UIImageView alloc] init];
    _backgroundImageView.image = [UIImage imageNamed:@"蓝色背景"];
    [self addSubview:_backgroundImageView];
    
    _ferrisWheelImageView = [[UIImageView alloc] init];
    _ferrisWheelImageView.image = [UIImage imageNamed:@"摩天楼"];
    [self addSubview:_ferrisWheelImageView];
    
    _cityImageView = [[UIImageView alloc] init];
    _cityImageView.image = [UIImage imageNamed:@"城堡"];
    [self addSubview:_cityImageView];
    
    _supermanImageView = [[UIImageView alloc] init];
    _supermanImageView.image = [UIImage imageNamed:@"超人"];
    
    [self addSubview:_supermanImageView];
    
    
    
}


- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    NSLog(@"%@", @(self.state));
    NSLog(@"%lf",pullingPercent);
    if (self.state == 1) {
        //超人
        _supermanImageView.frame = CGRectMake(self.mj_w*.5,self.mj_h*.25,21*3, 13.8*3);
        _supermanImageView.layer.timeOffset = pullingPercent;
        //背景
        _backgroundImageView.frame = CGRectMake((self.mj_w-160)/2, 104-60*pullingPercent*2+60, 160, 56);
        _cityImageView.frame = CGRectMake((self.mj_w-172)/2, 86-60*pullingPercent*2+60, 172, 74);
        
        //摩天轮
        _ferrisWheelImageView.frame = CGRectMake((self.mj_w-60)/2, 100-60*pullingPercent*2+70, 70, 70);
    }else {
        _supermanImageView.frame = CGRectMake(self.mj_w*.5,self.mj_h*.25,21*3, 13.8*3);
        //背景
        _backgroundImageView.frame = CGRectMake((self.mj_w-160)/2, 44, 160, 56);
        _cityImageView.frame = CGRectMake((self.mj_w-172)/2, 26, 172, 74);
        //摩天轮
        _ferrisWheelImageView.frame = CGRectMake((self.mj_w-60)/2, 50, 70, 70);
    }
    


}

- (void)setState:(MJRefreshState)state
{
    [super setState:state];
    NSLog(@"%ld",state);

    switch (state) {
        case MJRefreshStateIdle:
        {
            
//            [_ferrisWheelImageView.layer removeAllAnimations];
            [self playPullingAnimation];
        }
            break;
        case MJRefreshStatePulling:
        {
            [_supermanImageView.layer removeAllAnimations];
            _supermanImageView.layer.speed = 1;
            [self playShakingAnimation];
        }
            break;
        case MJRefreshStateRefreshing:
        {
            [_supermanImageView.layer removeAllAnimations];
            _supermanImageView.layer.speed = 1;
            [self playShakingAnimation];
        }
            break;
        case MJRefreshStateWillRefresh:
        {
            
        }
        default:
            break;
    }
}

#pragma mark - Animation
- (void)playPullingAnimation
{
    
    UIBezierPath* aPath = [UIBezierPath bezierPath];

    [aPath moveToPoint:CGPointMake(self.mj_w*.15, self.mj_h*1.2)];
    
    [aPath addQuadCurveToPoint:CGPointMake(self.mj_w*.5, self.mj_h*.25) controlPoint:CGPointMake(self.mj_w*.3, self.mj_h*.3)];

    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    anim.path = aPath.CGPath;
    anim.duration = 1.0;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    anim.delegate = self;
    [anim setValue:@"supermanPull" forKey:@"pull"];
    [_supermanImageView.layer addAnimation:anim forKey:@"position"];
    
    CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim2.fromValue = [NSValue valueWithCGSize:CGSizeMake(.2, .2)];
    anim2.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    anim2.duration = 1.0;
    anim2.fillMode = kCAFillModeForwards;
    anim2.removedOnCompletion = NO;
    [_supermanImageView.layer addAnimation:anim2 forKey:@"transform.scale"];

    
    CABasicAnimation *anim3 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anim3.fromValue = @(.0);
    anim3.toValue = @(1.0);
    anim3.duration = 0.5;
    anim3.fillMode = kCAFillModeForwards;
    anim3.removedOnCompletion = NO;
    [_supermanImageView.layer addAnimation:anim3 forKey:@"opacity"];
    
    _supermanImageView.layer.speed = 0;
    _supermanImageView.layer.timeOffset = 0;
    
    
}

- (void)playShakingAnimation
{
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    anim.values = @[[NSValue valueWithCGPoint:CGPointMake(self.mj_w*.5, self.mj_h*.25)],
                    [NSValue valueWithCGPoint:CGPointMake(self.mj_w*.5, self.mj_h*.25+10)],
                    [NSValue valueWithCGPoint:CGPointMake(self.mj_w*.5, self.mj_h*.25)],
                    [NSValue valueWithCGPoint:CGPointMake(self.mj_w*.5, self.mj_h*.25-10)],
                    [NSValue valueWithCGPoint:CGPointMake(self.mj_w*.5, self.mj_h*.25)]];
    anim.duration = 2.0;
    anim.repeatCount = CGFLOAT_MAX;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    [_supermanImageView.layer addAnimation:anim forKey:@"position"];
    
    CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anim2.toValue = @(M_PI*2);
    anim2.repeatCount = CGFLOAT_MAX;
    anim2.duration = 2.0;
    anim2.fillMode = kCAFillModeForwards;
    anim2.removedOnCompletion = NO;
    [_ferrisWheelImageView.layer addAnimation:anim2 forKey:@"transform.rotation.z"];
    
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    
//    CABasicAnimation *anim3 = [CABasicAnimation animationWithKeyPath:@"position"];
//    
//    anim3.duration = .5;
//    anim3.repeatCount = 1;
//    anim3.fillMode = kCAFillModeForwards;
//    anim3.removedOnCompletion = NO;
//    [_ferrisWheelImageView.layer addAnimation:anim3 forKey:@"position"];

}

- (void)playDidStopRefreshAnimation
{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    anim.values = @[[NSValue valueWithCGPoint:CGPointMake(self.mj_w*.5, self.mj_h*.25)],
                    [NSValue valueWithCGPoint:CGPointMake(self.mj_w, self.mj_h*.5)]];
    
    CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim2.fromValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    anim2.toValue = [NSValue valueWithCGSize:CGSizeMake(.2, .2)];
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = @[anim, anim2];
    animGroup.duration = .25;
    animGroup.fillMode = kCAFillModeForwards;
    animGroup.removedOnCompletion = NO;
    animGroup.delegate = self;
    [animGroup setValue:@"supermanFinish" forKey:@"name"];
    [_supermanImageView.layer addAnimation:animGroup forKey:nil];
}

- (void)endRefreshing
{
    [self playDidStopRefreshAnimation];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:@"name"] isEqualToString:@"supermanFinish"]) {
        self.state = MJRefreshStateIdle;
    }
}


@end
