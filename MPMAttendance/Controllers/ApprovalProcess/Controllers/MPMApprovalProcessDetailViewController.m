//
//  MPMApprovalProcessDetailViewController.m
//  MPMAtendence
//  流程审批-信息详情
//  Created by gangneng shen on 2018/4/25.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMApprovalProcessDetailViewController.h"
#import "MPMButton.h"
#import "MPMApprovalCausationModel.h"
#import "MPMApprovalFetchDetailModel.h"
#import "MPMApprovalProcessDetailTableViewCell.h"
#import "MPMShareUser.h"
#import "MPMSessionManager.h"
#import "NSDateFormatter+MPMExtention.h"
#import "MPMDetailTimeMessageView.h"
#import "MPMBaseDealingViewController.h"
#import "MPMDealingModel.h"
#import "MPMCausationDetailModel.h"
#import "UILabel+MPMExtention.h"

@interface MPMApprovalProcessDetailViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
// header
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *headerName;
@property (nonatomic, strong) UILabel *headerDepartment;
// middle
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;
// reason
@property (nonatomic, strong) UIView *contentReasonView;
@property (nonatomic, strong) UILabel *contentReasonBeginTimeLabel;
@property (nonatomic, strong) UILabel *contentReasonBeginTimeMessage;

@property (nonatomic, strong) UILabel *contentTableHeaderView;
@property (nonatomic, strong) UITableView *contentTableView;
// bottom
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *bottomLeftButton;
@property (nonatomic, strong) UIButton *bottomMiddleButton;
@property (nonatomic, strong) UIButton *bottomRightButton;

// Datas
@property (nonatomic, strong) MPMApprovalCausationModel *causation;
@property (nonatomic, copy) NSArray<MPMApprovalCausationDetailModel *> *causationDetailArray;
@property (nonatomic, copy) NSArray *tableViewCellMessage;
@property (nonatomic, copy) NSArray *bottonTitles;

@end

@implementation MPMApprovalProcessDetailViewController

/** params：ButtonTitles从上一页面传入的底部按钮 */
- (instancetype)initWithCausation:(MPMApprovalCausationModel *)causation CausationDetailArray:(NSArray *)causationDetail operationButtonTitles:(NSArray *)buttons image:(NSString *)image text:(NSString *)text {
    self = [super init];
    if (self) {
        self.bottonTitles = buttons;
        if (causation.causationtypeNo.integerValue == 0 || causation.causationtypeNo.integerValue == 1) {
            // 改签、补签
            [self getDataOfExchangeId:causation.exchangeId image:image text:text];
        } else {
            self.causation = causation;
            // 筛选数据
            NSMutableArray *filterDetail = [NSMutableArray arrayWithCapacity:causationDetail.count];
            for (int i = 0; i < causationDetail.count; i++) {
                MPMApprovalCausationDetailModel *model = causationDetail[i];
                if (kIsNilString(model.startTime) && kIsNilString(model.endTime) && kIsNilString(model.days)) {
                    continue;
                }
                [filterDetail addObject:model];
            }
            self.causationDetailArray = filterDetail.copy;
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
            NSString *approveDate = kIsNilString(self.causation.approveDate) ? @"" : [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:(kSafeString(self.causation.approveDate)).doubleValue/1000] withDefineFormatterType:forDateFormatTypeYearMonthDayHourMinite];
            [temp addObject:@{@"type":@"审批人",@"image":image,@"name":kSafeString(causation.nowApprove),@"date":approveDate,@"message":text}];
            [temp addObject:@{@"type":@"抄送人",@"image":@"approval_detail_passed",@"name":kIsNilString(causation.mpm_copyName)?@"无":causation.mpm_copyName,@"date":[self formatdate:kSafeString(causation.applicantDate) time:kSafeString(causation.applicantTime)],@"message":@"无抄送信息"}];
            [temp addObject:@{@"type":@"记录人",@"image":@"approval_detail_passed",@"name":kIsNilString(causation.approveName)?@"无":causation.approveName,@"date":[self formatdate:kSafeString(causation.applicantDate) time:kSafeString(causation.applicantTime)],@"message":@"无记录人信息"}];
            self.tableViewCellMessage = temp.copy;
            [self.contentReasonBeginTimeMessage setAttributedString:self.causation.reason font:SystemFont(15) lineSpace:2];
//            self.contentReasonBeginTimeMessage.text = self.causation.reason;
            [self setupSubViews];
            [self setupAttributes];
            [self setupConstraints];
        }
    }
    return self;
}

// 改签、补签，需要调用另外的接口获取数据
- (void)getDataOfExchangeId:(NSString *)exchangeId image:(NSString *)image text:(NSString *)text {
    NSString *url = [NSString stringWithFormat:@"%@ApproveController/getAttendanceApproveList?token=%@",MPMHost,[MPMShareUser shareUser].token];
    NSDictionary *params = @{@"exchangeId":kSafeString(exchangeId)};
    [[MPMSessionManager shareManager] postRequestWithURL:url params:params loadingMessage:@"正在加载" success:^(id response) {
        if ([response[@"dataObj"][@"obj"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = response[@"dataObj"][@"obj"];
            self.causation = [[MPMApprovalCausationModel alloc] initWithDictionary:dic];
        }
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
        NSString *approveDate = kIsNilString(self.causation.approveDate) ? @"" : [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:(kSafeString(self.causation.approveDate)).doubleValue/1000] withDefineFormatterType:forDateFormatTypeYearMonthDayHourMinite];
        [temp addObject:@{@"type":@"审批人",@"image":image,@"name":kSafeString(self.causation.nowApprove),@"date":approveDate,@"message":text}];
        [temp addObject:@{@"type":@"抄送人",@"image":@"approval_detail_passed",@"name":kIsNilString(self.causation.mpm_copyName)?@"无":self.causation.mpm_copyName,@"date":[self formatdate:kSafeString(self.causation.applicantDate) time:kSafeString(self.causation.applicantTime)],@"message":@"无抄送信息"}];
        [temp addObject:@{@"type":@"记录人",@"image":@"approval_detail_passed",@"name":kIsNilString(self.causation.approveName)?@"无":self.causation.approveName,@"date":[self formatdate:kSafeString(self.causation.applicantDate) time:kSafeString(self.causation.applicantTime)],@"message":@"无记录人信息"}];
        self.tableViewCellMessage = temp.copy;
//        self.contentReasonBeginTimeMessage.text = self.causation.reason;
        [self.contentReasonBeginTimeMessage setAttributedString:self.causation.reason font:SystemFont(15) lineSpace:2];
        [self setupSubViews];
        [self setupAttributes];
        [self setupConstraints];
    } failure:^(NSString *error) {
        [self setupSubViews];
        [self setupAttributes];
        [self setupConstraints];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setupSubViews {
    [super setupSubViews];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.headerImageView];
    [self.headerView addSubview:self.headerName];
    [self.headerView addSubview:self.headerDepartment];
    
    [self.scrollView addSubview:self.containerView];
    // reason
    [self.containerView addSubview:self.contentReasonView];
    [self.contentReasonView addSubview:self.contentReasonBeginTimeLabel];
    [self.contentReasonView addSubview:self.contentReasonBeginTimeMessage];
    [self.scrollView addSubview:self.contentTableView];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomLine];
    [self.bottomView addSubview:self.bottomLeftButton];
    [self.bottomView addSubview:self.bottomMiddleButton];
    [self.bottomView addSubview:self.bottomRightButton];
}

- (void)setupAttributes {
    [super setupAttributes];
    self.title = @"信息详情";
    self.view.backgroundColor = kWhiteColor;
    self.headerName.text = [MPMShareUser shareUser].employeeName;
    self.headerDepartment.text = [MPMShareUser shareUser].departmentName;
    [self setLeftBarButtonWithTitle:@"返回" action:@selector(back:)];
    [self.bottomLeftButton addTarget:self action:@selector(left:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomMiddleButton addTarget:self action:@selector(middle:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomRightButton addTarget:self action:@selector(right:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setupConstraints {
    [super setupConstraints];
    // header
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.view);
        make.height.equalTo(@70);
    }];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerView.mas_leading).offset(12);
        make.height.width.equalTo(@(49));
        make.centerY.equalTo(self.headerView.mas_centerY);
    }];
    [self.headerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerImageView.mas_trailing).offset(10);
        make.top.equalTo(self.headerImageView.mas_top);
        make.height.equalTo(@33);
    }];
    [self.headerDepartment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerImageView.mas_trailing).offset(10);
        make.bottom.equalTo(self.headerImageView.mas_bottom);
        make.height.equalTo(@25);
    }];
    // middle
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.top.equalTo(self.scrollView);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@(kScreenHeight));
    }];
    
    UIView *lastView = self.containerView;
    if (self.causation.causationtypeNo.integerValue == 0 || self.causation.causationtypeNo.integerValue == 1) {
        NSInteger height = self.causation.causationtypeNo.integerValue == 0 ? 112 : 90;
        MPMDetailTimeMessageView *messageView = [[MPMDetailTimeMessageView alloc] initWithFrame:CGRectZero typeName:kSausactionType[self.causation.causationtypeNo] model:self.causation detail:nil];
        [self.containerView addSubview:messageView];
        [messageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.containerView);
            make.height.equalTo(@(height));
            make.top.equalTo(lastView.mas_top);
        }];
        lastView = messageView;
    } else {
        for (int i = 0; i < self.causationDetailArray.count; i++) {
            NSString *name = (i == 0) ? @"处理类型" : @"";
            NSInteger height = (i == 0) ? 112 : 90;
            if (!kIsNilString(self.causationDetailArray[i].address)) {
                height += 22;
            }
            MPMDetailTimeMessageView *messageView = [[MPMDetailTimeMessageView alloc] initWithFrame:CGRectZero typeName:name model:self.causation detail:self.causationDetailArray[i]];
            [self.containerView addSubview:messageView];
            [messageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.equalTo(self.containerView);
                make.height.equalTo(@(height));
                if (i == 0) {
                    make.top.equalTo(lastView.mas_top);
                } else {
                    make.top.equalTo(lastView.mas_bottom).offset(10);
                }
            }];
            lastView = messageView;
        }
    }
    
    // reason
    [self.contentReasonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.containerView);
        make.top.equalTo(lastView.mas_bottom).offset(10);
        make.height.equalTo(self.contentReasonBeginTimeMessage.mas_height).offset(20);
    }];
    [self.contentReasonBeginTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentReasonView.mas_leading);
        make.top.equalTo(self.contentReasonView.mas_top).offset(10);
        make.height.equalTo(@22);
        make.width.equalTo(@87);
    }];
    [self.contentReasonBeginTimeMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentReasonBeginTimeLabel.mas_trailing).offset(5);
        make.trailing.equalTo(self.contentReasonView.mas_trailing).offset(-5);
        make.top.equalTo(self.contentReasonBeginTimeLabel.mas_top).offset(2);
    }];
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.contentReasonView.mas_bottom);
        make.bottom.equalTo(self.containerView.mas_bottom);
    }];
    
    // bottom
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.equalTo(@(BottomViewHeight));
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.bottomView);
        make.height.equalTo(@0.5);
    }];
    if (!self.bottonTitles || self.bottonTitles.count == 0) {
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self.view);
            make.height.equalTo(@(0));
        }];
    } else if (self.bottonTitles.count == 1) {
        [self.bottomLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.bottomView.mas_leading);
            make.width.equalTo(@0);
            make.top.equalTo(self.bottomView.mas_top).offset(BottomViewTopMargin);
            make.bottom.equalTo(self.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
        }];
        [self.bottomRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.bottomLeftButton.mas_trailing).offset(PX_H(23));
            make.trailing.equalTo(self.bottomView.mas_trailing).offset(-PX_H(23));
            make.top.equalTo(self.bottomView.mas_top).offset(BottomViewTopMargin);
            make.bottom.equalTo(self.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
        }];
        [self.bottomRightButton setTitle:self.bottonTitles.firstObject forState:UIControlStateNormal];
        [self.bottomRightButton setTitle:self.bottonTitles.firstObject forState:UIControlStateHighlighted];
    } else if (self.bottonTitles.count == 2) {
        [self.bottomLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.bottomView.mas_leading).offset(PX_H(23));
            make.width.equalTo(@((kScreenWidth - PX_H(69))/2));
            make.top.equalTo(self.bottomView.mas_top).offset(BottomViewTopMargin);
            make.bottom.equalTo(self.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
        }];
        [self.bottomRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.bottomLeftButton.mas_trailing).offset(PX_H(23));
            make.trailing.equalTo(self.bottomView.mas_trailing).offset(-PX_H(23));
            make.top.equalTo(self.bottomView.mas_top).offset(BottomViewTopMargin);
            make.bottom.equalTo(self.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
        }];
        [self.bottomLeftButton setTitle:self.bottonTitles.firstObject forState:UIControlStateNormal];
        [self.bottomLeftButton setTitle:self.bottonTitles.firstObject forState:UIControlStateHighlighted];
        [self.bottomRightButton setTitle:self.bottonTitles.lastObject forState:UIControlStateNormal];
        [self.bottomRightButton setTitle:self.bottonTitles.lastObject forState:UIControlStateHighlighted];
    } else {
        [self.bottomLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.bottomView.mas_leading).offset(12);
            make.top.equalTo(self.bottomView.mas_top).offset(BottomViewTopMargin);
            make.bottom.equalTo(self.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
        }];
        [self.bottomMiddleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.bottomLeftButton.mas_trailing).offset(12);
            make.width.equalTo(self.bottomLeftButton.mas_width);
            make.top.equalTo(self.bottomView.mas_top).offset(BottomViewTopMargin);
            make.bottom.equalTo(self.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
        }];
        [self.bottomRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.bottomMiddleButton.mas_trailing).offset(12);
            make.trailing.equalTo(self.bottomView.mas_trailing).offset(-12);
            make.width.equalTo(self.bottomLeftButton.mas_width);
            make.top.equalTo(self.bottomView.mas_top).offset(BottomViewTopMargin);
            make.bottom.equalTo(self.bottomView.mas_bottom).offset(-BottomViewBottomMargin);
        }];
        [self.bottomLeftButton setTitle:self.bottonTitles.firstObject forState:UIControlStateNormal];
        [self.bottomLeftButton setTitle:self.bottonTitles.firstObject forState:UIControlStateHighlighted];
        [self.bottomMiddleButton setTitle:self.bottonTitles[1] forState:UIControlStateNormal];
        [self.bottomMiddleButton setTitle:self.bottonTitles[1] forState:UIControlStateHighlighted];
        [self.bottomRightButton setTitle:self.bottonTitles.lastObject forState:UIControlStateNormal];
        [self.bottomRightButton setTitle:self.bottonTitles.lastObject forState:UIControlStateHighlighted];
    }
}

#pragma mark - Private Method
- (NSString *)formatdate:(NSString *)date time:(NSString *)time {
    if (kIsNilString(date) || date.length < 3) {
        return @"";
    }
    // +8小时
    NSDate *tt = [NSDate dateWithTimeIntervalSince1970:((time.integerValue)/1000+28800) + date.integerValue/1000];
    NSString *real = [NSDateFormatter formatterDate:tt withDefineFormatterType:forDateFormatTypeYearMonthDayHourMinite];
    return real;
}

#pragma mark - Target Action
- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)left:(UIButton *)sender {
    DLog(@"Left == 删除、通过...");
    if (!self.bottonTitles || self.bottonTitles.count == 0) return;
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"删除"]) {
        // 删除操作，不需要status，可参考constants.js文件中的APPLYTYPECONFIG
        NSString *url = [NSString stringWithFormat:@"%@exceptionBatch/deletApprove?&employeeId=%@&token=%@",MPMHost,[MPMShareUser shareUser].employeeId,[MPMShareUser shareUser].token];
        NSMutableArray *params = [NSMutableArray arrayWithCapacity:1];
        NSDictionary *dic = @{@"causationtypeNo":self.causation.causationtypeNo,@"exchangeId":self.causation.exchangeId,@"rejectReason":@"",@"status":self.causation.status};
        [params addObject:dic];
        [[MPMSessionManager shareManager] postRequestWithURL:url params:params loadingMessage:@"正在操作" success:^(id response) {
            // 需要跳回上一个页面
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *error) {
            DLog(@"%@",error);
        }];
    } else if ([title isEqualToString:@"通过"]) {
        // 通过操作，status传6，可参考constants.js文件中的APPLYTYPECONFIG
        NSString *url = [NSString stringWithFormat:@"%@exceptionBatch/exceptionBatchApprove?status=%@&employeeId=%@&token=%@",MPMHost,@"6",[MPMShareUser shareUser].employeeId,[MPMShareUser shareUser].token];
        NSMutableArray *params = [NSMutableArray arrayWithCapacity:1];
        NSDictionary *dic = @{@"causationtypeNo":self.causation.causationtypeNo,@"exchangeId":self.causation.exchangeId,@"rejectReason":@"",@"status":self.causation.status};
        [params addObject:dic];
        [[MPMSessionManager shareManager] postRequestWithURL:url params:params loadingMessage:@"正在操作" success:^(id response) {
            // 跳回上一个页面
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *error) {
            DLog(@"%@",error);
        }];
    }
}

- (void)middle:(UIButton *)sender {
    DLog(@"编辑");
    
    MPMDealingModel *dealingModel = [[MPMDealingModel alloc] init];
    dealingModel.mpm_copyName = self.causation.mpm_copyName;
    dealingModel.mpm_copyNameId = self.causation.mpm_copyNameId;
    dealingModel.approvalName = self.causation.approveName;
    dealingModel.approvalId = self.causation.approveId;
    dealingModel.nowApproval = self.causation.nowApprove;
    dealingModel.nowApprovalId = self.causation.nowApproveId;
    dealingModel.status = self.causation.status;
    dealingModel.type = @"0";
    dealingModel.remark = self.causation.reason;
    dealingModel.attendenceId = self.causation.exchangeId;
    dealingModel.oriAttendenceDate = [NSString stringWithFormat:@"%.f",self.causation.schedulingDate.doubleValue/1000];
    dealingModel.brushDate = [NSString stringWithFormat:@"%.f",[NSDateFormatter getZeroWithTimeInterverl:self.causation.attendanceDate.doubleValue/1000]*1000];
    dealingModel.brushTime = [NSString stringWithFormat:@"%.f",fabs((self.causation.attendanceDate.doubleValue - dealingModel.brushDate.doubleValue - 28800000))];
    dealingModel.attendenceDate = [NSString stringWithFormat:@"%.f",self.causation.attendanceDate.doubleValue/1000];
    dealingModel.createTime = self.causation.attendanceTime;
    dealingModel.causationDetail = [NSMutableArray arrayWithCapacity:self.causationDetailArray.count];
    for (MPMApprovalCausationDetailModel *detail in self.causationDetailArray) {
        MPMCausationDetailModel *model = [[MPMCausationDetailModel alloc] init];
        model.address = detail.address;
        model.attendenceId = detail.causationId;
        model.startLongDate = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:(detail.startDate.doubleValue + detail.startTime.doubleValue)/1000 + 28800] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
        model.startDate = detail.startDate;
        model.startTime = detail.startTime;
        model.endLongDate = [NSDateFormatter formatterDate:[NSDate dateWithTimeIntervalSince1970:(detail.endDate.doubleValue + detail.endTime.doubleValue)/1000 + 28800] withDefineFormatterType:forDateFormatTypeAllWithoutSeconds];
        model.endDate = detail.endDate;
        model.endTime = detail.endTime;
        model.days = detail.days;
        [dealingModel.causationDetail addObject:model];
    }
    MPMBaseDealingViewController *dealing = [[MPMBaseDealingViewController alloc] initWithDealType:self.causation.causationtypeNo.integerValue typeStatus:nil dealingModel:dealingModel  dealingFromType:kDealingFromTypeEditing];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dealing animated:YES];
}

- (void)right:(UIButton *)sender {
    DLog(@"Right == 撤回、核销、提交...");
    if (!self.bottonTitles || self.bottonTitles.count == 0) return;
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"撤回"]) {
        // 撤回操作，status传5，可参考constants.js文件中的APPLYTYPECONFIG
        NSString *url = [NSString stringWithFormat:@"%@exceptionBatch/exceptionBatchApprove?status=%@&employeeId=%@&token=%@",MPMHost,@"5",[MPMShareUser shareUser].employeeId,[MPMShareUser shareUser].token];
        NSMutableArray *params = [NSMutableArray arrayWithCapacity:1];
        NSDictionary *dic = @{@"causationtypeNo":self.causation.causationtypeNo,@"exchangeId":self.causation.exchangeId,@"rejectReason":@"",@"status":self.causation.status};
        [params addObject:dic];
        [[MPMSessionManager shareManager] postRequestWithURL:url params:params loadingMessage:@"正在操作" success:^(id response) {
            // 跳回上一个页面
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *error) {
            DLog(@"%@",error);
        }];
    } else if ([title isEqualToString:@"提交"]) {
        // 提交操作，status传1，可参考constants.js文件中的APPLYTYPECONFIG
        NSString *url = [NSString stringWithFormat:@"%@exceptionBatch/exceptionBatchApprove?status=%@&employeeId=%@&token=%@",MPMHost,@"1",[MPMShareUser shareUser].employeeId,[MPMShareUser shareUser].token];
        NSMutableArray *params = [NSMutableArray arrayWithCapacity:1];
        NSDictionary *dic = @{@"causationtypeNo":self.causation.causationtypeNo,@"exchangeId":self.causation.exchangeId,@"rejectReason":@"",@"status":self.causation.status};
        [params addObject:dic];
        [[MPMSessionManager shareManager] postRequestWithURL:url params:params loadingMessage:@"正在操作" success:^(id response) {
            // 跳回上一个页面
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *error) {
            DLog(@"%@",error);
        }];
    } else if ([title isEqualToString:@"驳回"]) {
        // 驳回操作，status传4，可参考constants.js文件中的APPLYTYPECONFIG
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入驳回理由" message:nil preferredStyle:UIAlertControllerStyleAlert];
        __weak typeof (UIAlertController *) weakAlert = alertController;
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakAlert dismissViewControllerAnimated:YES completion:nil];
            NSString *url = [NSString stringWithFormat:@"%@exceptionBatch/exceptionBatchApprove?status=%@&employeeId=%@&token=%@",MPMHost,@"4",[MPMShareUser shareUser].employeeId,[MPMShareUser shareUser].token];
            NSMutableArray *params = [NSMutableArray arrayWithCapacity:1];
            NSDictionary *dic = @{@"causationtypeNo":self.causation.causationtypeNo,@"exchangeId":self.causation.exchangeId,@"rejectReason":kSafeString(self.causation.rejectReason),@"status":self.causation.status};
            [params addObject:dic];
            [[MPMSessionManager shareManager] postRequestWithURL:url params:params loadingMessage:@"正在操作" success:^(id response) {
                // 跳回上一个页面
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString *error) {
                DLog(@"%@",error);
            }];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [weakAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        [weakAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.delegate = self;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }];
        [weakAlert addAction:cancelAction];
        [weakAlert addAction:sure];
        [self presentViewController:weakAlert animated:YES completion:nil];
    }
}

// 限制驳回理由输入框字数50个以内
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *toBeString = [textField.text stringByAppendingString:string];
    if (toBeString.length > 50) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    self.causation.rejectReason = textField.text;
    return YES;
}

#pragma mark - UITabelViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewCellMessage.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.contentTableHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MPMApprovalProcessDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApprovalDetailCell" forIndexPath:indexPath];
    NSDictionary *dic = self.tableViewCellMessage[indexPath.row];
    cell.detailTitleLabel.text = dic[@"type"];
    cell.detailMessageIcon.image = ImageName(dic[@"image"]);
    cell.detailMessageName.text = dic[@"name"];
    cell.detailMessageTime.text = dic[@"date"];
    cell.detailMessageDetailText.text = dic[@"message"];
    if (indexPath.row == 0) {
        if ([dic[@"message"] containsString:@"待处理"]) {
            cell.detailMessageDetailText.textColor = kMainBlueColor;
        } else if ([dic[@"message"] containsString:@"已通过"]) {
            cell.detailMessageDetailText.textColor = kRGBA(160, 202, 78, 1);
        } else {
            cell.detailMessageDetailText.textColor = kRedColor;
        }
    } else {
        cell.detailMessageDetailText.textColor = kMainLightGray;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Lazy Init
// header
#define kShadowOffset 1
- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
        _headerView.backgroundColor = kWhiteColor;
        _headerView.layer.shadowColor = kMainBlueColor.CGColor;
        _headerView.layer.shadowOffset = CGSizeZero;
        _headerView.layer.shadowRadius = 3;
        _headerView.layer.shadowOpacity = 1.0;
        _headerView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 70-kShadowOffset/2, kScreenWidth, kShadowOffset)].CGPath;
    }
    return _headerView;
}

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.image = ImageName(@"approval_useravatar_big");
    }
    return _headerImageView;
}

- (UILabel *)headerName {
    if (!_headerName) {
        _headerName = [[UILabel alloc] init];
        _headerName.text = @"迪丽热巴";
        [_headerName sizeToFit];
        _headerName.font = SystemFont(17);
    }
    return _headerName;
}

- (UILabel *)headerDepartment {
    if (!_headerDepartment) {
        _headerDepartment = [[UILabel alloc] init];
        _headerDepartment.text = @"技术开发部";
        _headerDepartment.textColor = kMainBlueColor;
        _headerDepartment.font = SystemFont(15);
    }
    return _headerDepartment;
}
// middle
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = kTableViewBGColor;
    }
    return _scrollView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = kTableViewBGColor;
    }
    return _containerView;
}

// reason
- (UIView *)contentReasonView {
    if (!_contentReasonView) {
        _contentReasonView = [[UIView alloc] init];
        [_contentReasonView sizeToFit];
        _contentReasonView.backgroundColor = kWhiteColor;
    }
    return _contentReasonView;
}
- (UILabel *)contentReasonBeginTimeLabel {
    if (!_contentReasonBeginTimeLabel) {
        _contentReasonBeginTimeLabel = [[UILabel alloc] init];
        _contentReasonBeginTimeLabel.text = @"申请原因:";
        [_contentReasonBeginTimeLabel sizeToFit];
        _contentReasonBeginTimeLabel.textColor = kMainLightGray;
        _contentReasonBeginTimeLabel.textAlignment = NSTextAlignmentRight;
        _contentReasonBeginTimeLabel.font = SystemFont(15);
    }
    return _contentReasonBeginTimeLabel;
}
- (UILabel *)contentReasonBeginTimeMessage {
    if (!_contentReasonBeginTimeMessage) {
        _contentReasonBeginTimeMessage = [[UILabel alloc] init];
        _contentReasonBeginTimeMessage.numberOfLines = 0;
        [_contentReasonBeginTimeMessage sizeToFit];
        [_contentReasonBeginTimeMessage setAttributedString:@"去参加阿里巴巴管理会议，了解积分制管理。" font:SystemFont(15) lineSpace:2];
        _contentReasonBeginTimeMessage.font = SystemFont(15);
    }
    return _contentReasonBeginTimeMessage;
}
// TableView
- (UITableView *)contentTableView {
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        _contentTableView.backgroundColor = kTableViewBGColor;
        _contentTableView.contentInset = UIEdgeInsetsMake(0, 0, 5, 0);
        [_contentTableView registerClass:[MPMApprovalProcessDetailTableViewCell class] forCellReuseIdentifier:@"ApprovalDetailCell"];
        _contentTableView.tableFooterView = [[UIView alloc] init];
        _contentTableView.layer.masksToBounds = YES;
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _contentTableView;
}

- (UILabel *)contentTableHeaderView {
    if (!_contentTableHeaderView) {
        _contentTableHeaderView = [[UILabel alloc] init];
        _contentTableHeaderView.text = @"  审核信息";
        _contentTableHeaderView.textColor = kMainLightGray;
        _contentTableHeaderView.font = SystemFont(14);
        _contentTableHeaderView.backgroundColor = kTableViewBGColor;
    }
    return _contentTableHeaderView;
}

// bottom
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = kSeperateColor;
    }
    return _bottomLine;
}

- (UIButton *)bottomLeftButton {
    if (!_bottomLeftButton) {
        _bottomLeftButton = [MPMButton titleButtonWithTitle:@"删除" nTitleColor:kMainBlueColor hTitleColor:kMainBlackColor nBGImage:ImageName(@"approval_but_default_reset") hImage:ImageName(@"approval_but_default_reset")];
        _bottomLeftButton.titleLabel.font = SystemFont(18);
    }
    return _bottomLeftButton;
}
- (UIButton *)bottomMiddleButton {
    if (!_bottomMiddleButton) {
        _bottomMiddleButton = [MPMButton titleButtonWithTitle:@"删除" nTitleColor:kMainBlueColor hTitleColor:kMainBlackColor nBGImage:ImageName(@"approval_but_default_reset") hImage:ImageName(@"approval_but_default_reset")];
        _bottomMiddleButton.titleLabel.font = SystemFont(18);
    }
    return _bottomMiddleButton;
}

- (UIButton *)bottomRightButton {
    if (!_bottomRightButton) {
        _bottomRightButton = [MPMButton titleButtonWithTitle:@"撤回" nTitleColor:kWhiteColor hTitleColor:kMainLightGray bgColor:kMainBlueColor];
        _bottomRightButton.layer.cornerRadius = 5;
        _bottomRightButton.titleLabel.font = SystemFont(18);
    }
    return _bottomRightButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
