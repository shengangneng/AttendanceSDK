//
//  MPMAttendenceMapViewController.m
//  MPMAtendence
//  地图
//  Created by shengangneng on 2018/5/13.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMAttendenceMapViewController.h"
#import "MPMButton.h"
#import "MPMPlaceInfoModel.h"
#import "JZLocationConverter.h"
#import "MPMBaseTableViewCell.h"
#import "MPMMapSelectTableViewCell.h"

@interface MPMAttendenceMapViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate>

@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UISearchBar *headerSearchBar;

@property (nonatomic, strong) MKMapView *middleMapView;
@property (nonatomic, strong) UIButton *backToCurrentLocation;
@property (nonatomic, strong) UITableView *middleTableView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *bottomSureButton;
// map
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) UIImageView *locationImageView;   /** 当前位置的一个标志图 */
@property (nonatomic, strong) NSMutableArray *locationsArray;   /** 记录一些周边位置 */
@property (nonatomic, assign) BOOL isGetUserLocation;   /** 是否已获取到用户位置 */
@property (nonatomic, assign) BOOL isSpan;              /** 是否在滑动 */
@property (nonatomic, assign) BOOL isPinch;             /** 是否在缩放 */
@property (nonatomic, copy) NSString *searchKeyWord;       /** 搜索内容 */
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;   /** 选中的row */
@property (nonatomic, assign) MKCoordinateRegion currentLocationRegion;

@end

@implementation MPMAttendenceMapViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupAttributes {
    [super setupAttributes];
    self.navigationItem.title = @"位置";
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.locationsArray = [NSMutableArray array];
    self.isGetUserLocation = self.isSpan = self.isPinch = NO;
    [self.middleMapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBack:)]];
    [self.backToCurrentLocation addTarget:self action:@selector(backToCurrentLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self setLeftBarButtonWithTitle:@"返回" action:@selector(back:)];
    [self.bottomSureButton addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [super setupSubViews];
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.headerSearchBar];
    
    [self.view addSubview:self.middleMapView];
    [self.middleMapView addSubview:self.backToCurrentLocation];
    [self.view addSubview:self.middleTableView];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomSureButton];
    [self.bottomView addSubview:self.bottomLine];
}

- (void)setupConstraints {
    [super setupConstraints];
    [self.headerView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.view.mpm_leading);
        make.top.equalTo(self.view.mpm_top);
        make.trailing.equalTo(self.view.mpm_trailing);
        make.height.equalTo(@(60));
    }];
    [self.headerSearchBar mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.headerView.mpm_leading);
        make.trailing.equalTo(self.headerView.mpm_trailing);
        make.bottom.equalTo(self.headerView.mpm_bottom);
        make.top.equalTo(self.headerView.mpm_top);
    }];
    [self.middleMapView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@200);
        make.top.equalTo(self.headerView.mpm_bottom);
    }];
    [self.middleTableView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.middleMapView.mpm_bottom);
        make.bottom.equalTo(self.bottomView.mpm_top);
    }];
    [self.backToCurrentLocation mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.height.equalTo(@28);
        make.bottom.equalTo(self.middleMapView.mpm_bottom).offset(-25);
        make.leading.equalTo(self.middleMapView.mpm_leading).offset(10);
    }];
    [self.bottomView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.view);
        make.height.equalTo(@(BottomViewHeight));
    }];
    [self.bottomSureButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.bottomView.mpm_leading).offset(12);
        make.trailing.equalTo(self.bottomView.mpm_trailing).offset(-12);
        make.top.equalTo(self.bottomView.mpm_top).offset(BottomViewTopMargin);
        make.bottom.equalTo(self.bottomView.mpm_bottom).offset(-BottomViewBottomMargin);
    }];
    [self.bottomLine mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.bottomView);
        make.height.equalTo(@0.5);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![CLLocationManager locationServicesEnabled] ||
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    for (UIView *view in self.middleMapView.subviews) {
        NSString *viewName = NSStringFromClass([view class]);
        if ([viewName isEqualToString:@"_MKMapContentView"]) {
            UIView *contentView = view;
            for (UIGestureRecognizer *gestureRecognizer in contentView.gestureRecognizers) {
                if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
                    [gestureRecognizer addTarget:self action:@selector(mapViewSpanGesture:)];
                }
                if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
                    [gestureRecognizer addTarget:self action:@selector(mapViewPinchGesture:)];
                }
            }
        }
    }
}

#pragma mark - Target Action
- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sure:(UIButton *)sender {
    if (self.locationsArray.count == 0) {
        return;
    }
    if (self.completeSelectPlace) {
        self.completeSelectPlace(self.locationsArray[self.selectedIndexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

// 返回当前定位的地点
- (void)backToCurrentLocation:(UIButton *)sender {
    self.searchKeyWord = nil;
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.middleMapView setRegion:self.currentLocationRegion animated:YES];
    [self getAddressByLatitude:self.currentLocationRegion.center.latitude longitude:self.currentLocationRegion.center.longitude];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locationsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    MPMMapSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MPMMapSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.detailTextLabel.textColor = kMainLightGray;
        cell.textLabel.font = SystemFont(17);
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    cell.checkLocation = self.selectedIndexPath == indexPath;
    if (self.selectedIndexPath == indexPath) {
        [self tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    MPMPlaceInfoModel *model = self.locationsArray[indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@%@",kNoNullString(model.locality),kNoNullString(model.subLocality),kNoNullString(model.thoroughfare)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndexPath != indexPath) {
        MPMMapSelectTableViewCell *cellOld = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
        MPMMapSelectTableViewCell *cellNew = [tableView cellForRowAtIndexPath:indexPath];
        cellOld.checkLocation = NO;
        cellNew.checkLocation = YES;
        self.selectedIndexPath = indexPath;
    }
    MPMPlaceInfoModel *model = self.locationsArray[indexPath.row];
    double distance = [self getDistanceBetweenTwoModel:model model2:self.locationsArray.firstObject];
    DLog(@"%.f",distance);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(model.coordinate, 200, 200);
    [self.middleMapView setRegion:region animated:YES];
    self.locationImageView.center = CGPointMake(self.middleMapView.center.x, self.middleMapView.center.y - 7.5);
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (!self.isGetUserLocation) {
        if (self.middleMapView.userLocationVisible) {
            self.isGetUserLocation = YES;
            self.currentLocationRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 200, 200);
            [self.middleMapView setRegion:self.currentLocationRegion animated:YES];
            [self getAddressByLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
            self.locationImageView.center = CGPointMake(self.middleMapView.center.x, self.middleMapView.center.y - 7.5);
        }
    } else {
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    [self.view endEditing:YES];
    self.searchKeyWord = nil;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if (self.locationImageView && (self.isSpan || self.isPinch)) {
        CGPoint mapCenter = self.middleMapView.center;
        CLLocationCoordinate2D coordinate = [self.middleMapView convertPoint:CGPointMake(self.middleMapView.center.x, self.middleMapView.center.y - kNavigationHeight) toCoordinateFromView:self.middleMapView];
        [self getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude];
        self.locationImageView.center = CGPointMake(mapCenter.x, mapCenter.y - 7.5);
        [UIView animateWithDuration:0.2 animations:^{
            self.locationImageView.center = CGPointMake(mapCenter.x, mapCenter.y - 7.5);
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.05 animations:^{
                    self.locationImageView.transform = CGAffineTransformMakeScale(1.0, 0.8);
                } completion:^(BOOL finished){
                    if (finished) {
                        [UIView animateWithDuration:0.1 animations:^{
                            self.locationImageView.transform = CGAffineTransformIdentity;
                        } completion:^(BOOL finished){
                            if (finished) {
                                self.isSpan = NO;
                            }
                        }];
                    }
                }];
            }
        }];
    }
}

#pragma mark - Private Method
- (void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
    // 反地理编码
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updatePlace:placemarks];
                [self getAroundInfomationWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
                [self.middleTableView reloadData];
            });
        } else {
            self.isGetUserLocation = NO;
        }
    }];
}

- (void)updatePlace:(NSArray *)places {
    [self.locationsArray removeAllObjects];
    for (CLPlacemark *placemark in places) {
        MPMPlaceInfoModel *model = [[MPMPlaceInfoModel alloc] init];
        model.name = placemark.name;
        model.locality = placemark.locality;
        model.subLocality = placemark.subLocality;
        model.thoroughfare = placemark.thoroughfare;
        model.subThoroughfare = placemark.subThoroughfare;
        model.city = placemark.locality;
        model.coordinate = placemark.location.coordinate;
        [self.locationsArray insertObject:model atIndex:0];
    }
}

- (void)tapBack:(UITapGestureRecognizer *)gesture {
    [self.view endEditing:YES];
}

- (double)getDistanceBetweenTwoModel:(MPMPlaceInfoModel *)model1 model2:(MPMPlaceInfoModel *)model2 {
    
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:model1.coordinate.latitude longitude:model1.coordinate.longitude];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:model2.coordinate.latitude longitude:model2.coordinate.longitude];
    
    return [loc1 distanceFromLocation:loc2];
}

- (void)getAroundInfomationWithCoordinate:(CLLocationCoordinate2D)coordinate {
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 200, 200);
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.region = region;
    if (kIsNilString(self.searchKeyWord)) {
        return;
    } else {
        request.naturalLanguageQuery = self.searchKeyWord;
    }
    MKLocalSearch *localSearch = [[MKLocalSearch alloc]initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (!error) {
            if (self.locationsArray.count > 0) {
                MPMPlaceInfoModel *model = self.locationsArray.firstObject;
                [self.locationsArray removeAllObjects];
                [self.locationsArray addObject:model];
            }
            [self getAroundInfo:response.mapItems];
        } else {
            self.isGetUserLocation = NO;
        }
    }];
}

- (void)getAroundInfo:(NSArray *)array {
    if (array.count == 0) {
        return;
    }
    [self.locationsArray removeAllObjects];
    for (MKMapItem *item in array) {
        MKPlacemark * placemark = item.placemark;
        MPMPlaceInfoModel *model = [[MPMPlaceInfoModel alloc] init];
        model.name = placemark.name;
        model.locality = placemark.locality;
        model.subLocality = placemark.subLocality;
        model.thoroughfare = placemark.thoroughfare;
        model.subThoroughfare = placemark.subThoroughfare;
        model.city = placemark.locality;
        model.coordinate = placemark.location.coordinate;
        [self.locationsArray addObject:model];
    }
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.middleTableView reloadData];
}

#pragma mark - Touchs
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.isSpan = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
    NSString *text = searchBar.text;
    self.searchKeyWord = text;
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = text;
    MKLocalSearch *localSearch = [[MKLocalSearch alloc]initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (!error) {
            if (self.locationsArray.count > 0) {
                MPMPlaceInfoModel *model = self.locationsArray.firstObject;
                [self.locationsArray removeAllObjects];
                [self.locationsArray addObject:model];
            }
            [self getAroundInfo:response.mapItems];
        } else {
            self.isGetUserLocation = NO;
        }
    }];
}

#pragma mark - MapView Gesture
- (void)mapViewSpanGesture:(UIPanGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateChanged:{
            self.isSpan = YES;
        }break;
        default:
            break;
    }
}

- (void)mapViewPinchGesture:(UIGestureRecognizer*)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateChanged:{
            self.isPinch = YES;
        }break;
        case UIGestureRecognizerStateEnded:{
            self.isPinch = NO;
        }break;
        default:
            break;
    }
}
#pragma mark - Resign Keyboard
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - Lazy Init
// header
- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
        _headerView.userInteractionEnabled = YES;
        _headerView.image = ImageName(@"statistics_nav");
    }
    return _headerView;
}

- (UISearchBar *)headerSearchBar {
    if (!_headerSearchBar) {
        _headerSearchBar = [[UISearchBar alloc] init];
        _headerSearchBar.delegate = self;
        _headerSearchBar.barTintColor = kClearColor;
        _headerSearchBar.backgroundImage = [[UIImage alloc] init];
        _headerSearchBar.placeholder = @"搜索地点";
    }
    return _headerSearchBar;
}
// middle
- (MKMapView *)middleMapView {
    if (!_middleMapView) {
        _middleMapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        _middleMapView.mapType = MKMapTypeStandard;
        _middleMapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
        _middleMapView.delegate = self;
        _middleMapView.showsUserLocation = YES;
    }
    return _middleMapView;
}

- (UIButton *)backToCurrentLocation {
    if (!_backToCurrentLocation) {
        _backToCurrentLocation = [MPMButton imageButtonWithImage:ImageName(@"setting_currentlocation") hImage:ImageName(@"setting_currentlocation")];
        _backToCurrentLocation.layer.cornerRadius = 14;
        _backToCurrentLocation.layer.borderWidth = 1;
        _backToCurrentLocation.layer.borderColor = kMainBlueColor.CGColor;
    }
    return _backToCurrentLocation;
}

- (UITableView *)middleTableView {
    if (!_middleTableView) {
        _middleTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _middleTableView.delegate = self;
        _middleTableView.dataSource = self;
        [_middleTableView setSeparatorColor:kSeperateColor];
        _middleTableView.tableFooterView = [[UIView alloc] init];
        _middleTableView.backgroundColor = kTableViewBGColor;
    }
    return _middleTableView;
}

// bottom
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = kWhiteColor;
    }
    return _bottomView;
}
- (UIButton *)bottomSureButton {
    if (!_bottomSureButton) {
        _bottomSureButton = [MPMButton titleButtonWithTitle:@"确定" nTitleColor:kWhiteColor hTitleColor:kMainLightGray nBGImage:ImageName(@"approval_but_complete") hImage:ImageName(@"approval_but_complete")];
    }
    return _bottomSureButton;
}
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = kSeperateColor;
    }
    return _bottomLine;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 5.0f;
    }
    return _locationManager;
}

- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (UIImageView *)locationImageView {
    if (!_locationImageView) {
        _locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 100, 15, 20)];
        _locationImageView.image = ImageName(@"attendence_location");
        [self.view addSubview:_locationImageView];
    }
    return _locationImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
