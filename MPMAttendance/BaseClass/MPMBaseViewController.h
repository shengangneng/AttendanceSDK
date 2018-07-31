//
//  MPMBaseViewController.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BarButtonItemType) {
    forBarButtonTypeTitle,
    forBarButtonTypeImage
};

@interface MPMBaseViewController : UIViewController

- (void)setupAttributes;
- (void)setupSubViews;
- (void)setupConstraints;

/** 项目中LeftBarButton只有返回一种情况 */
- (void)setLeftBarButtonWithTitle:(NSString *)title action:(SEL)selector;
/** 项目中RightBarButton有两种情况：1、只有文字；2、只有图片 */
- (void)setRightBarButtonType:(BarButtonItemType)type title:(NSString *)title image:(UIImage *)image action:(SEL)selector;

/** 项目警告框 */
- (void)showAlertControllerToLogoutWithMessage:(NSString *)message
                                    sureAction:(void(^)(UIAlertAction *_Nonnull action))sureAction
                              needCancleButton:(BOOL)needCancelBtn;

@end
