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

#define kCollectionViewCellTypeIdentifier @"MPMSiderDrawerCollectionViewButtonCell"
#define kCollectionViewCellTimeIdentifier @"MPMSiderDrawerCollectionViewTimeCell"
#define kCollectionViewCellReuseViewIdentifier @"ReusableView"

#define kSelectedSectionKey0 @"Section0"
#define kSelectedSectionKey1 @"Section1"

@interface MPMSideDrawerView() <UICollectionViewDelegate, UICollectionViewDataSource, MPMSiderDrawerTimeCellDelegate, MPMCustomDatePickerViewDelegate>
// Views
@property (nonatomic, strong) UIView *siderSuperView;
@property (nonatomic, strong) UIView *mainMaskView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UICollectionView *contentViewCollectionView;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) UIButton *doneButton;
// 日历
@property (nonatomic, strong) MPMCustomDatePickerView *customDatePickerView;
// Datas
@property (nonatomic, copy) NSArray *collectionViewTypesArray;
@property (nonatomic, copy) NSArray *collectionViewTimesArray;
// 高级筛选已选数组：里面再存放两个数组:数组里面存放的是选中的indexPath
@property (nonatomic, strong) NSMutableDictionary *collectionViewSelectedDictionay;
// 记录当前选中的“开始时间”还是“结束时间”按钮
@property (nonatomic, strong) UIButton *currentTimeButton;
@property (nonatomic, strong) UIButton *startTimeButton;
@property (nonatomic, strong) UIButton *endTimeButton;
// 保存选中的时间
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

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
    self.collectionViewSelectedDictionay = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[], kSelectedSectionKey0, @[], kSelectedSectionKey1, nil];
    self.collectionViewTypesArray = @[@"改签",@"补签",@"请假",@"出差",@"外出",@"调班",@"加班"];
    self.collectionViewTimesArray = @[@"",@"最近三天",@"最近一周",@"最近一月"];
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
    [self.contentViewCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.leading.equalTo(self.contentView.mas_leading).offset(6);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-6);
        make.height.equalTo(@(450));
    }];
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-BottomViewBottomMargin);
        make.height.equalTo(@(35));
    }];
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.resetButton.mas_trailing).offset(10);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-BottomViewBottomMargin);
        make.width.equalTo(self.resetButton.mas_width);
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
    self.collectionViewSelectedDictionay[kSelectedSectionKey0] = @[];
    self.collectionViewSelectedDictionay[kSelectedSectionKey1] = @[];
    self.startDate = nil;
    self.endDate = nil;
    [self.startTimeButton setTitle:@"开始时间" forState:UIControlStateNormal];
    [self.endTimeButton setTitle:@"结束时间" forState:UIControlStateNormal];
    [self.contentViewCollectionView reloadData];
}

- (void)done:(UIButton *)sender {
    DLog(@"完成");
    NSMutableArray *mdic = [NSMutableArray array];
    NSArray *arr = self.collectionViewSelectedDictionay[kSelectedSectionKey0];
    if (arr.count > 0) {
        for (int i = 0; i < arr.count; i++) {
            NSIndexPath *index = arr[i];
            NSString *name = self.collectionViewTypesArray[index.row];
            NSString *status = kSausactionNo[name];
            [mdic addObject:@(status.integerValue)];
        }
    }
    NSString *startDateString = self.startDate ? [NSDateFormatter formatterDate:self.startDate withDefineFormatterType:forDateFormatTypeYearMonthDayBar] : @"";
    NSString *endDateString = self.endDate ? [NSDateFormatter formatterDate:self.endDate withDefineFormatterType:forDateFormatTypeYearMonthDayBar] : @"";
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(siderDrawerView:didCompleteWithCausationtypeNo:startDate:endDate:)]) {
        [self.delegate siderDrawerView:self didCompleteWithCausationtypeNo:mdic.copy startDate:startDateString endDate:endDateString];
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
    if (((NSArray *)self.collectionViewSelectedDictionay[kSelectedSectionKey1]).count > 0) {
        self.startDate = self.endDate = nil;
    }
    // 1、取消section1中选中的按钮
    self.collectionViewSelectedDictionay[kSelectedSectionKey1] = @[];
    // 2、更新按钮title
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [self.currentTimeButton setTitle:[formater formatterDate:date withDefineFormatterType:forDateFormatTypeYearMonthDayBar] forState:UIControlStateNormal];
    // 3、记录选中的数据
    if (self.currentTimeButton.tag == StartButtonTag) {
        self.startDate = date;
    } else {
        self.endDate = date;
    }
    // 4、刷新collectionView的section1界面
    [self.contentViewCollectionView reloadData];
}

#pragma mark - Public Method

- (void)showInView:(UIView *)superView maskViewFrame:(CGRect)mFrame drawerViewFrame:(CGRect)dFrame {
    if (!superView) {
        return;
    }
    self.siderSuperView = superView;
    self.mainMaskView.frame = mFrame;
    self.contentView.frame = dFrame;
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
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return self.collectionViewTypesArray.count;
        }break;
        case 1: {
            return self.collectionViewTimesArray.count;
        }break;
        default:
            return 0;
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            MPMSiderDrawerCollectionViewButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellTypeIdentifier forIndexPath:indexPath];
            [cell.collectionCellButton setTitle:self.collectionViewTypesArray[indexPath.row] forState:UIControlStateNormal];
            NSArray *arr = self.collectionViewSelectedDictionay[kSelectedSectionKey0];
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
            if (indexPath.row == 0) {
                MPMSiderDrawerCollectionViewTimeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellTimeIdentifier forIndexPath:indexPath];
                cell.delegate = self;
                return cell;
            } else {
                MPMSiderDrawerCollectionViewButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellTypeIdentifier forIndexPath:indexPath];
                [cell.collectionCellButton setTitle:self.collectionViewTimesArray[indexPath.row] forState:UIControlStateNormal];
                NSArray *arr = self.collectionViewSelectedDictionay[kSelectedSectionKey1];
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
    switch (indexPath.section) {
        case 0:{
            NSArray *arr = self.collectionViewSelectedDictionay[kSelectedSectionKey0];
            if (arr && [arr containsObject:indexPath]) {
                // 包含，则移出去
                NSMutableArray *marr = [NSMutableArray array];
                for (id object in arr) {
                    if (object != indexPath) {
                        [marr addObject:object];
                    }
                }
                arr = marr.copy;
            } else {
                if (arr.count == 0) {
                    arr = @[indexPath];
                } else {
                    // 不包含，则加入
                    NSMutableArray *marr = [NSMutableArray array];
                    for (id object in arr) {
                        [marr addObject:object];
                    }
                    [marr addObject:indexPath];
                    arr = marr.copy;
                }
            }
            // 赋值回去
            self.collectionViewSelectedDictionay[kSelectedSectionKey0] = arr;
            [collectionView reloadData];
        }
            break;
        case 1:{
            if (indexPath.row == 0) {
                return;
            }
            NSArray *arr = self.collectionViewSelectedDictionay[kSelectedSectionKey1];
            if (arr.count == 0) {
                arr = @[indexPath];
            } else {
                NSIndexPath *index = arr.firstObject;
                if ([index compare:indexPath] != NSOrderedSame) {
                    arr = @[indexPath];
                }
            }
            self.collectionViewSelectedDictionay[kSelectedSectionKey1] = arr;
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
            DLog(@"heheh");
        }
            break;
        default:
            break;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:{
            MPMSiderDrawerCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                                                   UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionViewCellReuseViewIdentifier forIndexPath:indexPath];
            headerView.label.text = @"类型";
            return headerView;
        }
            break;
        case 1:{
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
    if (indexPath.section == 1 && indexPath.row == 0) {
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
