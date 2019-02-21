//
//  MPMCycleScrollView.m
//  MPMAtendence
//
//  Created by shengangneng on 2019/2/12.
//  Copyright © 2019年 gangneng shen. All rights reserved.
//

#import "MPMCycleScrollView.h"
#import "MPMCycleScrollViewFlowlayout.h"
#import "MPMCycleScrollViewCell.h"
#import "MPMAttendanceHeader.h"

static NSString *const identifier = @"Cell";

@interface MPMCycleScrollView () <UICollectionViewDelegate, UICollectionViewDataSource, MPMCycleScrollViewCellDelegate>

@property (nonatomic, strong) UIImageView *backgoundImageView;
@property (nonatomic, strong) MPMCycleScrollViewFlowlayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;

// Datas
@property (nonatomic, copy) NSArray *imageArray;    /** cell背景图片 */
@property (nonatomic, copy) NSArray *nameArray;     /** cell标题 */
@property (nonatomic, copy) NSArray *detailArray;   /** cell副标题 */
@property (nonatomic, copy) NSArray *centerImageArray;
@property (nonatomic, copy) NSArray *labelsArray;   /** cell快捷方式 */
@property (nonatomic, copy) NSArray *labelBorderColorArray;/** cell border Color */
@property (nonatomic, copy) NSArray *foldArray;
@property (nonatomic, assign) NSInteger totalItems;
@property (nonatomic, assign) CGFloat oldPoint;
@property (nonatomic, assign) NSInteger dragDirection;/** -1左 0不变 1右 */

@end

@implementation MPMCycleScrollView

#pragma mark - Public
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame shouldCycleLoop:(BOOL)cycleLoop imageGroups:(NSArray<UIImage *> *)imageGroups {
    MPMCycleScrollView *cycleScrollView = [[MPMCycleScrollView alloc] initWithFrame:frame];
    cycleScrollView.cycleLoop = cycleLoop;
    cycleScrollView.imageArray = imageGroups;
    return cycleScrollView;
}

/** 设置分页滑动属性（如果cycleLoop属性为YES，则设置无效）*/
- (void)setCollectionViewPagingEnabled:(BOOL)pagingEnabled {
    if (self.cycleLoop == NO) {
        self.collectionView.pagingEnabled = pagingEnabled;
    }
}

- (void)scrollToIndex:(NSInteger)index {
    // 滑到最后则调到中间
    if (index >= _totalItems)  {
        if (self.cycleLoop) {
            index = _totalItems * 0.5;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self addSubview:self.collectionView];
}

- (void)setupAttributes {
    self.cycleLoop = YES;
    self.isZoom = NO;
    self.itemWidth = self.bounds.size.width;
    self.cornerRadius = 0;
    self.bannerImageViewContentMode = UIViewContentModeScaleToFill;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    self.flowLayout.itemSize = CGSizeMake(_itemWidth, self.bounds.size.height);
    self.flowLayout.minimumLineSpacing = self.itemSpace;
    
    if (self.collectionView.contentOffset.x == 0 && _totalItems > 0) {
        NSInteger targeIndex = 0;
        if (self.cycleLoop) {// 无线循环
            // 如果是无限循环，应该默认把 collection 的 item 滑动到 中间位置。
            // 注意：此处 totalItems 的数值，其实是图片数组数量的 100 倍。
            // 乘以 0.5 ，正好是取得中间位置的 item 。图片也恰好是图片数组里面的第 0 个。
            targeIndex = _totalItems * 0.5;
        } else {
            targeIndex = 0;
        }
        self.currentIndex = targeIndex % _totalItems;
        // 设置图片默认位置
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:targeIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        self.oldPoint = self.collectionView.contentOffset.x;
        self.collectionView.userInteractionEnabled = YES;
    }
}

#pragma mark - MPMCycleScrollViewCellDelegate
- (void)scrollViewCell:(MPMCycleScrollViewCell *)scrollViewCell didSelectFastIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:scrollViewCell];
    if (indexPath.row != self.currentIndex) {
        // 判断如果点击的是左右的卡片上的快捷按钮，则切换卡片
        if ([self.delegate respondsToSelector:@selector(cycleScrollView:currentPageIndex:)]) {
            [self.delegate cycleScrollView:self currentPageIndex:indexPath.row % self.imageArray.count];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cycleScrollView:didSelectFastIndex:)]) {
            [self.delegate cycleScrollView:self didSelectFastIndex:index];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.collectionView.userInteractionEnabled = NO;
    if (!self.imageArray.count) return;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.oldPoint = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:self.collectionView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.collectionView.userInteractionEnabled = YES;
    if (!self.imageArray.count) return;
}

// 手离开屏幕的时候
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if(!self.cycleLoop) return;// 如果不是无限轮播，则返回
    
    // 如果是向右滑或者滑动距离大于item的一半，则像右移动一个item+space的距离，反之向左
    float currentPoint = scrollView.contentOffset.x;
    float moveWidth = currentPoint - self.oldPoint;
    int shouldPage = moveWidth/(self.itemWidth/2);
    if (velocity.x > 0 || shouldPage > 0) {
        self.dragDirection = 1;
    }else if (velocity.x < 0 || shouldPage < 0){
        self.dragDirection = -1;
    }else{
        self.dragDirection = 0;
    }
    self.collectionView.userInteractionEnabled = NO;
    NSInteger currentIndex = (self.oldPoint + (self.itemWidth + self.itemSpace) * 0.5) / (self.itemSpace + self.itemWidth);
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex + self.dragDirection inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    NSInteger realIndex = (currentIndex + self.dragDirection) % self.imageArray.count;
    _currentIndex = realIndex;
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:currentPageIndex:)]) {
        [self.delegate cycleScrollView:self currentPageIndex:realIndex];
    }
    
}

// 开始减速的时候
- (void)scrollViewWillBeginDecelerating: (UIScrollView *)scrollView {
    if(!self.cycleLoop) return;// 如果不是无限轮播，则返回
    // 松开手指滑动开始减速的时候，设置滑动动画
    NSInteger currentIndex = (self.oldPoint + (self.itemWidth + self.itemSpace) * 0.5) / (self.itemSpace + self.itemWidth);
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex + self.dragDirection inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _totalItems;
}

- (NSAttributedString *)getAttributeString:(NSString *)str {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
    return attributedString;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MPMCycleScrollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    long itemIndex = (int) indexPath.item % self.imageArray.count;
    UIColor *color = self.imageArray[itemIndex];
    cell.bgView.backgroundColor = color;
    cell.bgView.layer.shadowColor = color.CGColor;
    cell.nameLabel.text = self.nameArray[itemIndex];
    cell.detailLabel.attributedText = [self getAttributeString:self.detailArray[itemIndex]];
    NSNumber *fold = self.foldArray[itemIndex];
    __weak typeof(self) weakself = self;
    [cell setLabels:self.labelsArray[itemIndex] borderColor:self.labelBorderColorArray[itemIndex] fold:fold.boolValue operationBlock:^(BOOL fold) {
        __strong typeof(weakself) strongself = weakself;
        NSNumber *changeItem = fold ? @1 : @0;
        switch (itemIndex) {
            case 2:{
                NSNumber *item0 = strongself.foldArray[0];
                NSNumber *item1 = strongself.foldArray[1];
                NSNumber *item3 = strongself.foldArray[3];
                strongself.foldArray = @[item0,item1,changeItem,item3];
            }break;
            case 3:{
                NSNumber *item0 = strongself.foldArray[0];
                NSNumber *item1 = strongself.foldArray[1];
                NSNumber *item2 = strongself.foldArray[2];
                strongself.foldArray = @[item0,item1,item2,changeItem];
            }break;
            default:
                break;
        }
    }];
    cell.centerIcon.image = self.centerImageArray[itemIndex];
    cell.cornerRadius = self.cornerRadius;
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != self.currentIndex) {
        // 判断如果点击的是左右的卡片，则切换卡片
        if ([self.delegate respondsToSelector:@selector(cycleScrollView:currentPageIndex:)]) {
            [self.delegate cycleScrollView:self currentPageIndex:indexPath.row % self.imageArray.count];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cycleScrollView:didSelectFastIndex:)]) {
            [self.delegate cycleScrollView:self didSelectFastIndex:-1];
        }
    }
}

#pragma mark - Private Method
- (NSInteger)currentIndex {
    if (self.collectionView.frame.size.width == 0 || self.collectionView.frame.size.height == 0) {
        return 0;
    }
    NSInteger index = 0;
    
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {//水平滑动
        index = (self.collectionView.contentOffset.x + (self.itemWidth + self.itemSpace) * 0.5) / (self.itemSpace + self.itemWidth);
    }else{
        index = (self.collectionView.contentOffset.y + _flowLayout.itemSize.height * 0.5)/ _flowLayout.itemSize.height;
    }
    return MAX(0, index);
}

#pragma mark - Setter && Getter

- (void)setItemWidth:(CGFloat)itemWidth {
    _itemWidth = itemWidth;
    self.flowLayout.itemSize = CGSizeMake(itemWidth, self.bounds.size.height);
}
- (void)setItemSpace:(CGFloat)itemSpace {
    _itemSpace = itemSpace;
    self.flowLayout.minimumLineSpacing = itemSpace;
}
- (void)setIsZoom:(BOOL)isZoom {
    _isZoom = isZoom;
    self.flowLayout.isZoom = isZoom;
}

- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    _totalItems = self.cycleLoop ? imageArray.count * 100 : imageArray.count;
    if (_imageArray.count > 0) {
        self.collectionView.scrollEnabled = YES;
    } else {
        self.collectionView.scrollEnabled = NO;
    }
    [self.collectionView reloadData];
}

#pragma mark - Lazy Init

- (UICollectionView *)collectionView {
    if(!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.layer.masksToBounds = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = kClearColor;
        [_collectionView registerClass:[MPMCycleScrollViewCell class] forCellWithReuseIdentifier:identifier];
        
    }
    return _collectionView;
}

- (MPMCycleScrollViewFlowlayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[MPMCycleScrollViewFlowlayout alloc] init];
        _flowLayout.isZoom = self.isZoom;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumLineSpacing = 0;
    }
    return _flowLayout;
}

- (NSArray *)nameArray {
    if (!_nameArray) {
        _nameArray = @[@"请假",@"出差",@"加班",@"外出"];
    }
    return _nameArray;
}

- (NSArray *)detailArray {
    if (!_detailArray) {
        _detailArray = @[@"请假申请通过后，系统将自动产生相应的奖扣分",@"出差申请通过后，系统将自动产生相应的奖扣分",@"加班申请通过后，系统将自动产生相应的奖扣分",@"外出申请通过后，系统将自动产生相应的奖扣分"];
    }
    return _detailArray;
}

- (NSArray *)labelsArray {
    if (!_labelsArray) {
        _labelsArray = @[@[@"上午",@"下午",@"明天"],
                         @[@"明天",@"2天",@"3天"],
                         @[@"1小时",@"2小时",@"3小时",@"明天"],
                         @[@"1小时",@"2小时",@"3小时",@"上午",@"下午",@"明天"]];
    }
    return _labelsArray;
}

- (NSArray *)centerImageArray {
    if (!_centerImageArray) {
        UIImage *image1 = ImageName(@"apply_sickleave_center");
        UIImage *image2 = ImageName(@"apply_evecation_center");
        UIImage *image3 = ImageName(@"apply_overtime_center");
        UIImage *image4 = ImageName(@"apply_goout_center");
        _centerImageArray = @[image1,image2,image3,image4];
    }
    return _centerImageArray;
}

- (NSArray *)labelBorderColorArray {
    if (!_labelBorderColorArray) {
        _labelBorderColorArray = @[kRGBA(106,190,254,1),
                                   kRGBA(165,173,255,1),
                                   kRGBA(253,221,82,1),
                                   kRGBA(182,236,112,1)];
    }
    return _labelBorderColorArray;
}

- (NSArray *)foldArray {
    if (!_foldArray) {
        _foldArray = @[@0,@0,@0,@0];
    }
    return _foldArray;
}

@end
