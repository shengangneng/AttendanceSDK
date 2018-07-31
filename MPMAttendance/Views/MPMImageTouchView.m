//
//  MPMTouchImageView.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/14.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMImageTouchView.h"

@interface MPMImageTouchView ()

@property (nonatomic, assign) BOOL onAction;

@end

@implementation MPMImageTouchView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<MPMImageTouchViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAttributes];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAttributes];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupAttributes];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupAttributes];
    }
    return self;
}

- (void)setupAttributes {
    self.userInteractionEnabled = YES;
    // 不产生扭曲，自动填满
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.userInteractionEnabled = YES;
}

- (void)setEdgingImage:(UIImage *)edgingImage {
    if (!_edgingImageView) {
        _edgingImageView = [[UIImageView alloc] init];
        _edgingImageView.contentMode = UIViewContentModeScaleToFill;
        [self insertSubview:_edgingImageView atIndex:0];
    }
    _edgingImageView.frame = self.bounds;
    _edgingImageView.image = edgingImage;
}

- (void)setEdgingImageViewSize:(CGSize)size {
    if (_edgingImageView) {
        CGRect frame = _edgingImageView.frame;
        frame.size = size;
        _edgingImageView.frame = frame;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.onAction = YES;
    if (self.highlightedImage) {
        [self setHighlighted:self.onAction];
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.5;
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageTouchViewDidBegin:)]) {
            [self.delegate imageTouchViewDidBegin:self];
        }
    }];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.onAction) {
        UITouch * touch = [[event allTouches] anyObject];
        CGPoint touchLocation = [touch locationInView:self];
        if (!CGRectContainsPoint(self.bounds, touchLocation)) {
            [self touchesCancelled:touches withEvent:event];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.onAction) {
        self.onAction = NO;
        if (self.highlightedImage) {
            [self setHighlighted:self.onAction];
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(imageTouchViewDidCancel:)]) {
                [self.delegate imageTouchViewDidCancel:self];
            }
        }];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.onAction) {
        [self touchesCancelled:touches withEvent:event];
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageTouchViewDidSelected:)]) {
            [self.delegate imageTouchViewDidSelected:self];
        }
    }
}











@end
