//
//  MPMCustomProgressHUD.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/11/8.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMCustomProgressHUD.h"
#import "MPMAttendanceHeader.h"

#define kSquareWidth     67     // 四个圆圈父视图宽高
#define kLayerWidth      8      // 四个圆圈的宽高
#define kAnimateWidth    20     // 四个圆圈转动的正方形范围
#define kAnimateDuration 1.2    // 动画时长
#define kDismissDuration 0.15   // 视图消失时长
#define kLabelDuration   2.0    // 文本显示时间
#define kMessageHeight   50     // 文本的高度

const CGFloat MPMShadowWidth = 1.0;

typedef NS_ENUM(NSInteger, MPMProgressType) {
    MPMProgressTypeFourRoundView,   /** 四个圆圈转转转 */
    MPMProgressTypeMessageOnly      /** 单纯文字 */
};

static MPMCustomProgressHUD *shareProgressHUD;

@interface MPMCustomProgressHUD ()

@property (nonatomic, assign, getter = isShowing) BOOL showing; /** 是否正在显示 */
@property (nonatomic, assign) MPMProgressType progressType;

@property (nonatomic, strong) UIView *maskView;     /** 遮盖视图，alpha只有0.1，为了防止用户操作 */
@property (nonatomic, strong) UIView *fourRoundView;/** 动画视图：四个圆圈 */

@property (nonatomic, strong) UIView *messageBackGroudView; /** 提示文字背景视图 */
@property (nonatomic, strong) UILabel *messageLabel;        /** 提示文字 */

@end

@implementation MPMCustomProgressHUD

+ (instancetype)shareProgressHUD {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareProgressHUD = [[MPMCustomProgressHUD alloc] initSubViews];
    });
    return shareProgressHUD;
}

- (instancetype)initSubViews {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        [self addSubview:self.maskView];
        [self addSubview:self.fourRoundView];
        [self addSubview:self.messageBackGroudView];
        [self addSubview:self.messageLabel];
    }
    return self;
}

+ (void)showProgressHUD {
    dispatch_async(kMainQueue, ^{
        MPMCustomProgressHUD *progressHUD = [[self class] shareProgressHUD];
        if (!progressHUD.isShowing) {
            progressHUD.showing = YES;
            progressHUD.progressType = MPMProgressTypeFourRoundView;
            [kAppDelegate.window addSubview:progressHUD];
        }
    });
}

+ (void)showWithMessage:(NSString *)message {
    dispatch_async(kMainQueue, ^{
        MPMCustomProgressHUD *progressHUD = [[self class] shareProgressHUD];
        if (!progressHUD.isShowing) {
            progressHUD.showing = YES;
            progressHUD.progressType = MPMProgressTypeMessageOnly;
            progressHUD.messageLabel.text = message;
            CGRect newRect = [progressHUD.messageLabel textRectForBounds:CGRectMake(40, 0, kScreenWidth - 80, kScreenHeight) limitedToNumberOfLines:0];
            CGRect oldRect = progressHUD.messageLabel.frame;
            double border = 10;
            oldRect.size.width = newRect.size.width + border * 2;
            oldRect.origin.x = newRect.origin.x - border;
            oldRect.size.height = newRect.size.height;
            progressHUD.messageLabel.frame = oldRect;
            progressHUD.messageBackGroudView.frame = CGRectMake(oldRect.origin.x - 15, oldRect.origin.y - 15, oldRect.size.width + 30, oldRect.size.height + 30);
            progressHUD.messageLabel.center = progressHUD.messageBackGroudView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
            [kAppDelegate.window addSubview:progressHUD];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kLabelDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                shareProgressHUD.showing = NO;
                [shareProgressHUD removeFromSuperview];
            });
        }
    });
}

+ (void)dismiss {
    dispatch_async(kMainQueue, ^{
        if (shareProgressHUD.isShowing) {
            shareProgressHUD.showing = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDismissDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [shareProgressHUD removeFromSuperview];
            });
        }
    });
}

- (void)setProgressType:(MPMProgressType)progressType {
    _progressType = progressType;
    if (MPMProgressTypeFourRoundView == progressType) {
        self.fourRoundView.hidden = NO;
        self.messageBackGroudView.hidden = YES;
        self.messageLabel.hidden = YES;
    } else if (MPMProgressTypeMessageOnly == progressType) {
        self.fourRoundView.hidden = YES;
        self.messageBackGroudView.hidden = NO;
        self.messageLabel.hidden = NO;
    }
}

/** 一个转圈圈的路径 */
- (CAKeyframeAnimation *)getKeyFrameAnimaionWithBeginTime:(CGFloat)beginTime {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(kSquareWidth/2, kSquareWidth/2) radius:kAnimateWidth/2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    animation.path = path.CGPath;
    animation.beginTime = beginTime;
    animation.repeatCount = MAXFLOAT;
    animation.duration = kAnimateDuration;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    return animation;
}

#pragma mark - Lazy Init

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = kWhiteColor;
        _maskView.alpha = 0.01;
    }
    return _maskView;
}

- (UIView *)fourRoundView {
    if (!_fourRoundView) {
        _fourRoundView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2 - kSquareWidth/2, kScreenHeight/2 - kSquareWidth/2, kSquareWidth, kSquareWidth)];
        _fourRoundView.backgroundColor = kWhiteColor;
        _fourRoundView.layer.shadowColor = kMainLightGray.CGColor;
        _fourRoundView.layer.shadowOffset = CGSizeZero;
        _fourRoundView.layer.cornerRadius = 5;
        _fourRoundView.layer.shadowRadius = 10;
        _fourRoundView.layer.shadowOpacity = 0.3;
        _fourRoundView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(-MPMShadowWidth/2, -MPMShadowWidth/2, kSquareWidth + MPMShadowWidth/2, kSquareWidth + MPMShadowWidth/2)].CGPath;
        // 添加四个圆圈
        NSArray *rectArray = @[NSStringFromCGRect(CGRectMake(kSquareWidth/2 - kAnimateWidth/2 - kLayerWidth/2, kSquareWidth/2 - kLayerWidth/2, kLayerWidth, kLayerWidth)),
                               NSStringFromCGRect(CGRectMake(kSquareWidth/2 - kLayerWidth/2, kSquareWidth/2 - kAnimateWidth/2 - kLayerWidth/2, kLayerWidth, kLayerWidth)),
                               NSStringFromCGRect(CGRectMake(kSquareWidth/2 + kAnimateWidth/2 - kLayerWidth/2, kSquareWidth/2 - kLayerWidth/2, kLayerWidth, kLayerWidth)),
                               NSStringFromCGRect(CGRectMake(kSquareWidth/2 - kLayerWidth/2, kSquareWidth/2 + kAnimateWidth/2 - kLayerWidth/2, kLayerWidth, kLayerWidth))];
        NSArray *colorArray = @[kRGBA(30, 147, 255, 1),
                                kRGBA(82, 173, 255, 1),
                                kRGBA(95, 179, 255, 1),
                                kRGBA(163, 211, 255, 1)];
        double delay = kAnimateDuration/4.0;
        for (int i = 0; i < rectArray.count; i++) {
            CGRect rect = CGRectFromString(rectArray[i]);
            UIColor *color = colorArray[i];
            UIView *roundView = [[UIView alloc] initWithFrame:rect];
            roundView.backgroundColor = color;
            roundView.layer.cornerRadius = kLayerWidth/2;
            [roundView.layer addAnimation:[self getKeyFrameAnimaionWithBeginTime:delay] forKey:nil];
            delay += kAnimateDuration/4.0;
            [_fourRoundView addSubview:roundView];
        }
    }
    return _fourRoundView;
}

- (UIView *)messageBackGroudView {
    if (!_messageBackGroudView) {
        _messageBackGroudView = [[UIView alloc] init];
        _messageBackGroudView.hidden = YES;
        _messageBackGroudView.backgroundColor = kRGBA(40, 40, 40, 0.8);
        _messageBackGroudView.layer.cornerRadius = 5;
        _messageBackGroudView.layer.masksToBounds = YES;
    }
    return _messageBackGroudView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight/2 - kMessageHeight/2, kScreenWidth, kMessageHeight)];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textColor = kWhiteColor;
        _messageLabel.font = SystemFont(17);
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}

@end
