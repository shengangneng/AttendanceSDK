//
//  MPMTouchImageView.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/14.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPMImageTouchViewDelegate <NSObject>
/** 点击图片的代理回调 */
- (void)imageTouchViewDidSelected:(id)sender;
@optional
- (void)imageTouchViewDidBegin:(id)sender;
- (void)imageTouchViewDidCancel:(id)sender;
@end

@interface MPMImageTouchView : UIImageView

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIImageView *edgingImageView;
@property (nonatomic, strong) UIImage *edgingImage;
@property (nonatomic, copy) id<MPMImageTouchViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<MPMImageTouchViewDelegate>)delegate;

@end
