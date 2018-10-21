//
//  MPMOfflineView.h
//  MPMAtendence
//  无网络视图
//  Created by shengangneng on 2018/10/10.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MPMOfflineState) {
    kOfflineStateAvailable,     /** 网络状态可用 */
    kOfflineStateUnavailable,   /** 网络状态不可用 */
};

typedef void(^ReloadViewBlock)(void);

@interface MPMOfflineView : UIView

@property (nonatomic, assign) MPMOfflineState state;
@property (nonatomic, copy) ReloadViewBlock reloadViewBlock;

@end

NS_ASSUME_NONNULL_END
