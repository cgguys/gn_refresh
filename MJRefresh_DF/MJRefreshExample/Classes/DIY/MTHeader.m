//
//  MTHeader.m
//  MJRefreshExample
//
//  Created by 如佳 陈 on 16/3/30.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "MTHeader.h"

static NSString *transformAnimationImg = @"icon_transform_animation";
static NSString *shakeAnimationImg = @"icon_shake_animation_%ld";
static NSString *pullAnimationImg= @"icon_pull_animation_%ld";

static NSString *kShakeAnimKey = @"shake_anim";
static NSString *kPullAnimKey = @"pull_anim";
static NSString *kAnimKey = @"anim_key";

@interface MTHeader ()

@property (nonatomic, strong) UIImageView *transformImageView;

@end

@implementation MTHeader

- (void)prepare {
    [super prepare];
    self.mj_h = 60;
    self.transformImageView = [[UIImageView alloc] init];
    self.transformImageView.image = [UIImage imageNamed:transformAnimationImg];
    self.transformImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.transformImageView];
}

- (void)placeSubviews {
    [super placeSubviews];
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    CGFloat rate = (- self.scrollView.contentOffset.y - 64)/self.mj_h;
    self.transformImageView.frame = CGRectMake((self.mj_w - 68)/2, 54 - 54*rate, 68, 54 * rate);
}

- (void)setState:(MJRefreshState)state {
    [super setState:state];
    switch (state) {
        case MJRefreshStateIdle:
        {
            self.transformImageView.image = [UIImage imageNamed:transformAnimationImg];
            [self.transformImageView.layer removeAllAnimations
             ];
        }
            break;
        case MJRefreshStatePulling:
        {
            [self playPlullAnim];
        }
            break;
        case MJRefreshStateRefreshing: {
            [self playShakeAnim];
        }
            break;
        case MJRefreshStateWillRefresh:
        {
            break;
        }
        default:
            break;
    }
}

#pragma mark - animation

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:kAnimKey] isEqualToString:kPullAnimKey]) {
        [self playShakeAnim];
    }
}

- (void)playShakeAnim {
    CAKeyframeAnimation *shakeAnim = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:shakeAnimationImg,i]];
        [values addObject:(__bridge id)image.CGImage];
    }
    shakeAnim.values = values;
    shakeAnim.repeatCount = CGFLOAT_MAX;
    shakeAnim.duration = .5;
    shakeAnim.removedOnCompletion = NO;
    shakeAnim.fillMode = kCAFillModeForwards;
    [shakeAnim setValue:kPullAnimKey forKey:kAnimKey];
    [self.transformImageView.layer addAnimation:shakeAnim forKey:nil];
}

- (void)playPlullAnim {
    CAKeyframeAnimation *pullAnim = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:pullAnimationImg,i]];
        [values addObject:(__bridge id)image.CGImage];
    }
    pullAnim.values = values;
    pullAnim.duration = .25;
    pullAnim.delegate = self;
    pullAnim.removedOnCompletion = NO;
    pullAnim.fillMode = kCAFillModeForwards;
    [pullAnim setValue:kPullAnimKey forKey:kAnimKey];
    [self.transformImageView.layer addAnimation:pullAnim forKey:kPullAnimKey];
}

@end
