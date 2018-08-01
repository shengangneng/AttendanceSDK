//
//  MPMApprovalProcessHeaderSectionView.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/18.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMApprovalProcessHeaderSectionView.h"
#import "MPMButton.h"

@interface MPMApprovalProcessHeaderSectionView()

@property (nonatomic, strong) UIImageView *firstSectionView;    /** 一级导航 */
@property (nonatomic, strong) UIButton *firstMyApplyButton;     /** 我的申请*/
@property (nonatomic, strong) UIButton *firstMyApproveButton;   /** 我的审批 */
@property (nonatomic, strong) UIButton *firstCCListButton;      /** 抄送列表 */
@property (nonatomic, strong) UIButton *firstFillterButton;     /** 筛选按钮 */
@property (nonatomic, strong) UIView *firstUnderBlueLine;       /** 底部跟随线条 */

@property (nonatomic, strong) UIImageView *secondSectionView;   /** 二级导航 */
@property (nonatomic, strong) UIView *secondMyApplyView;        /** 我的申请*/
@property (nonatomic, strong) UIView *secondMyApproveView;      /** 我的审批 */
@property (nonatomic, strong) UIView *secondCCListView;         /** 抄送列表 */

/** 我的申请 */
@property (nonatomic, strong) UIButton *secondMyApplyDeedApplyButton;
@property (nonatomic, strong) UIButton *secondMyApplyAreadyApplyButton;
@property (nonatomic, strong) UIButton *secondMyApplyRejectApplyButton;
@property (nonatomic, strong) UIButton *secondMyApplyCancelApplyButton;
@property (nonatomic, strong) UIButton *secondMyApplyDraftApplyButton;
/** 我的审批 */
@property (nonatomic, strong) UIButton *secondMyApproveNeedApproveButton;
@property (nonatomic, strong) UIButton *secondMyApprovePassApproveButton;
@property (nonatomic, strong) UIButton *secondMyApproveAreadyRejectButton;
/** 抄送列表 */
@property (nonatomic, strong) UIButton *secondCCListCCToMeButton;
@property (nonatomic, strong) UIButton *secondCCListMyCCButton;

/** 把“我的申请”、“我的审批”、“抄送列表”存进数组 */
@property (nonatomic, copy) NSArray<UIButton *> *firstSectionButtonsArray;
/** 相应的，二级导航的视图也根据一级导航视图来变化 */
@property (nonatomic, copy) NSArray<UIView *> *secondSectionViewsArray;
@property (nonatomic, strong) UIButton *lastSelectedButton;

@end

@implementation MPMApprovalProcessHeaderSectionView

#pragma mark - Public Method

- (instancetype)initWithFirstSectionArray:(NSArray<MPMApprovalFirstSectionModel *> *)firstSectionArray {
    self = [super init];
    if (self) {
        self.firstSectionArray = firstSectionArray;
    }
    return self;
}

/** 设置默认选中按钮，会导致重新获取接口并刷新页面 */
- (void)setDefaultSelect {
    if (self.lastSelectedButton) {
        id target = self.lastSelectedButton.allTargets.allObjects.firstObject;
        if ([target isKindOfClass:[MPMApprovalProcessHeaderSectionView class]]) {
            NSArray *selectors = [self.lastSelectedButton actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
            @try {
                if (selectors.count > 0) {
                    SEL selector = NSSelectorFromString(selectors.firstObject);
                    [self performSelector:selector withObject:self.lastSelectedButton];
                }
            } @catch (NSException *exception) {
                DLog(@"%@",exception);
                self.lastSelectedButton = self.firstSectionButtonsArray.firstObject;
                [self firstSectionButton:self.lastSelectedButton];
            } @finally {}
        }
    } else {
        self.lastSelectedButton = self.firstSectionButtonsArray.firstObject;
        [self firstSectionButton:self.lastSelectedButton];
    }
}

- (void)setFirstSectionArray:(NSArray *)firstSectionArray {
    _firstSectionArray = firstSectionArray;
    if (firstSectionArray.count == 0) {
        self.firstSectionButtonsArray = @[self.firstMyApplyButton,self.firstMyApproveButton,self.firstCCListButton];
        self.secondSectionViewsArray = @[self.secondMyApplyView,self.secondMyApproveView,self.secondCCListView];
    } else {
        NSMutableArray *first = [NSMutableArray arrayWithCapacity:firstSectionArray.count];
        NSMutableArray *second = [NSMutableArray arrayWithCapacity:firstSectionArray.count];
        for (int i = 0; i < firstSectionArray.count; i++) {
            MPMApprovalFirstSectionModel *model = firstSectionArray[i];
            UIButton *btn = [self getButtonFromIndex:model.mpm_id];
            [first addObject:btn];
            UIView *view = [self getViewFromIndex:model.mpm_id];
            [second addObject:view];
        }
        self.firstSectionButtonsArray = first.copy;
        self.secondSectionViewsArray = second.copy;
    }
    
    [self setupAttributes];
    [self setupUI];
}

#pragma mark - Private Method

// 通过id获取是哪个按钮：1为我的申请、2为我的审批、3为抄送列表
- (UIButton *)getButtonFromIndex:(NSString *)index {
    switch (index.integerValue) {
        case 1:{
            return self.firstMyApplyButton;
        }break;
        case 2:{
            return self.firstMyApproveButton;
        }break;
        case 3:{
            return self.firstCCListButton;
        }break;
        default:
            return self.firstMyApplyButton;
            break;
    }
}
- (UIView *)getViewFromIndex:(NSString *)index {
    switch (index.integerValue) {
        case 1:{
            return self.secondMyApplyView;
        }break;
        case 2:{
            return self.secondMyApproveView;
        }break;
        case 3:{
            return self.secondCCListView;
        }break;
        default:
            return self.secondMyApplyView;
            break;
    }
}

/** 取消选中上一个按钮，选中当前按钮 */
- (BOOL)changeLastButtonToSender:(UIButton *)sender {
    // 即使是再点击一次当前按钮，也可以重新执行一次请求，因为从detail页面回来的时候需要刷新当前按钮的信息。
    self.lastSelectedButton.selected = NO;
    sender.selected = YES;
    self.lastSelectedButton = sender;
    return YES;
}

#pragma mark - Target Action
// Section1：我的申请Tag1、我的审批Tag2、抄送列表Tag3
- (void)firstSectionButton:(UIButton *)sender {
    NSInteger tag = sender.tag;
    // 修改蓝色跟随线位置
    UIButton *btn = [self getButtonFromIndex:[NSString stringWithFormat:@"%ld",tag]];
    [self.firstUnderBlueLine mpm_remakeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(btn.mpm_bottom).offset(-3);
        make.centerX.equalTo(btn.mpm_centerX);
        make.height.equalTo(@(2));
        CGSize size = [@"我的申请" sizeWithAttributes:@{NSFontAttributeName:SystemFont(18)}];
        make.width.equalTo(@(size.width));
    }];
    // 修改第二导航的位置
    UIView *firstView = self.secondSectionViewsArray.firstObject;
    UIView *currentView = [self getViewFromIndex:[NSString stringWithFormat:@"%ld",tag]];
    NSInteger currentIndex = [self.secondSectionViewsArray indexOfObject:currentView];
    [firstView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.secondSectionView.mpm_leading).offset(-kScreenWidth * currentIndex);
        make.top.bottom.equalTo(self.secondSectionView);
        make.width.equalTo(@(kScreenWidth));
    }];
    
    // 点击一级导航的时候，直接调用二级导航的按钮
    if (currentView == self.secondMyApplyView) {
        [self myApplyDeedApply:self.secondMyApplyDeedApplyButton];
    } else if (currentView == self.secondMyApproveView) {
        [self myApproveNeedApprove:self.secondMyApproveNeedApproveButton];
    } else {
        [self myCCListCCToMe:self.secondCCListCCToMeButton];
    }
}
// 我的申请
- (void)myApplyDeedApply:(UIButton *)sender {
    if ([self changeLastButtonToSender:sender]) {
        NSInteger currentIndex = [self.secondSectionViewsArray indexOfObject:self.secondMyApplyView];
        if (self.selectBlock) {
            self.selectBlock([NSIndexPath indexPathForRow:0 inSection:currentIndex], forMyApplyType);
        }
    }
}
- (void)myApplyAreadyApply:(UIButton *)sender {
    if ([self changeLastButtonToSender:sender]) {
        NSInteger currentIndex = [self.secondSectionViewsArray indexOfObject:self.secondMyApplyView];
        if (self.selectBlock) {
            self.selectBlock([NSIndexPath indexPathForRow:1 inSection:currentIndex], forMyApplyType);
        }
    }
}
- (void)myApplyRejectApply:(UIButton *)sender {
    if ([self changeLastButtonToSender:sender]) {
        NSInteger currentIndex = [self.secondSectionViewsArray indexOfObject:self.secondMyApplyView];
        if (self.selectBlock) {
            self.selectBlock([NSIndexPath indexPathForRow:2 inSection:currentIndex], forMyApplyType);
        }
    }
}
- (void)myApplyCancelApply:(UIButton *)sender {
    if ([self changeLastButtonToSender:sender]) {
        NSInteger currentIndex = [self.secondSectionViewsArray indexOfObject:self.secondMyApplyView];
        if (self.selectBlock) {
            self.selectBlock([NSIndexPath indexPathForRow:3 inSection:currentIndex], forMyApplyType);
        }
    }
}
- (void)myApplyDraftApply:(UIButton *)sender {
    if ([self changeLastButtonToSender:sender]) {
        NSInteger currentIndex = [self.secondSectionViewsArray indexOfObject:self.secondMyApplyView];
        if (self.selectBlock) {
            self.selectBlock([NSIndexPath indexPathForRow:4 inSection:currentIndex], forMyApplyType);
        }
    }
}
// 我的审批
- (void)myApproveNeedApprove:(UIButton *)sender {
    if ([self changeLastButtonToSender:sender]) {
        NSInteger currentIndex = [self.secondSectionViewsArray indexOfObject:self.secondMyApproveView];
        if (self.selectBlock) {
            self.selectBlock([NSIndexPath indexPathForRow:0 inSection:currentIndex], forMyApprovalType);
        }
    }
}
- (void)myApprovePassApprove:(UIButton *)sender {
    if ([self changeLastButtonToSender:sender]) {
        NSInteger currentIndex = [self.secondSectionViewsArray indexOfObject:self.secondMyApproveView];
        if (self.selectBlock) {
            self.selectBlock([NSIndexPath indexPathForRow:1 inSection:currentIndex], forMyApprovalType);
        }
    }
}
- (void)myApproveAreadyApprove:(UIButton *)sender {
    if ([self changeLastButtonToSender:sender]) {
        NSInteger currentIndex = [self.secondSectionViewsArray indexOfObject:self.secondMyApproveView];
        if (self.selectBlock) {
            self.selectBlock([NSIndexPath indexPathForRow:2 inSection:currentIndex], forMyApprovalType);
        }
    }
}
// 抄送列表
- (void)myCCListCCToMe:(UIButton *)sender {
    if ([self changeLastButtonToSender:sender]) {
        NSInteger currentIndex = [self.secondSectionViewsArray indexOfObject:self.secondCCListView];
        if (self.selectBlock) {
            self.selectBlock([NSIndexPath indexPathForRow:0 inSection:currentIndex], forCCListType);
        }
    }
}
- (void)myCCListMyCC:(UIButton *)sender {
    if ([self changeLastButtonToSender:sender]) {
        NSInteger currentIndex = [self.secondSectionViewsArray indexOfObject:self.secondCCListView];
        if (self.selectBlock) {
            self.selectBlock([NSIndexPath indexPathForRow:1 inSection:currentIndex], forCCListType);
        }
    }
}
// 高级筛选
- (void)myFillter:(UIButton *)sender {
    if (self.fillterBlock) {
        self.fillterBlock();
    }
}
- (void)setupAttributes {
    self.layer.masksToBounds = YES;
    // 一级导航
    [self.firstMyApplyButton addTarget:self action:@selector(firstSectionButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.firstMyApproveButton addTarget:self action:@selector(firstSectionButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.firstCCListButton addTarget:self action:@selector(firstSectionButton:) forControlEvents:UIControlEventTouchUpInside];
    // 我的申请
    [self.secondMyApplyDeedApplyButton addTarget:self action:@selector(myApplyDeedApply:) forControlEvents:UIControlEventTouchUpInside];
    [self.secondMyApplyAreadyApplyButton addTarget:self action:@selector(myApplyAreadyApply:) forControlEvents:UIControlEventTouchUpInside];
    [self.secondMyApplyRejectApplyButton addTarget:self action:@selector(myApplyRejectApply:) forControlEvents:UIControlEventTouchUpInside];
    [self.secondMyApplyCancelApplyButton addTarget:self action:@selector(myApplyCancelApply:) forControlEvents:UIControlEventTouchUpInside];
    [self.secondMyApplyDraftApplyButton addTarget:self action:@selector(myApplyDraftApply:) forControlEvents:UIControlEventTouchUpInside];
    // 我的审批
    [self.secondMyApproveNeedApproveButton addTarget:self action:@selector(myApproveNeedApprove:) forControlEvents:UIControlEventTouchUpInside];
    [self.secondMyApprovePassApproveButton addTarget:self action:@selector(myApprovePassApprove:) forControlEvents:UIControlEventTouchUpInside];
    [self.secondMyApproveAreadyRejectButton addTarget:self action:@selector(myApproveAreadyApprove:) forControlEvents:UIControlEventTouchUpInside];
    // 抄送列表
    [self.secondCCListCCToMeButton addTarget:self action:@selector(myCCListCCToMe:) forControlEvents:UIControlEventTouchUpInside];
    [self.secondCCListMyCCButton addTarget:self action:@selector(myCCListMyCC:) forControlEvents:UIControlEventTouchUpInside];
    // 高级筛选
    [self.firstFillterButton addTarget:self action:@selector(myFillter:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupUI {
    // 一级导航视图
    [self addSubview:self.firstSectionView];
    [self.firstSectionView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.mpm_top).offset(-10);
        make.height.equalTo(@(65));
    }];
    // 根据传入的一级导航数据来设置一级导航列表
    int width = (kScreenWidth - 45)/self.firstSectionArray.count;
    MPMViewAttribute *lastAttr = self.firstSectionView.mpm_leading;
    for (int i = 0; i < self.firstSectionButtonsArray.count; i++) {
        MPMApprovalFirstSectionModel *model = self.firstSectionArray[i];
        UIButton *btn = self.firstSectionButtonsArray[i];
        [btn setTitle:model.perimissionname forState:UIControlStateNormal];
        [btn setTitle:model.perimissionname forState:UIControlStateHighlighted];
        [self.firstSectionView addSubview:btn];
        [btn mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(lastAttr);
            make.centerY.equalTo(self.firstSectionView.mpm_centerY);
            make.height.equalTo(@(45));
            make.width.equalTo(@(width));
        }];
        lastAttr = btn.mpm_trailing;
        UIView *line = [[UIView alloc] init];line.backgroundColor = kSeperateColor;
        [self.firstSectionView addSubview:line];
        [line mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.trailing.equalTo(lastAttr).offset(-1);
            make.centerY.equalTo(self.firstSectionView.mpm_centerY);
            make.height.equalTo(@(35));
            make.width.equalTo(@(1));
        }];
    }
    
    // 一级导航的筛选按钮和底部的蓝色跟随线
    [self.firstSectionView addSubview:self.firstFillterButton];
    [self.firstFillterButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.trailing.equalTo(self.firstSectionView.mpm_trailing).offset(-13.5);
        make.centerY.equalTo(self.firstSectionView.mpm_centerY);
        make.height.width.equalTo(@(18));
    }];
    [self.firstSectionView addSubview:self.firstUnderBlueLine];
    
    [self.firstUnderBlueLine mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.firstSectionButtonsArray.firstObject.mpm_bottom).offset(-3);
        make.centerX.equalTo(self.firstSectionButtonsArray.firstObject.mpm_centerX);
        make.height.equalTo(@(2));
        CGSize size = [@"我的申请" sizeWithAttributes:@{NSFontAttributeName:SystemFont(18)}];
        make.width.equalTo(@(size.width));
    }];
    
    // 二级导航视图
    [self addSubview:self.secondSectionView];
    [self.secondSectionView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.firstSectionView.mpm_bottom).offset(-10);
        make.height.equalTo(@(40));
    }];
    
    lastAttr = self.secondSectionView.mpm_leading;
    for (int i = 0; i < self.secondSectionViewsArray.count; i++) {
        UIView *view = self.secondSectionViewsArray[i];
        [self.secondSectionView addSubview:view];
        [view mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(lastAttr);
            make.top.bottom.equalTo(self.secondSectionView);
            make.width.equalTo(@(kScreenWidth));
        }];
        lastAttr = view.mpm_trailing;
    }
    
    // 二级导航”我的申请“
    [self.secondMyApplyView addSubview:self.secondMyApplyDeedApplyButton];
    [self.secondMyApplyView addSubview:self.secondMyApplyAreadyApplyButton];
    [self.secondMyApplyView addSubview:self.secondMyApplyRejectApplyButton];
    [self.secondMyApplyView addSubview:self.secondMyApplyCancelApplyButton];
    [self.secondMyApplyView addSubview:self.secondMyApplyDraftApplyButton];
    [self.secondMyApplyDeedApplyButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.secondMyApplyView);
        make.top.bottom.equalTo(self.secondMyApplyView);
        make.width.equalTo(@(kScreenWidth/5));
    }];
    [self.secondMyApplyAreadyApplyButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.secondMyApplyDeedApplyButton.mpm_trailing);
        make.top.bottom.equalTo(self.secondMyApplyView);
        make.width.equalTo(@(kScreenWidth/5));
    }];
    [self.secondMyApplyRejectApplyButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.secondMyApplyAreadyApplyButton.mpm_trailing);
        make.top.bottom.equalTo(self.secondMyApplyView);
        make.width.equalTo(@(kScreenWidth/5));
    }];
    [self.secondMyApplyCancelApplyButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.secondMyApplyRejectApplyButton.mpm_trailing);
        make.top.bottom.equalTo(self.secondMyApplyView);
        make.width.equalTo(@(kScreenWidth/5));
    }];
    [self.secondMyApplyDraftApplyButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.secondMyApplyCancelApplyButton.mpm_trailing);
        make.top.bottom.equalTo(self.secondMyApplyView);
        make.width.equalTo(@(kScreenWidth/5));
    }];
    // 二级导航”我的审批：
    [self.secondMyApproveView addSubview:self.secondMyApproveNeedApproveButton];
    [self.secondMyApproveView addSubview:self.secondMyApprovePassApproveButton];
    [self.secondMyApproveView addSubview:self.secondMyApproveAreadyRejectButton];
    [self.secondMyApproveNeedApproveButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.secondMyApproveView);
        make.top.bottom.equalTo(self.secondMyApproveView);
        make.width.equalTo(@(kScreenWidth/3));
    }];
    [self.secondMyApprovePassApproveButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.secondMyApproveNeedApproveButton.mpm_trailing);
        make.top.bottom.equalTo(self.secondMyApproveView);
        make.width.equalTo(@(kScreenWidth/3));
    }];
    [self.secondMyApproveAreadyRejectButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.secondMyApprovePassApproveButton.mpm_trailing);
        make.top.bottom.equalTo(self.secondMyApproveView);
        make.width.equalTo(@(kScreenWidth/3));
    }];
    // 二级导航“抄送列表”
    [self.secondCCListView addSubview:self.secondCCListCCToMeButton];
    [self.secondCCListView addSubview:self.secondCCListMyCCButton];
    [self.secondCCListCCToMeButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.secondCCListView);
        make.top.bottom.equalTo(self.secondCCListView);
        make.width.equalTo(@(kScreenWidth/2));
    }];
    [self.secondCCListMyCCButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.secondCCListCCToMeButton.mpm_trailing);
        make.top.bottom.equalTo(self.secondCCListView);
        make.width.equalTo(@(kScreenWidth/2));
    }];
}

#pragma mark - Lazy Init
// 一级导航
- (UIImageView *)firstSectionView {
    if (!_firstSectionView) {
        _firstSectionView = [[UIImageView alloc] init];
        _firstSectionView.userInteractionEnabled = YES;
        _firstSectionView.image = ImageName(@"approval_nav_bg");
    }
    return _firstSectionView;
}

- (UIButton *)firstMyApplyButton {
    if (!_firstMyApplyButton) {
        _firstMyApplyButton = [MPMButton normalButtonWithTitle:@"我的申请" titleColor:kMainTextFontColor bgcolor:kWhiteColor];
        _firstMyApplyButton.tag = 1;
        [_firstMyApplyButton setTitleColor:kMainBlueColor forState:UIControlStateSelected];
        _firstMyApplyButton.titleLabel.font = SystemFont(17);
    }
    return _firstMyApplyButton;
}

- (UIButton *)firstMyApproveButton {
    if (!_firstMyApproveButton) {
        _firstMyApproveButton = [MPMButton normalButtonWithTitle:@"我的审批" titleColor:kMainTextFontColor bgcolor:kWhiteColor];
        _firstMyApproveButton.tag = 2;
        [_firstMyApproveButton setTitleColor:kMainBlueColor forState:UIControlStateSelected];
        _firstMyApproveButton.titleLabel.font = SystemFont(17);
    }
    return _firstMyApproveButton;
}

- (UIButton *)firstCCListButton {
    if (!_firstCCListButton) {
        _firstCCListButton = [MPMButton normalButtonWithTitle:@"抄送列表" titleColor:kMainTextFontColor bgcolor:kWhiteColor];
        _firstCCListButton.tag = 3;
        [_firstCCListButton setTitleColor:kMainBlueColor forState:UIControlStateSelected];
        _firstCCListButton.titleLabel.font = SystemFont(17);
    }
    return _firstCCListButton;
}

- (UIButton *)firstFillterButton {
    if (!_firstFillterButton) {
        _firstFillterButton = [MPMButton imageButtonWithImage:ImageName(@"approval_advancedfilter") hImage:nil];
    }
    return _firstFillterButton;
}

- (UIView *)firstUnderBlueLine {
    if (!_firstUnderBlueLine) {
        _firstUnderBlueLine = [[UIView alloc] init];
        _firstUnderBlueLine.backgroundColor = kMainBlueColor;
    }
    return _firstUnderBlueLine;
}

// 二级导航
- (UIImageView *)secondSectionView {
    if (!_secondSectionView) {
        _secondSectionView = [[UIImageView alloc] init];
        _secondSectionView.userInteractionEnabled = YES;
    }
    return _secondSectionView;
}

- (UIView *)secondMyApplyView {
    if (!_secondMyApplyView) {
        _secondMyApplyView = [[UIView alloc] init];
    }
    return _secondMyApplyView;
}

- (UIView *)secondMyApproveView {
    if (!_secondMyApproveView) {
        _secondMyApproveView = [[UIView alloc] init];
    }
    return _secondMyApproveView;
}

- (UIView *)secondCCListView {
    if (!_secondCCListView) {
        _secondCCListView = [[UIView alloc] init];
    }
    return _secondCCListView;
}
// 二级我的申请
- (UIButton *)secondMyApplyDeedApplyButton {
    if (!_secondMyApplyDeedApplyButton) {
        _secondMyApplyDeedApplyButton = [MPMButton normalButtonWithTitle:@"待审批" titleColor:kMainLightGray bgcolor:kClearColor];
        [_secondMyApplyDeedApplyButton setTitleColor:kMainBlueColor forState:UIControlStateSelected];
        _secondMyApplyDeedApplyButton.titleLabel.font = SystemFont(15);
    }
    return _secondMyApplyDeedApplyButton;
}

- (UIButton *)secondMyApplyAreadyApplyButton {
    if (!_secondMyApplyAreadyApplyButton) {
        _secondMyApplyAreadyApplyButton = [MPMButton normalButtonWithTitle:@"已审批" titleColor:kMainLightGray bgcolor:kClearColor];
        [_secondMyApplyAreadyApplyButton setTitleColor:kMainBlueColor forState:UIControlStateSelected];
        _secondMyApplyAreadyApplyButton.titleLabel.font = SystemFont(15);
    }
    return _secondMyApplyAreadyApplyButton;
}

- (UIButton *)secondMyApplyRejectApplyButton {
    if (!_secondMyApplyRejectApplyButton) {
        _secondMyApplyRejectApplyButton = [MPMButton normalButtonWithTitle:@"已驳回" titleColor:kMainLightGray bgcolor:kClearColor];
        [_secondMyApplyRejectApplyButton setTitleColor:kMainBlueColor forState:UIControlStateSelected];
        _secondMyApplyRejectApplyButton.titleLabel.font = SystemFont(15);
    }
    return _secondMyApplyRejectApplyButton;
}

- (UIButton *)secondMyApplyCancelApplyButton {
    if (!_secondMyApplyCancelApplyButton) {
        _secondMyApplyCancelApplyButton = [MPMButton normalButtonWithTitle:@"已撤回" titleColor:kMainLightGray bgcolor:kClearColor];
        [_secondMyApplyCancelApplyButton setTitleColor:kMainBlueColor forState:UIControlStateSelected];
        _secondMyApplyCancelApplyButton.titleLabel.font = SystemFont(15);
    }
    return _secondMyApplyCancelApplyButton;
}

- (UIButton *)secondMyApplyDraftApplyButton {
    if (!_secondMyApplyDraftApplyButton) {
        _secondMyApplyDraftApplyButton = [MPMButton normalButtonWithTitle:@"草稿箱" titleColor:kMainLightGray bgcolor:kClearColor];
        [_secondMyApplyDraftApplyButton setTitleColor:kMainBlueColor forState:UIControlStateSelected];
        _secondMyApplyDraftApplyButton.titleLabel.font = SystemFont(15);
    }
    return _secondMyApplyDraftApplyButton;
}
// 二级我的审批

- (UIButton *)secondMyApproveNeedApproveButton {
    if (!_secondMyApproveNeedApproveButton) {
        _secondMyApproveNeedApproveButton = [MPMButton normalButtonWithTitle:@"待我审批" titleColor:kMainLightGray bgcolor:kClearColor];
        [_secondMyApproveNeedApproveButton setTitleColor:kMainBlueColor forState:UIControlStateSelected];
        _secondMyApproveNeedApproveButton.titleLabel.font = SystemFont(15);
    }
    return _secondMyApproveNeedApproveButton;
}

- (UIButton *)secondMyApprovePassApproveButton {
    if (!_secondMyApprovePassApproveButton) {
        _secondMyApprovePassApproveButton = [MPMButton normalButtonWithTitle:@"已通过" titleColor:kMainLightGray bgcolor:kClearColor];
        [_secondMyApprovePassApproveButton setTitleColor:kMainBlueColor forState:UIControlStateSelected];
        _secondMyApprovePassApproveButton.titleLabel.font = SystemFont(15);
    }
    return _secondMyApprovePassApproveButton;
}

- (UIButton *)secondMyApproveAreadyRejectButton {
    if (!_secondMyApproveAreadyRejectButton) {
        _secondMyApproveAreadyRejectButton = [MPMButton normalButtonWithTitle:@"已驳回" titleColor:kMainLightGray bgcolor:kClearColor];
        [_secondMyApproveAreadyRejectButton setTitleColor:kMainBlueColor forState:UIControlStateSelected];
        _secondMyApproveAreadyRejectButton.titleLabel.font = SystemFont(15);
    }
    return _secondMyApproveAreadyRejectButton;
}
// 二级抄送列表
- (UIButton *)secondCCListCCToMeButton {
    if (!_secondCCListCCToMeButton) {
        _secondCCListCCToMeButton = [MPMButton normalButtonWithTitle:@"抄送给我" titleColor:kMainLightGray bgcolor:kClearColor];
        [_secondCCListCCToMeButton setTitleColor:kMainBlueColor forState:UIControlStateSelected];
        _secondCCListCCToMeButton.titleLabel.font = SystemFont(15);
    }
    return _secondCCListCCToMeButton;
}

- (UIButton *)secondCCListMyCCButton {
    if (!_secondCCListMyCCButton) {
        _secondCCListMyCCButton = [MPMButton normalButtonWithTitle:@"我的抄送" titleColor:kMainLightGray bgcolor:kClearColor];
        [_secondCCListMyCCButton setTitleColor:kMainBlueColor forState:UIControlStateSelected];
        _secondCCListMyCCButton.titleLabel.font = SystemFont(15);
    }
    return _secondCCListMyCCButton;
}

@end
