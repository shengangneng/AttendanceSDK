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
@property (nonatomic, strong) UIButton *firstMyMatterButton;    /** 我的事项 */
@property (nonatomic, strong) UIButton *firstMyApplyButton;     /** 我的申请 */
@property (nonatomic, strong) UIButton *firstCCToMeButton;      /** 抄送列表 */
@property (nonatomic, strong) UIButton *firstFillterButton;     /** 筛选按钮 */
@property (nonatomic, strong) UIView *firstUnderBlueLine;       /** 底部跟随线条 */

@property (nonatomic, strong) UIImageView *secondSectionView;   /** 二级导航 */
@property (nonatomic, strong) UIView *secondMyMatterView;       /** 我的事项 */

@property (nonatomic, strong) UIView *myMatterUnreadRedView;    /** "我的事项"未读红色 */

/** 我的事项 */
@property (nonatomic, strong) UIButton *secondToBeDoneButton;
@property (nonatomic, strong) UIButton *secondAreadyDoneButton;

/** 把“我的申请”、“我的审批”、“抄送列表”存进数组 */
@property (nonatomic, copy) NSArray<UIButton *> *firstSectionButtonsArray;
/** 相应的，二级导航的视图也根据一级导航视图来变化 */
@property (nonatomic, copy) NSArray<UIView *> *secondSectionViewsArray;
@property (nonatomic, strong) UIButton *lastSelectedButton;
@property (nonatomic, strong) NSIndexPath *lastSelectedIndexPath;
@property (nonatomic, assign, getter=isFirstLoad) BOOL firstLoad;   /** 一个记录第一次加载的标识 */

@end

@implementation MPMApprovalProcessHeaderSectionView

#pragma mark - Public Method

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.firstSectionTitlesArray = @[@"我的事项",@"我的申请",@"抄送给我"];
        self.firstLoad = YES;
    }
    return self;
}

/** 设置默认选中按钮，会导致重新获取接口并刷新页面 */
- (void)setDefaultSelect {
    /*
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
     */
    
    if (!self.lastSelectedIndexPath) {
        self.lastSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    [self firstSectionButton:[self getButtonFromIndex:[NSString stringWithFormat:@"%ld",self.lastSelectedIndexPath.section + 1]]];
}

- (void)setFirstSectionTitlesArray:(NSArray *)firstSectionTitlesArray {
    _firstSectionTitlesArray = firstSectionTitlesArray;
    self.firstSectionButtonsArray = @[self.firstMyMatterButton,self.firstMyApplyButton,self.firstCCToMeButton];
    self.secondSectionViewsArray = @[self.secondMyMatterView];
    [self setupAttributes];
    [self setupUI];
}

#pragma mark - Private Method

- (void)setMyMatterHasUnreadCount:(BOOL)myMatterHasUnreadCount {
    self.myMatterUnreadRedView.hidden = !myMatterHasUnreadCount;
    _myMatterHasUnreadCount = myMatterHasUnreadCount;
}

// 通过tag获取是哪个按钮：1为我的事项、2为我的申请、3为抄送给我
- (UIButton *)getButtonFromIndex:(NSString *)index {
    switch (index.integerValue) {
        case 1:{
            return self.firstMyMatterButton;
        }break;
        case 2:{
            return self.firstMyApplyButton;
        }break;
        case 3:{
            return self.firstCCToMeButton;
        }break;
        default:
            return self.firstMyMatterButton;
            break;
    }
}

#pragma mark - Target Action
// Section1：我的事项Tag=1、我的申请Tag=2、抄送给我Tag=3
- (void)firstSectionButton:(UIButton *)sender {
    NSInteger tag = sender.tag;
    UIButton *lastFirstButton = [self getButtonFromIndex:[NSString stringWithFormat:@"%ld",self.lastSelectedIndexPath.section + 1]];
    lastFirstButton.selected = NO;
    sender.selected = YES;
    self.lastSelectedIndexPath = [NSIndexPath indexPathForRow:self.lastSelectedIndexPath.row inSection:tag - 1];
    
    // 修改蓝色跟随线位置
    [self.firstUnderBlueLine mpm_remakeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(sender.mpm_bottom).offset(-3);
        make.centerX.equalTo(sender.mpm_centerX);
        make.height.equalTo(@(2));
        CGSize size = [self.firstSectionTitlesArray.firstObject sizeWithAttributes:@{NSFontAttributeName:SystemFont(18)}];
        make.width.equalTo(@(size.width));
    }];
    
    BOOL needHideSecondSectionView = YES;
    if (tag == 1 && self.lastSelectedIndexPath.row == 0) {
        needHideSecondSectionView = NO;
        [self toBeDone:self.secondToBeDoneButton];
    } else if (tag == 1 && self.lastSelectedIndexPath.row == 1) {
        needHideSecondSectionView = NO;
        [self areadyDone:self.secondAreadyDoneButton];
    } else {
        needHideSecondSectionView = YES;
        if (self.selectBlock) {
            self.selectBlock(self.lastSelectedIndexPath);
        }
    }
    // 第一次进来的时候，不要动画
    if (self.isFirstLoad) {
        self.firstLoad = NO;
    } else {
        if (self.animateSecondSectionBlock) {
            self.animateSecondSectionBlock(needHideSecondSectionView);
        }
    }
}
/** 我的事项：待办 */
- (void)toBeDone:(UIButton *)sender {
    sender.selected = YES;
    if (self.lastSelectedIndexPath.row == 1) {
        // 如果之前选中的是已办
        self.secondAreadyDoneButton.selected = NO;
    }
    self.lastSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    if (self.selectBlock) {
        self.selectBlock(self.lastSelectedIndexPath);
    }
}
/** 我的事项：已办 */
- (void)areadyDone:(UIButton *)sender {
    sender.selected = YES;
    if (self.lastSelectedIndexPath.row == 0) {
        // 如果之前选中的是待办
        self.secondToBeDoneButton.selected = NO;
    }
    self.lastSelectedIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    if (self.selectBlock) {
        self.selectBlock(self.lastSelectedIndexPath);
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
    [self.firstMyMatterButton addTarget:self action:@selector(firstSectionButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.firstMyApplyButton addTarget:self action:@selector(firstSectionButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.firstCCToMeButton addTarget:self action:@selector(firstSectionButton:) forControlEvents:UIControlEventTouchUpInside];
    // 我的申请
    [self.secondToBeDoneButton addTarget:self action:@selector(toBeDone:) forControlEvents:UIControlEventTouchUpInside];
    [self.secondAreadyDoneButton addTarget:self action:@selector(areadyDone:) forControlEvents:UIControlEventTouchUpInside];
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
    
    double fillterWidth = 70;
    
    // 根据传入的一级导航数据来设置一级导航列表
    int itemWidth = (kScreenWidth - fillterWidth)/self.firstSectionButtonsArray.count;
    MPMViewAttribute *lastAttr = self.firstSectionView.mpm_leading;
    for (int i = 0; i < self.firstSectionButtonsArray.count; i++) {
        NSString *title = self.firstSectionTitlesArray[i];
        UIButton *btn = self.firstSectionButtonsArray[i];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateHighlighted];
        [self.firstSectionView addSubview:btn];
        [btn mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(lastAttr);
            make.centerY.equalTo(self.firstSectionView.mpm_centerY);
            make.width.equalTo(@(itemWidth));
            make.height.equalTo(@(45));
        }];
        lastAttr = btn.mpm_trailing;
        UIView *line = [[UIView alloc] init];line.backgroundColor = kSeperateColor;
        [self.firstSectionView addSubview:line];
        [line mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.trailing.equalTo(lastAttr).offset(-1);
            make.centerY.equalTo(self.firstSectionView.mpm_centerY);
            make.height.equalTo(@(29));
            make.width.equalTo(@(0.5));
        }];
    }
    
    [self.firstSectionView addSubview:self.myMatterUnreadRedView];
    [self.myMatterUnreadRedView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.height.equalTo(@6);
        CGSize size = [@"我的事项" sizeWithAttributes:@{NSFontAttributeName:SystemFont(18)}];
        make.leading.equalTo(self.firstSectionView.mpm_leading).offset((itemWidth - size.width)/2 + size.width - 3);
        make.top.equalTo(self.firstSectionView.mpm_top).offset(10+(45-size.height)/2);
    }];
    
    // 一级导航的筛选按钮和底部的蓝色跟随线
    [self.firstSectionView addSubview:self.firstFillterButton];
    [self.firstFillterButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.trailing.top.bottom.equalTo(self.firstSectionView);
        make.width.equalTo(@(fillterWidth));
    }];
    [self.firstSectionView addSubview:self.firstUnderBlueLine];
    
    [self.firstUnderBlueLine mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.firstSectionButtonsArray.firstObject.mpm_bottom).offset(-3);
        make.centerX.equalTo(self.firstSectionButtonsArray.firstObject.mpm_centerX);
        make.height.equalTo(@(2));
        CGSize size = [@"我的事项" sizeWithAttributes:@{NSFontAttributeName:SystemFont(18)}];
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
    
    // 二级导航”我的事项“
    [self.secondMyMatterView addSubview:self.secondToBeDoneButton];
    [self.secondMyMatterView addSubview:self.secondAreadyDoneButton];
    
    [self.secondToBeDoneButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.secondMyMatterView);
        make.top.bottom.equalTo(self.secondMyMatterView);
        make.width.equalTo(@(kScreenWidth/5));
    }];
    [self.secondAreadyDoneButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.secondToBeDoneButton.mpm_trailing);
        make.top.bottom.equalTo(self.secondMyMatterView);
        make.width.equalTo(@(fillterWidth));
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

- (UIButton *)firstMyMatterButton {
    if (!_firstMyMatterButton) {
        _firstMyMatterButton = [MPMButton normalButtonWithTitle:@"我的事项" titleColor:kMainTextFontColor bgcolor:kWhiteColor];
        _firstMyMatterButton.tag = 1;
        [_firstMyMatterButton setTitleColor:kMainBlueColor forState:UIControlStateSelected];
        _firstMyMatterButton.titleLabel.font = SystemFont(17);
    }
    return _firstMyMatterButton;
}

- (UIButton *)firstMyApplyButton {
    if (!_firstMyApplyButton) {
        _firstMyApplyButton = [MPMButton normalButtonWithTitle:@"我的申请" titleColor:kMainTextFontColor bgcolor:kWhiteColor];
        _firstMyApplyButton.tag = 2;
        [_firstMyApplyButton setTitleColor:kMainBlueColor forState:UIControlStateSelected];
        _firstMyApplyButton.titleLabel.font = SystemFont(17);
    }
    return _firstMyApplyButton;
}

- (UIButton *)firstCCToMeButton {
    if (!_firstCCToMeButton) {
        _firstCCToMeButton = [MPMButton normalButtonWithTitle:@"抄送给我" titleColor:kMainTextFontColor bgcolor:kWhiteColor];
        _firstCCToMeButton.tag = 3;
        [_firstCCToMeButton setTitleColor:kMainBlueColor forState:UIControlStateSelected];
        _firstCCToMeButton.titleLabel.font = SystemFont(17);
    }
    return _firstCCToMeButton;
}

- (UIButton *)firstFillterButton {
    if (!_firstFillterButton) {
        _firstFillterButton = [MPMButton buttonWithType:UIButtonTypeCustom];
        [_firstFillterButton setImage:ImageName(@"approval_advancedfilter") forState:UIControlStateNormal];
        [_firstFillterButton setImage:ImageName(@"approval_advancedfilter") forState:UIControlStateNormal];
        [_firstFillterButton setTitle:@"筛选" forState:UIControlStateNormal];
        [_firstFillterButton setTitle:@"筛选" forState:UIControlStateSelected];
        [_firstFillterButton setTitleColor:kMainTextFontColor forState:UIControlStateNormal];
        [_firstFillterButton setTitleColor:kMainBlueColor forState:UIControlStateSelected];
        _firstFillterButton.titleLabel.font = SystemFont(17);
    }
    return _firstFillterButton;
}

- (UIView *)firstUnderBlueLine {
    if (!_firstUnderBlueLine) {
        _firstUnderBlueLine = [[UIView alloc] init];
        _firstUnderBlueLine.layer.cornerRadius = 1;
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

- (UIView *)secondMyMatterView {
    if (!_secondMyMatterView) {
        _secondMyMatterView = [[UIView alloc] init];
    }
    return _secondMyMatterView;
}

- (UIButton *)secondToBeDoneButton {
    if (!_secondToBeDoneButton) {
        _secondToBeDoneButton = [MPMButton normalButtonWithTitle:@"待办" titleColor:kMainLightGray bgcolor:kClearColor];
        [_secondToBeDoneButton setTitleColor:kMainBlueColor forState:UIControlStateSelected];
        _secondToBeDoneButton.titleLabel.font = SystemFont(15);
    }
    return _secondToBeDoneButton;
}

- (UIButton *)secondAreadyDoneButton {
    if (!_secondAreadyDoneButton) {
        _secondAreadyDoneButton = [MPMButton normalButtonWithTitle:@"已办" titleColor:kMainLightGray bgcolor:kClearColor];
        [_secondAreadyDoneButton setTitleColor:kMainBlueColor forState:UIControlStateSelected];
        _secondAreadyDoneButton.titleLabel.font = SystemFont(15);
    }
    return _secondAreadyDoneButton;
}

- (UIView *)myMatterUnreadRedView {
    if (!_myMatterUnreadRedView) {
        _myMatterUnreadRedView = [[UIView alloc] init];
        _myMatterUnreadRedView.backgroundColor = kRedColor;
        _myMatterUnreadRedView.layer.cornerRadius = 3;
    }
    return _myMatterUnreadRedView;
}

@end
