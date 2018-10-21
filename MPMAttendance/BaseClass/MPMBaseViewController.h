//
//  MPMBaseViewController.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMSessionManager.h"

typedef void(^GoodNetworkToLoadDataBlock)(void);

typedef NS_ENUM(NSInteger, BarButtonItemType) {
    forBarButtonTypeTitle,  /** 仅显示文字 */
    forBarButtonTypeImage   /** 仅显示图片 */
};

@interface MPMBaseViewController : UIViewController

/** 网络监控 */
@property (nonatomic, strong) MPMNetworkReachabilityManager *checkNetworkManager;
/** 获取数据如果放到viewViewAppear，那么在重新加载view之后再调用这个block来调用接口加载数据 */
@property (nonatomic, copy) GoodNetworkToLoadDataBlock goodNetworkToLoadBlock;

- (void)setupAttributes;
- (void)setupSubViews;
- (void)setupConstraints;

/**
 * 添加网络监控
 * @param gNetBlock 可用网络回调
 */
- (void)addNetworkMonitoringWithGoodNetworkBlock:(void(^)(void))gNetBlock;

/**
 * 快捷设置项目LeftBarButton，默认有‘<’的图片
 * @param title 按钮文字
 * @param selector 按钮相应的方法
 */
- (void)setLeftBarButtonWithTitle:(NSString *)title action:(SEL)selector;

/**
 * 快捷设置项目RightBarButton
 * @param type 仅显示文字、仅显示图片
 * @param title 如果是仅显示文字，需要传title
 * @param image 如果是仅显示图片，需要穿image
 * @param selector button相应的方法
 */
- (void)setRightBarButtonType:(BarButtonItemType)type title:(NSString *)title image:(UIImage *)image action:(SEL)selector;

/**
 * 快捷项目警告框
 * @param message 提示文本
 * @param sureAction “确定”按钮点击回调
 * @param needCancelBtn 是否需要显示“取消”按钮
 */
- (void)showAlertControllerToLogoutWithMessage:(NSString *)message
                                    sureAction:(void(^)(UIAlertAction *_Nonnull action))sureAction
                              needCancleButton:(BOOL)needCancelBtn;

/**
 * 快捷项目警告框
 * @param message 提示文本
 * @param sureAction “确定”按钮点击回调
 * @param sureActionTitle 自定义“确定”按钮文本
 * @param needCancelBtn 是否需要显示“取消”按钮
 */
- (void)showAlertControllerToLogoutWithMessage:(NSString *)message
                                    sureAction:(void(^)(UIAlertAction *_Nonnull action))sureAction
                               sureActionTitle:(NSString *)sureActionTitle
                              needCancleButton:(BOOL)needCancelBtn;

@end
