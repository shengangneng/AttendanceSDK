//
//  MPMSideDrawerView.m
//  MPMAtendence
//  侧边滑出-抽屉视图
//  Created by gangneng shen on 2018/4/25.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMSideDrawerView.h"
#import "MPMSiderDrawerCollectionViewButtonCell.h"
#import "MPMSiderDrawerCollectionViewTimeCell.h"
#import "MPMSiderDrawerCollectionReusableView.h"
#import "MPMButton.h"
#import "MPMCustomDatePickerView.h"
#import "NSDateFormatter+MPMExtention.h"
#import "MPMAttendanceHeader.h"

#define kCollectionViewCellTypeIdentifier @"MPMSiderDrawerCollectionViewButtonCell"
#define kCollectionViewCellTimeIdentifier @"MPMSiderDrawerCollectionViewTimeCell"
#define kCollectionViewCellReuseViewIdentifier @"ReusableView"

#define kSelectStatsKey @"SelectionStatsKey"
#define kSelectTypesKey @"SelectionTypesKey"
#define kSelectTimesKey @"SelectionTimesKey"

@interface MPMSideDrawerView() <UICollectionViewDelegate, UICollectionViewDataSource, MPMSiderDrawerTimeCellDelegate, MPMCustomDatePickerViewDelegate>
// Views
@property (nonatomic, strong) UIView *siderSuperView;
@property (nonatomic, strong) UIView *mainMaskView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UICollectionView *contentViewCollectionView;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) MPMCustomDatePickerView *customDatePickerView;/** 日历控件 */
// Datas
@property (nonatomic, copy) NSArray *collectionViewStatsArray;              /** 节点状态 */
@property (nonatomic, copy) NSArray *collectionViewTypesArray;              /** 类型 */
@property (nonatomic, copy) NSArray *collectionViewTimesArray;              /** 时间 */
@property (nonatomic, strong) NSMutableDictionary *collectionViewSelectedDictionay;/** 存放每个Section选中的indexPath */
// 记录当前选中的“开始时间”还是“结束时间”按钮
@property (nonatomic, strong) UIButton *currentTimeButton;
@property (nonatomic, strong) UIButton *startTimeButton;
@property (nonatomic, strong) UIButton *endTimeButton;

@end

@implementation MPMSideDrawerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupAttributes {
    self.collectionViewSelectedDictionay = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[[NSIndexPath indexPathForRow:0 inSection:0]], kSelectStatsKey, @[[NSIndexPath indexPathForRow:0 inSection:1]], kSelectTypesKey, @[], kSelectTimesKey, nil];
    self.collectionViewTypesArray = @[@"全部",@"补卡",@"改卡",@"请假",@"出差",@"加班",@"外出"];
    self.collectionViewTimesArray = @[@"",@"最近三天",@"最近一周",@"最近一月"];
    [self reset:nil];
    [self.contentView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDrawerView:)]];
    [self.mainMaskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMaskView:)]];
    [self.resetButton addTarget:self action:@selector(reset:) forControlEvents:UIControlEventTouchUpInside];
    [self.doneButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [self.contentView addSubview:self.contentViewCollectionView];
    [self.contentView addSubview:self.resetButton];
    [self.contentView addSubview:self.doneButton];
}

- (void)setupConstraints {
    [self.contentViewCollectionView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.contentView.mpm_top).offset(12);
        make.leading.equalTo(self.contentView.mpm_leading).offset(6);
        make.trailing.equalTo(self.contentView.mpm_trailing).offset(-6);
        make.bottom.equalTo(self.resetButton.mpm_top).offset(-BottomViewBottomMargin);
    }];
    [self.resetButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mpm_leading).offset(10);
        make.bottom.equalTo(self.contentView.mpm_bottom).offset(-BottomViewBottomMargin);
        make.height.equalTo(@(35));
    }];
    [self.doneButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.resetButton.mpm_trailing).offset(10);
        make.trailing.equalTo(self.contentView.mpm_trailing).offset(-10);
        make.bottom.equalTo(self.contentView.mpm_bottom).offset(-BottomViewBottomMargin);
        make.width.equalTo(self.resetButton.mpm_width);
        make.height.equalTo(@(35));
    }];
}

#pragma mark - GestureRecognizer

- (void)panDrawerView:(UIPanGestureRecognizer *)gesture {
    CGFloat width = self.contentView.frame.size.width;
    CGRect frame = self.contentView.frame;
    CGPoint point = [gesture locationInView:self.siderSuperView];
    if (point.x <= kScreenWidth - width) {
        frame.origin.x = kScreenWidth - width;
    } else {
        frame.origin.x = point.x;
    }
    self.contentView.frame = frame;
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (frame.origin.x > (kScreenWidth - width/2)) {
            // 超过本身宽度一半，就消失
            [self.contentView removeFromSuperview];
            [self.mainMaskView removeFromSuperview];
            if (self.delegate && [self.delegate respondsToSelector:@selector(siderDrawerViewDidDismiss)]) {
                [self.delegate siderDrawerViewDidDismiss];
            }
        } else {
            // 不到本身宽度一半，恢复原来形状
            CGRect frame = self.contentView.frame;
            frame.origin.x = kScreenWidth - width;
            self.contentView.frame = frame;
        }
    }
}

#pragma mark - Target Action

- (void)tapMaskView:(UITapGestureRecognizer *)gesture {
    [self dismiss];
}

- (void)reset:(UIButton *)sender {
    DLog(@"重置");
    self.collectionViewSelectedDictionay[kSelectStatsKey] = @[[NSIndexPath indexPathForRow:0 inSection:0]];
    self.collectionViewSelectedDictionay[kSelectTypesKey] = @[[NSIndexPath indexPathForRow:0 inSection:1]];
    self.collectionViewSelectedDictionay[kSelectTimesKey] = @[];
    self.state = nil;
    self.type = nil;
    self.startDate = nil;
    self.endDate = nil;
    self.pagesize = 10;
    [self.startTimeButton setTitle:@"开始时间" forState:UIControlStateNormal];
    [self.endTimeButton setTitle:@"结束时间" forState:UIControlStateNormal];
    [self.contentViewCollectionView reloadData];
}

- (void)done:(UIButton *)sender {
    DLog(@"完成");
    // 筛选选中的‘节点状态’
    NSArray *statArray = self.collectionViewSelectedDictionay[kSelectStatsKey];
    if (statArray.count > 0) {
        for (int i = 0; i < statArray.count; i++) {
            NSIndexPath *index = statArray[i];
            if (0 == index.row) {
                self.state = nil;
            } else {
                self.state = [NSString stringWithFormat:@"%ld",index.row];
            }
        }
    } else {
        self.state = nil;
    }
    // 筛选选中的‘类型’
    NSArray *typeArray = self.collectionViewSelectedDictionay[kSelectTypesKey];
    if (typeArray.count > 0) {
        for (int i = 0; i < typeArray.count; i++) {
            NSIndexPath *index = typeArray[i];
            if (0 == index.row) {
                self.type = nil;
            } else {
                NSString *name = self.collectionViewTypesArray[index.row];
                self.type = kProcessDefCode_GetCodeFromType[kGetCausationNumFromName[name]];
            }
        }
    } else {
        self.type = nil;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(siderDrawerViewDidCompleteSelected)]) {
        [self.delegate siderDrawerViewDidCompleteSelected];
    }
    [self dismiss];
}

#pragma mark - MPMSiderDrawerTimeCellDelegate
- (void)siderDrawerCell:(MPMSiderDrawerCollectionViewTimeCell *)cell didSelectStartTime:(UIButton *)sender {
    self.currentTimeButton = sender;
    self.startTimeButton = sender;
    [self.customDatePickerView showPicerViewWithType:kCustomPickerViewTypeYearMonthDay defaultDate:self.startDate];
}

- (void)siderDrawerCell:(MPMSiderDrawerCollectionViewTimeCell *)cell didSelectEndTime:(UIButton *)sender {
    self.currentTimeButton = sender;
    self.endTimeButton = sender;
    [self.customDatePickerView showPicerViewWithType:kCustomPickerViewTypeYearMonthDay defaultDate:self.endDate];
}

#pragma mark - MPMPickerViewDelegate
- (void)customDatePickerViewDidCompleteSelectDate:(NSDate *)date {
    // 0、如果之前有选中section1中的“最近三天、最近一周、最近一个月”，则需要清空
    if (((NSArray *)self.collectionViewSelectedDictionay[kSelectTimesKey]).count > 0) {
        self.startDate = self.endDate = nil;
    }
    self.collectionViewSelectedDictionay[kSelectTimesKey] = @[];
    if (self.currentTimeButton.tag == StartButtonTag) {
        if (self.endDate && self.endDate.timeIntervalSince1970 < date.timeIntervalSince1970) {
            [MPMProgressHUD showErrorWithStatus:@"开始时间不能大于结束时间"];return;
        }
        self.startDate = date;
    } else {
        if (self.startDate && date.timeIntervalSince1970 < self.startDate.timeIntervalSince1970) {
            [MPMProgressHUD showErrorWithStatus:@"开始时间不能大于结束时间"];return;
        }
        self.endDate = date;
    }
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [self.currentTimeButton setTitle:[formater formatterDate:date withDefineFormatterType:forDateFormatTypeYearMonthDayBar] forState:UIControlStateNormal];
    [self.contentViewCollectionView reloadData];
}

#pragma mark - Public Method

- (void)showInView:(UIView *)superView maskViewFrame:(CGRect)mFrame drawerViewFrame:(CGRect)dFrame statusTitles:(NSArray *)statusTitles {
    if (!superView) {
        return;
    }
    self.siderSuperView = superView;
    self.mainMaskView.frame = mFrame;
    self.contentView.frame = dFrame;
    // 节点状态
    self.collectionViewStatsArray = statusTitles;
    [self.contentViewCollectionView reloadData];
    [superView addSubview:self.mainMaskView];
    [superView addSubview:self.contentView];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.mainMaskView.hidden = NO;
        CGRect frame = dFrame;
        frame.origin.x = mFrame.size.width - dFrame.size.width;
        self.contentView.frame = frame;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.mainMaskView.hidden = YES;
        CGRect frame = self.contentView.frame;
        frame.origin.x = kScreenWidth;
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        [self.mainMaskView removeFromSuperview];
        [self.contentView removeFromSuperview];
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(siderDrawerViewDidDismiss)]) {
        [self.delegate siderDrawerViewDidDismiss];
    }
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.collectionViewStatsArray.count > 0) {
        return 3;
    } else {
        return 2;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger trueSection;
    if (self.collectionViewStatsArray.count > 0) {
        trueSection = section;
    } else {
        trueSection = section + 1;
    }
    switch (trueSection) {
        case 0: {
            return self.collectionViewStatsArray.count;
        }break;
        case 1: {
            return self.collectionViewTypesArray.count;
        }break;
        case 2: {
            return self.collectionViewTimesArray.count;
        }break;
        default:
            return 0;
            break;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section;
    if (self.collectionViewStatsArray.count > 0) {
        section = indexPath.section;
    } else {
        section = indexPath.section + 1;
    }
    
    switch (section) {
        case 0:{
            MPMSiderDrawerCollectionViewButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellTypeIdentifier forIndexPath:indexPath];
            [cell.collectionCellButton setTitle:self.collectionViewStatsArray[indexPath.row] forState:UIControlStateNormal];
            NSArray *arr = self.collectionViewSelectedDictionay[kSelectStatsKey];
            BOOL hasCell = NO;
            if (arr.count > 0) {
                for (NSIndexPath *index in arr) {
                    if ([index compare:indexPath] == NSOrderedSame) {
                        hasCell = YES;
                        break;
                    }
                }
            }
            cell.collectionCellButton.selected = hasCell;
            return cell;
        }
            break;
        case 1:{
            MPMSiderDrawerCollectionViewButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellTypeIdentifier forIndexPath:indexPath];
            [cell.collectionCellButton setTitle:self.collectionViewTypesArray[indexPath.row] forState:UIControlStateNormal];
            NSArray *arr = self.collectionViewSelectedDictionay[kSelectTypesKey];
            BOOL hasCell = NO;
            if (arr.count > 0) {
                if (self.collectionViewStatsArray.count > 0) {
                    for (NSIndexPath *index in arr) {
                        if ([index compare:indexPath] == NSOrderedSame) {
                            hasCell = YES;
                            break;
                        }
                    }
                } else {
                    for (NSIndexPath *index in arr) {
                        if (index.row == indexPath.row) {
                            hasCell = YES;
                            break;
                        }
                    }
                }
            }
            cell.collectionCellButton.selected = hasCell;
            return cell;
        }
            break;
        case 2:{
            if (indexPath.row == 0) {
                MPMSiderDrawerCollectionViewTimeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellTimeIdentifier forIndexPath:indexPath];
                cell.delegate = self;
                return cell;
            } else {
                MPMSiderDrawerCollectionViewButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellTypeIdentifier forIndexPath:indexPath];
                [cell.collectionCellButton setTitle:self.collectionViewTimesArray[indexPath.row] forState:UIControlStateNormal];
                NSArray *arr = self.collectionViewSelectedDictionay[kSelectTimesKey];
                if (arr.count > 0 && [(NSIndexPath *)arr.firstObject compare:indexPath] == NSOrderedSame) {
                    cell.collectionCellButton.selected = YES;
                } else {
                    cell.collectionCellButton.selected = NO;
                }
                return cell;
            }
        }
            break;
        default:
            break;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section;
    if (self.collectionViewStatsArray.count > 0) {
        section = indexPath.section;
    } else {
        section = indexPath.section + 1;
    }
    switch (section) {
        case 0:{
            NSArray *arr = self.collectionViewSelectedDictionay[kSelectStatsKey];
            if (arr && [arr containsObject:indexPath]) {
                //                // 包含，则移出去
                //                NSMutableArray *marr = [NSMutableArray array];
                //                for (id object in arr) {
                //                    if (object != indexPath) {
                //                        [marr addObject:object];
                //                    }
                //                }
                //                arr = marr.copy;
            } else {
                // 不包含，则清空再移入
                arr = @[indexPath];
            }
            // 赋值回去
            self.collectionViewSelectedDictionay[kSelectStatsKey] = arr;
            [collectionView reloadData];
        }
            break;
        case 1:{
            NSArray *arr = self.collectionViewSelectedDictionay[kSelectTypesKey];
            if (arr && [arr containsObject:indexPath]) {
                //                // 包含，则移出去
                //                NSMutableArray *marr = [NSMutableArray array];
                //                for (id object in arr) {
                //                    if (object != indexPath) {
                //                        [marr addObject:object];
                //                    }
                //                }
                //                arr = marr.copy;
            } else {
                // 不包含，则清空再移入
                arr = @[indexPath];
            }
            // 赋值回去
            self.collectionViewSelectedDictionay[kSelectTypesKey] = arr;
            [collectionView reloadData];
        }
            break;
        case 2:{
            if (indexPath.row == 0) {
                return;
            }
            NSArray *arr = self.collectionViewSelectedDictionay[kSelectTimesKey];
            if (arr.count == 0) {
                arr = @[indexPath];
            } else {
                NSIndexPath *index = arr.firstObject;
                if ([index compare:indexPath] != NSOrderedSame) {
                    arr = @[indexPath];
                }
            }
            self.collectionViewSelectedDictionay[kSelectTimesKey] = arr;
            [collectionView reloadData];
            // 选择了“最近三天、最近一周、最近一月”，需要清空“开始时间”、“结束时间”
            if (self.startTimeButton) {
                [self.startTimeButton setTitle:@"开始时间" forState:UIControlStateNormal];
            }
            if (self.endTimeButton) {
                [self.endTimeButton setTitle:@"结束时间" forState:UIControlStateNormal];
            }
            self.startDate = nil;
            self.endDate = nil;
            if (indexPath.row == 1) {
                self.startDate = [NSDate dateWithTimeIntervalSinceNow:-24*60*60*3];
                self.endDate = [NSDate date];
            } else if (indexPath.row == 2) {
                self.startDate = [NSDate dateWithTimeIntervalSinceNow:-24*60*60*7];
                self.endDate = [NSDate date];
            } else if (indexPath.row == 3) {
                self.startDate = [NSDate dateWithTimeIntervalSinceNow:-24*60*60*30];
                self.endDate = [NSDate date];
            }
        }
            break;
        default:
            break;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section;
    if (self.collectionViewStatsArray.count > 0) {
        section = indexPath.section;
    } else {
        section = indexPath.section + 1;
    }
    switch (section) {
        case 0:{
            MPMSiderDrawerCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                                                UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionViewCellReuseViewIdentifier forIndexPath:indexPath];
            headerView.label.text = @"节点状态";
            return headerView;
        }
            break;
        case 1:{
            MPMSiderDrawerCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                                                UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionViewCellReuseViewIdentifier forIndexPath:indexPath];
            headerView.label.text = @"类型";
            return headerView;
        }
            break;
        case 2:{
            MPMSiderDrawerCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                                                UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionViewCellReuseViewIdentifier forIndexPath:indexPath];
            headerView.label.text = @"时间";
            return headerView;
        }
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section;
    if (self.collectionViewStatsArray.count > 0) {
        section = indexPath.section;
    } else {
        section = indexPath.section + 1;
    }
    if (section == 2 && indexPath.row == 0) {
        return CGSizeMake(241, 55);
    } else {
        return CGSizeMake(120, 43);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(6, 0, 6, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - Lazy Init

- (UIView *)mainMaskView {
    if (!_mainMaskView) {
        _mainMaskView = [[UIView alloc] initWithFrame:CGRectZero];
        _mainMaskView.hidden = YES;
        _mainMaskView.backgroundColor = kBlackColor;
        _mainMaskView.alpha = 0.4;
    }
    return _mainMaskView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = kWhiteColor;
    }
    return _contentView;
}

- (UICollectionView *)contentViewCollectionView {
    if (!_contentViewCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.headerReferenceSize = CGSizeMake(241, 19);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        _contentViewCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _contentViewCollectionView.backgroundColor = kWhiteColor;
        _contentViewCollectionView.delegate = self;
        _contentViewCollectionView.dataSource = self;
        _contentViewCollectionView.showsVerticalScrollIndicator = NO;
        [_contentViewCollectionView registerClass:[MPMSiderDrawerCollectionViewButtonCell class] forCellWithReuseIdentifier:kCollectionViewCellTypeIdentifier];
        [_contentViewCollectionView registerClass:[MPMSiderDrawerCollectionViewTimeCell class] forCellWithReuseIdentifier:kCollectionViewCellTimeIdentifier];
        [_contentViewCollectionView registerClass:[MPMSiderDrawerCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionViewCellReuseViewIdentifier];
    }
    return _contentViewCollectionView;
}

- (UIButton *)resetButton {
    if (!_resetButton) {
        _resetButton = [MPMButton titleButtonWithTitle:@"重置" nTitleColor:kMainBlueColor hTitleColor:kMainTextFontColor nBGImage:ImageName(@"approval_but_default_reset") hImage:ImageName(@"approval_but_default_reset")];
        _resetButton.titleLabel.font = SystemFont(16);
    }
    return _resetButton;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [MPMButton titleButtonWithTitle:@"完成" nTitleColor:kWhiteColor hTitleColor:kMainTextFontColor nBGImage:ImageName(@"approval_but_complete") hImage:ImageName(@"approval_but_complete")];
        _doneButton.titleLabel.font = SystemFont(16);
    }
    return _doneButton;
}

- (MPMCustomDatePickerView *)customDatePickerView {
    if (!_customDatePickerView) {
        _customDatePickerView = [[MPMCustomDatePickerView alloc] init];
        _customDatePickerView.delegate = self;
    }
    return _customDatePickerView;
}

- (void)dealloc {
    DLog(@"%@ dealloc",self);
}

@end
