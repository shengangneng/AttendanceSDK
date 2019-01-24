//
//  MPMApprovalProcessDetailViewController.m
//  MPMAtendence
//  流程审批-信息详情
//  Created by gangneng shen on 2018/4/25.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMApprovalProcessDetailViewController.h"
#import "MPMButton.h"
#import "MPMApprovalProcessDetailTableViewCell.h"
#import "MPMShareUser.h"
#import "MPMSessionManager.h"
#import "NSDateFormatter+MPMExtention.h"
#import "MPMDetailTimeMessageView.h"
#import "MPMBaseDealingViewController.h"
#import "MPMDealingModel.h"
#import "MPMCausationDetailModel.h"
#import "UILabel+MPMExtention.h"
#import "MPMHTTPSessionManager.h"
#import "MPMOauthUser.h"
#import "MPMDealingBorderButton.h"
#import "MPMProcessDetailDeliversView.h"
#import "MPMProcessDetailApprovalNodeView.h"
#import "MPMApprovalProcessNodeDealingViewController.h"
#import "MPMProcessSettingCommomViewController.h"
#import "MPMTaskEditView.h"
#import "MPMRoundPeopleView.h"
#import "MPMCommomTool.h"
// model
#import "MPMProcessDef.h"
#import "MPMTaskInstGroups.h"
#import "MPMProcessInst.h"
#import "MPMProcessPeople.h"
#import "MPMProcessDetailList.h"
#import "MPMProcessTaskModel.h"

@interface MPMApprovalProcessDetailViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;         /** 所有的视图都加在scrollView上 */
// header
@property (nonatomic, strong) UIImageView *headerView;          /** 头部视图：头像、姓名、部门、审核状态 */
//@property (nonatomic, strong) UIImageView *headerImageView;     /** 头像 */
@property (nonatomic, strong) MPMRoundPeopleView *headerImage;  /** 头像 */
@property (nonatomic, strong) UILabel *headerNameDepartment;    /** 姓名和部门 */
@property (nonatomic, strong) UILabel *headerStatusLabel;       /** 审核状态 */
// 流程明细
@property (nonatomic, strong) UIView *detailView;               /** 明细视图：考勤时间、打卡时间、改卡时间等信息 */
// 申请原因
@property (nonatomic, strong) UIView *reasonView;               /** 申请原因视图 */
@property (nonatomic, strong) UILabel *reasonLabel;             /** 申请原因 */
@property (nonatomic, strong) UILabel *reasonDetailLabel;       /** 申请原因明细 */
// 审核信息
@property (nonatomic, strong) UIView *bottomApprovedNodeView;                   /** 审核节点 */
@property (nonatomic, strong) UILabel *bottomApprovedNodeTitleLabel;            /** 审核信息 */
@property (nonatomic, strong) MPMProcessDetailDeliversView *bottomDeliversView; /** 抄送人视图 */
// bottom操作按钮
@property (nonatomic, strong) UIButton *addSignButton;          /** 终审加签按钮：只有在最后一个 */
@property (nonatomic, strong) UIView *bottomView;               /** 底部操作按钮视图 */
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *bottomLeftButton;
@property (nonatomic, strong) UIButton *bottomMiddleButton;
@property (nonatomic, strong) UIButton *bottomRightButton;
// 终审加签弹出界面
@property (nonatomic, strong) MPMTaskEditView *taskView;        /** 终身加签弹出页面 */

// 2.0
@property (nonatomic, strong) MPMProcessMyMetterModel *model;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, copy) NSArray<MPMProcessPeople *> *delivers;          /** 抄送人 */
@property (nonatomic, strong) MPMProcessTaskConfig *config;                 /** 流程设置节点config */
@property (nonatomic, strong) MPMProcessDef *processDef;                    /** 终审加签配置 */
@property (nonatomic, strong) MPMProcessInst *processInst;
@property (nonatomic, copy) NSArray<MPMTaskInstGroups *> *taskInstGroups;   /** 具体审批节点详情 */
@property (nonatomic, copy) NSString *currentTaskInstCode;                  /** 当前审批节点code */
@property (nonatomic, copy) NSArray<MPMProcessTaskModel *> *taskDefs;       /** 流程设置里的所有节点 */
@property (nonatomic, copy) NSString *canAddSign;                           /** 是否可以终审加签：1是 0否 */

@property (nonatomic, strong) MPMProcessDetailList *processDetailList;      /** 申请详情信息 */
@property (nonatomic, assign) CausationType causationType;

@end

@implementation MPMApprovalProcessDetailViewController

- (instancetype)initWithModel:(MPMProcessMyMetterModel *)model selectedIndexPath:(NSIndexPath *)selectIndexPath {
    self = [super init];
    if (self) {
        self.selectIndexPath = selectIndexPath;
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"信息详情";
    self.view.backgroundColor = kWhiteColor;
    [self setLeftBarButtonWithTitle:@"返回" action:@selector(back:)];
    [self.addSignButton addTarget:self action:@selector(addSign:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomLeftButton addTarget:self action:@selector(left:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomMiddleButton addTarget:self action:@selector(middle:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomRightButton addTarget:self action:@selector(right:) forControlEvents:UIControlEventTouchUpInside];
    [self getData];
}

/**
 * 待办、已办：先api/wfinst/fullprocessinstbytid，参数为model中的id，然后再调用processDef中bizReqApi的地址拼接上processInst中的bizOrderId
 * 我的申请、抄送给我：先api/wfinst/fullprocessinstbypid，参数为processInstId，然类似。
 */
- (void)getData {
    NSString *url;
    if (0 == self.selectIndexPath.section) {
        // 待办、已办
        url = [NSString stringWithFormat:@"%@%@?taskInstId=%@",MPMINTERFACE_WORKFLOW,MPMINTERFACE_APPROVAL_DETAIL,self.model.mpm_id];
    } else if (3 == self.selectIndexPath.section) {
        // 打卡页面的改卡改签补卡进入详情
        url = [NSString stringWithFormat:@"%@%@?detailId=%@",MPMINTERFACE_HOST,MPMINTERFACE_SIGNIN_ISEXISTDETAIL,self.model.mpm_id];
    } else if (4 == self.selectIndexPath.section) {
        // 打卡页面的改卡补卡进入详情
        url = [NSString stringWithFormat:@"%@%@?bizOrderId=%@",MPMINTERFACE_WORKFLOW,MPMINTERFACE_APPROVAL_DETAIL_BIZ,self.model.mpm_id];
    } else {
        // 我的申请、抄送给我
        url = [NSString stringWithFormat:@"%@%@?processInstId=%@",MPMINTERFACE_WORKFLOW,MPMINTERFACE_APPROVAL_FULLPROCESS,self.model.mpm_id];
    }
    [[MPMSessionManager shareManager] getRequestWithURL:url setAuth:YES params:nil loadingMessage:@"正在加载" success:^(id response) {
        DLog(@"%@",response);
        if (response[kResponseObjectKey] && [response[kResponseObjectKey] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *object = response[kResponseObjectKey];
            self.canAddSign = kNumberSafeString(object[@"canAddSign"]);
            // processDef - 用于传递给终审加签
            if (object[@"processDef"] && [object[@"processDef"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *processDef = object[@"processDef"];
                self.processDef = [[MPMProcessDef alloc] initWithDictionary:processDef];
            }
            // processInst
            if (object[@"processInst"] && [object[@"processInst"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *processInst = object[@"processInst"];
                self.processInst = [[MPMProcessInst alloc] initWithDictionary:processInst];
            }
            // 当前节点的流程配置
            if (object[@"participantConfig"] && [object[@"participantConfig"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *participantConfig = object[@"participantConfig"];
                self.config = [[MPMProcessTaskConfig alloc] initWithDictionary:participantConfig];
            }
            
            // 设置是否可以加签：如果可以加签，并且没有加签过
            if (1 == self.canAddSign.integerValue && 0 == self.config.addsign.integerValue) {
                self.addSignButton.hidden = NO;
            } else {
                self.addSignButton.hidden = YES;
            }
            
            // taskInstGroups-具体审批节点
            if (object[@"taskInstGroups"] && [object[@"taskInstGroups"] isKindOfClass:[NSArray class]]) {
                NSArray *taskInstGroups = object[@"taskInstGroups"];
                NSMutableArray *tmpGroups = [NSMutableArray arrayWithCapacity:taskInstGroups.count];
                for (int i = 0; i < taskInstGroups.count; i++) {
                    NSDictionary *dic = taskInstGroups[i];
                    MPMTaskInstGroups *group = [[MPMTaskInstGroups alloc] init];
                    group.taskCode = dic[@"taskCode"];
                    group.taskName = dic[@"taskName"];
                    if (dic[@"taskInsts"] && [dic[@"taskInsts"] isKindOfClass:[NSArray class]]) {
                        NSArray *taskInsets = dic[@"taskInsts"];
                        NSMutableArray *tmpTks = [NSMutableArray arrayWithCapacity:taskInsets.count];
                        for (int j = 0; j < taskInsets.count; j++) {
                            MPMTaskInsts *tk = [[MPMTaskInsts alloc] initWithDictionary:taskInsets[j]];
                            [tmpTks addObject:tk];
                        }
                        group.taskInst = tmpTks;
                    }
                    [tmpGroups addObject:group];
                }
                self.taskInstGroups = tmpGroups.copy;
            }
            // taskDefs-流程设置节点
            if (object[@"taskDefs"] && [object[@"taskDefs"] isKindOfClass:[NSArray class]]) {
                NSArray *taskDefs = object[@"taskDefs"];
                NSMutableArray *temp = [NSMutableArray arrayWithCapacity:taskDefs.count];
                for (int i = 0; i < taskDefs.count; i++) {
                    NSDictionary *dic = taskDefs[i];
                    MPMProcessTaskModel *task = [[MPMProcessTaskModel alloc] initWithDictionary:dic];
                    if (dic[@"config"] && [dic[@"config"] isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *config = dic[@"config"];
                        MPMProcessTaskConfig *cf = [[MPMProcessTaskConfig alloc] initWithDictionary:config];
                        task.config = cf;
                    } else {
                        task.config = nil;
                    }
                    [temp addObject:task];
                }
                self.taskDefs = temp.copy;
            }
            
            if (self.processDef && !kIsNilString(self.processDef.bizReqApi) && self.processInst && !kIsNilString(self.processInst.bizOrderId)) {
                NSString *url = [NSString stringWithFormat:@"%@%@",self.processDef.bizReqApi,self.processInst.bizOrderId];
                [self getApplyListDataWithURL:url];
            }
        }
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
}

/** 获取申请详情列表信息 */
- (void)getApplyListDataWithURL:(NSString *)url {
    NSString *encodedUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [[MPMSessionManager shareManager] getRequestWithURL:encodedUrl setAuth:YES params:nil loadingMessage:nil success:^(id response) {
        DLog(@"%@",response);
        if (response[kResponseObjectKey] && [response[kResponseObjectKey] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *object = response[kResponseObjectKey];
            self.processDetailList = [[MPMProcessDetailList alloc] initWithDictionary:object];
            // 转换为审批类型
            self.causationType = ((NSString *)kGetCausationNumFromName[kException_GetNameFromNum[self.processDetailList.type]]).integerValue;
            NSArray *detailDtoListArray;
            if (object[@"kqBizLeaveDtoList"] && [object[@"kqBizLeaveDtoList"] isKindOfClass:[NSArray class]] && ((NSArray *)object[@"kqBizLeaveDtoList"]).count > 0) {
                // 请假
                detailDtoListArray = object[@"kqBizLeaveDtoList"];
            } else if (object[@"kqBizBusinessTravelDtoList"] && [object[@"kqBizBusinessTravelDtoList"] isKindOfClass:[NSArray class]] && ((NSArray *)object[@"kqBizBusinessTravelDtoList"]).count > 0) {
                // 出差
                detailDtoListArray = object[@"kqBizBusinessTravelDtoList"];
            } else if (object[@"otDetails"] && [object[@"otDetails"] isKindOfClass:[NSArray class]] && ((NSArray *)object[@"otDetails"]).count > 0) {
                // 加班
                detailDtoListArray = object[@"otDetails"];
            } else if (object[@"gooutDetails"] && [object[@"gooutDetails"] isKindOfClass:[NSArray class]] && ((NSArray *)object[@"gooutDetails"]).count > 0) {
                // 外出
                detailDtoListArray = object[@"gooutDetails"];
            } else if (object[@"kqBizReviseSignList"] && [object[@"kqBizReviseSignList"] isKindOfClass:[NSArray class]] && ((NSArray *)object[@"kqBizReviseSignList"]).count > 0) {
                // 改卡
                detailDtoListArray = object[@"kqBizReviseSignList"];
            } else if (object[@"kqBizFillupSignList"] && [object[@"kqBizFillupSignList"] isKindOfClass:[NSArray class]] && ((NSArray *)object[@"kqBizFillupSignList"]).count > 0) {
                // 补卡
                detailDtoListArray = object[@"kqBizFillupSignList"];
            }
            
            if (object[@"workFlow"] && [object[@"workFlow"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *workFlow = object[@"workFlow"];
                // 抄送人
                if (workFlow[@"delivers"] && [workFlow[@"delivers"] isKindOfClass:[NSArray class]]) {
                    NSArray *delivers = workFlow[@"delivers"];
                    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:delivers.count];
                    for (int j = 0; j < delivers.count; j++) {
                        NSDictionary *people = delivers[j];
                        MPMProcessPeople *po = [[MPMProcessPeople alloc] initWithDictionary:people];
                        [temp addObject:po];
                    }
                    self.delivers = temp.copy;
                }
            }
            
            if (detailDtoListArray.count > 0) {
                NSMutableArray *temp = [NSMutableArray arrayWithCapacity:detailDtoListArray.count];
                for (int i = 0; i < detailDtoListArray.count; i++) {
                    NSDictionary *dic = detailDtoListArray[i];
                    MPMDetailDtoList *list = [[MPMDetailDtoList alloc] initWithDictionary:dic];
                    [temp addObject:list];
                }
                self.processDetailList.detailDtoList = temp.copy;
            }
        }
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
        [MPMProgressHUD showErrorWithStatus:error];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#define kStateArray @[@"",@"待处理",@"已完成",@"已驳回"]
- (void)setupAttributes {
    [super setupAttributes];
    [self.reasonDetailLabel setAttributedString:kIsNilString(self.processDetailList.reason) ? @"无" : self.processDetailList.reason font:SystemFont(15) lineSpace:2];
    self.reasonLabel.text = [NSString stringWithFormat:@"%@原因",kGetCausationNameFromNum[[NSString stringWithFormat:@"%ld",self.causationType]] ? : @"申请"];
    self.headerImage.nameLabel.text = self.processDetailList.userName.length > 2 ? [self.processDetailList.userName substringWithRange:NSMakeRange(self.processDetailList.userName.length - 2, 2)] : self.processDetailList.userName;
    self.headerNameDepartment.text = [NSString stringWithFormat:@"%@（%@）",self.processDetailList.userName,self.processDetailList.departmentName];
    self.headerStatusLabel.text = [NSString stringWithFormat:@"状态 : %@",(self.processInst.state.integerValue > kStateArray.count - 1) ? @"待处理" : kStateArray[self.processInst.state.integerValue]];
    
}

- (void)setupSubViews {
    [super setupSubViews];
    
    [self.view addSubview:self.scrollView];
    // 申请明细
    [self.scrollView addSubview:self.detailView];
    // header
    [self.scrollView addSubview:self.headerView];
    [self.headerView addSubview:self.headerImage];
    [self.headerView addSubview:self.headerNameDepartment];
    [self.headerView addSubview:self.headerStatusLabel];
    // reason
    [self.scrollView addSubview:self.reasonView];
    [self.reasonView addSubview:self.reasonLabel];
    [self.reasonView addSubview:self.reasonDetailLabel];
    // bottom
    [self.scrollView addSubview:self.bottomApprovedNodeView];
    [self.bottomApprovedNodeView addSubview:self.bottomApprovedNodeTitleLabel];
    [self.scrollView addSubview:self.bottomDeliversView];
    // bottom操作按钮
    [self.scrollView addSubview:self.addSignButton];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomLine];
    [self.bottomView addSubview:self.bottomLeftButton];
    [self.bottomView addSubview:self.bottomMiddleButton];
    [self.bottomView addSubview:self.bottomRightButton];
}

- (void)setupConstraints {
    [super setupConstraints];
    
    [self.scrollView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mpm_top);
    }];
    // header
    [self.headerView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.scrollView);
        make.height.equalTo(@70);
    }];
    [self.headerImage mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.headerView.mpm_leading).offset(31);
        make.height.width.equalTo(@(50));
        make.centerY.equalTo(self.headerView.mpm_centerY);
    }];
    [self.headerNameDepartment mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.headerImage.mpm_trailing).offset(14);
        make.top.equalTo(self.headerImage.mpm_top);
        make.height.equalTo(@33);
    }];
    [self.headerStatusLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.headerImage.mpm_trailing).offset(14);
        make.bottom.equalTo(self.headerImage.mpm_bottom);
        make.height.equalTo(@22);
    }];
    // 申请明细
    MPMViewAttribute *lastAttribute = self.headerView.mpm_bottom;
    for (int i = 0; i < self.processDetailList.detailDtoList.count; i++) {
        // 请假的每一节都有处理类型，其他的都是只有第一段才有处理类型
        BOOL withTypeLabel = (kCausationTypeAskLeave == self.causationType) ? YES : (0 == i);
        MPMDetailTimeMessageView *messageView = [[MPMDetailTimeMessageView alloc] initWithCausationType:self.causationType withTypeLabel:withTypeLabel detailDto:self.processDetailList.detailDtoList[i]];
        [self.detailView addSubview:messageView];
        [messageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.trailing.equalTo(self.detailView);
            make.top.equalTo(lastAttribute).offset((0 == i) ? 0 : 8);
            make.bottom.equalTo(messageView.contentIntegralLabel.mpm_bottom).offset(8);
        }];
        lastAttribute = messageView.mpm_bottom;
    }
    
    [self.detailView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self.scrollView);
        make.top.equalTo(self.headerView.mpm_bottom).offset(8);
        make.bottom.equalTo(lastAttribute);
    }];
    
    // reason
    [self.reasonView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self.scrollView);
        make.width.equalTo(@(kScreenWidth));
        make.top.equalTo(self.detailView.mpm_bottom).offset(8);
        make.bottom.equalTo(self.reasonDetailLabel.mpm_bottom).offset(8);
    }];
    [self.reasonLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.reasonView.mpm_leading);
        make.top.equalTo(self.reasonView.mpm_top).offset(8);
        make.height.equalTo(@22);
        make.width.equalTo(@87);
    }];
    [self.reasonDetailLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.reasonLabel.mpm_trailing).offset(8);
        make.top.equalTo(self.reasonLabel.mpm_top).offset(2);
        make.trailing.equalTo(self.reasonView.mpm_trailing).offset(-8);
    }];
    
    // bottom
    [self.bottomApprovedNodeView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self.scrollView);
        make.top.equalTo(self.reasonView.mpm_bottom).offset(8);
        if (0 == self.delivers.count) {
            make.bottom.equalTo(self.scrollView.mpm_bottom).offset(-22);
        }
    }];
    [self.bottomApprovedNodeTitleLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.top.equalTo(self.bottomApprovedNodeView);
        make.width.equalTo(@87);
    }];
    
    __block UIView *lastView;
    MPMViewAttribute *lastAttributes = self.bottomApprovedNodeTitleLabel.mpm_bottom;
    // 具体审批节点
    for (int i = 0; i < self.taskInstGroups.count; i++) {
        MPMTaskInstGroups *group = self.taskInstGroups[i];
        MPMProcessDetailApprovalNodeView *nodeView = [[MPMProcessDetailApprovalNodeView alloc] initWithTaskGroup:group];
        if (0 == i) {
            nodeView.upLine.hidden = YES;
        }
        if (self.taskInstGroups.count - 1 == i) {
            nodeView.bottomLine.hidden = YES;
        }
        nodeView.titleLabel.text = group.taskName;
        [self.bottomApprovedNodeView addSubview:nodeView];
        [nodeView mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.trailing.equalTo(self.bottomApprovedNodeView);
            make.top.equalTo(lastAttributes);
            if (self.taskInstGroups.count - 1 == i) {
                make.bottom.equalTo(self.bottomApprovedNodeView.mpm_bottom);
                lastView = nodeView;
            }
        }];
        lastAttributes = nodeView.mpm_bottom;
    }
    
    // 设置抄送人视图
    if (self.delivers.count > 0) {
        self.bottomDeliversView.delivers = self.delivers;
        [self.bottomDeliversView mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.trailing.equalTo(self.scrollView);
            make.top.equalTo(lastView.mpm_bottom);
            make.height.equalTo(@76);
            make.bottom.equalTo(self.scrollView.mpm_bottom).offset(-30);
        }];
        lastView = self.bottomDeliversView;
    } else {
        [self.bottomDeliversView removeFromSuperview];
    }
    [self.addSignButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.bottom.equalTo(self.scrollView.mpm_bottom);
        make.trailing.equalTo(self.scrollView.mpm_trailing).offset(-12);
    }];
    if (0 == self.selectIndexPath.section && 0 == self.selectIndexPath.row) {
        // bottom操作按钮
        [self.bottomView mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.bottom.equalTo(self.view.mpm_bottom);
            make.leading.trailing.equalTo(self.view);
            make.height.equalTo(@(BottomViewHeight));
        }];
        
        [self.bottomLine mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.top.trailing.equalTo(self.bottomView);
            make.height.equalTo(@0.5);
        }];
        [self.bottomLeftButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.bottomView.mpm_leading).offset(12);
            make.top.equalTo(self.bottomView.mpm_top).offset(BottomViewTopMargin);
            make.bottom.equalTo(self.bottomView.mpm_bottom).offset(-BottomViewBottomMargin);
        }];
        [self.bottomRightButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.bottomMiddleButton.mpm_trailing).offset(12);
            make.trailing.equalTo(self.bottomView.mpm_trailing).offset(-12);
            make.width.equalTo(self.bottomLeftButton.mpm_width);
            make.top.equalTo(self.bottomView.mpm_top).offset(BottomViewTopMargin);
            make.bottom.equalTo(self.bottomView.mpm_bottom).offset(-BottomViewBottomMargin);
        }];
        if (![self.taskInstGroups.firstObject.taskCode isEqualToString:@"apply"]) {
            // 我的待办-待处理
            [self.bottomMiddleButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.leading.equalTo(self.bottomLeftButton.mpm_trailing).offset(12);
                make.width.equalTo(self.bottomLeftButton.mpm_width);
                make.top.equalTo(self.bottomView.mpm_top).offset(BottomViewTopMargin);
                make.bottom.equalTo(self.bottomView.mpm_bottom).offset(-BottomViewBottomMargin);
            }];
        } else {
            // 我的待办-已驳回
            [self.bottomMiddleButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.leading.equalTo(self.bottomLeftButton.mpm_trailing);
                make.width.equalTo(@0);
                make.top.equalTo(self.bottomView.mpm_top).offset(BottomViewTopMargin);
                make.bottom.equalTo(self.bottomView.mpm_bottom).offset(-BottomViewBottomMargin);
            }];
            [self.bottomLeftButton setTitle:@"取消申请" forState:UIControlStateNormal];
            [self.bottomLeftButton setTitle:@"取消申请" forState:UIControlStateHighlighted];
            [self.bottomLeftButton setTitle:@"取消申请" forState:UIControlStateSelected];
            [self.bottomRightButton setTitle:@"编辑" forState:UIControlStateNormal];
            [self.bottomRightButton setTitle:@"编辑" forState:UIControlStateHighlighted];
            [self.bottomRightButton setTitle:@"编辑" forState:UIControlStateSelected];
        }
    } else {
        [self.bottomView mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.bottom.equalTo(self.view.mpm_bottom);
            make.leading.trailing.equalTo(self.view);
            make.height.equalTo(@(0));
        }];
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

/** 终审加签之后，修改审批节点视图 */
- (void)updateViewAfterAddSignModel:(MPMProcessTaskModel *)model {
    MPMTaskInstGroups *lastGroup = self.taskInstGroups.firstObject;
    NSMutableArray *addTaskInst = [NSMutableArray arrayWithCapacity:lastGroup.taskInst.count + model.config.participants.count];
    for (int i = 0; i < model.config.participants.count; i++) {
        MPMProcessPeople *peo = model.config.participants[i];
        MPMTaskInsts *addSignInst = [[MPMTaskInsts alloc] init];
        addSignInst.userId = peo.userId;
        addSignInst.username = peo.userName;
        [addTaskInst addObject:addSignInst];
    }
    for (int i = 0; i < lastGroup.taskInst.count; i++) {
        [addTaskInst addObject:lastGroup.taskInst[i]];
    }
    self.taskInstGroups.firstObject.taskInst = addTaskInst.copy;
    
    // 具体审批节点
    
    for (UIView *sub in self.bottomApprovedNodeView.subviews) {
        if ([sub isKindOfClass:[MPMProcessDetailApprovalNodeView class]]) {
            [sub removeFromSuperview];
        }
    }
    
    __block UIView *lastView;
    MPMViewAttribute *lastAttributes = self.bottomApprovedNodeTitleLabel.mpm_bottom;
    for (int i = 0; i < self.taskInstGroups.count; i++) {
        MPMTaskInstGroups *group = self.taskInstGroups[i];
        MPMProcessDetailApprovalNodeView *nodeView = [[MPMProcessDetailApprovalNodeView alloc] initWithTaskGroup:group];
        if (0 == i) {
            nodeView.upLine.hidden = YES;
        }
        if (self.taskInstGroups.count - 1 == i) {
            nodeView.bottomLine.hidden = YES;
        }
        nodeView.titleLabel.text = group.taskName;
        [self.bottomApprovedNodeView addSubview:nodeView];
        [nodeView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
            make.leading.trailing.equalTo(self.bottomApprovedNodeView);
            make.top.equalTo(lastAttributes);
            if (self.taskInstGroups.count - 1 == i) {
                make.bottom.equalTo(self.bottomApprovedNodeView.mpm_bottom);
                lastView = nodeView;
            }
        }];
        lastAttributes = nodeView.mpm_bottom;
    }
    // 设置抄送人视图
    if (self.delivers.count > 0) {
        self.bottomDeliversView.delivers = self.delivers;
        [self.bottomDeliversView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
            make.leading.trailing.equalTo(self.scrollView);
            make.top.equalTo(lastView.mpm_bottom);
            make.height.equalTo(@76);
            make.bottom.equalTo(self.scrollView.mpm_bottom).offset(-30);
        }];
        lastView = self.bottomDeliversView;
    }
    
    [self.bottomView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
        make.bottom.equalTo(self.view.mpm_bottom);
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(BottomViewHeight));
    }];
    self.canAddSign = @"0";
    self.addSignButton.hidden = YES;
    
    [self.view layoutIfNeeded];
}

#pragma mark - Target Action
- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)left:(UIButton *)sender {
    if (![self.taskInstGroups.firstObject.taskCode isEqualToString:@"apply"]) {
        // 我的待办-待处理-驳回
        MPMApprovalProcessNodeDealingViewController *nodeVC = [[MPMApprovalProcessNodeDealingViewController alloc] initWithDealingNodeType:kDetailNodeDealingTypeReject taskInstId:self.model.mpm_id model:self.model];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nodeVC animated:YES];
    } else {
        // 我的待办-已驳回-取消申请
        __weak typeof(self) weakself = self;
        [self showAlertControllerToLogoutWithMessage:@"确定取消申请吗？" sureAction:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakself) strongself = weakself;
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            NSString *url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_WORKFLOW,MPMINTERFACE_APPROVAL_COMPLETETASK];
            params[@"route"] = @"2";
            params[@"taskInstId"] = strongself.model.mpm_id;
            [[MPMSessionManager shareManager] postRequestWithURL:url setAuth:YES params:params loadingMessage:@"正在操作" success:^(id response) {
                DLog(@"%@",response);
                if (response && kRequestSuccess == ((NSString *)response[kResponseDataKey][kCode]).integerValue) {
                    // 请求成功 - 往回跳两个控制器回到流程审批主页
                    [strongself showAlertControllerToLogoutWithMessage:@"取消申请成功" sureAction:^(UIAlertAction * _Nonnull action) {
                        __strong typeof(strongself) sstrongself = strongself;
                        [sstrongself.navigationController popViewControllerAnimated:YES];
                    } needCancleButton:NO];
                } else {
                    [strongself showAlertControllerToLogoutWithMessage:@"取消申请失败" sureAction:nil needCancleButton:NO];
                }
            } failure:^(NSString *error) {
                DLog(@"%@",error);
                [MPMProgressHUD showErrorWithStatus:@"取消申请失败"];
            }];
        } needCancleButton:YES];
    }
}

- (void)middle:(UIButton *)sender {
    if (![self.taskInstGroups.firstObject.taskCode isEqualToString:@"apply"]) {
        // 我的待办-待处理-转交
        MPMApprovalProcessNodeDealingViewController *nodeVC = [[MPMApprovalProcessNodeDealingViewController alloc] initWithDealingNodeType:kDetailNodeDealingTypeTransToOthers taskInstId:self.model.mpm_id model:self.model];
        nodeVC.config = self.config;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nodeVC animated:YES];
    }
}

- (void)right:(UIButton *)sender {
    if (![self.taskInstGroups.firstObject.taskCode isEqualToString:@"apply"]) {
        // 我的待办-待处理-通过
        MPMApprovalProcessNodeDealingViewController *nodeVC = [[MPMApprovalProcessNodeDealingViewController alloc] initWithDealingNodeType:kDetailNodeDealingTypePass taskInstId:self.model.mpm_id model:self.model];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nodeVC animated:YES];
    } else {
        // 我的待办-驳回-编辑
        if (kProcessDefCode_GetTypeFromCode[self.model.processDefCode]) {
            CausationType dealingType = ((NSString *)kProcessDefCode_GetTypeFromCode[self.model.processDefCode]).integerValue;
            MPMBaseDealingViewController *dealingVC = [[MPMBaseDealingViewController alloc] initWithDealType:dealingType dealingModel:nil dealingFromType:kDealingFromTypeEditing bizorderId:self.processInst.bizOrderId taskInstId:self.model.mpm_id fastCalculate:kFastCalculateTypeNone];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:dealingVC animated:YES];
        }
    }
}

- (void)addSign:(UIButton *)sender {
    self.processDef.currentTaskCode = self.processInst.currentTaskCode;
    MPMProcessTaskModel *tm = [[MPMProcessTaskModel alloc] init];
    tm.name = self.taskInstGroups.firstObject.taskName;
    tm.limitParticipants = self.config.participants;
    tm.limitAlertMessage = @"你选择的人已在节点中";
    self.taskView.taskContentView.nameTextField.enabled = NO;
    __weak typeof(self) weakself = self;
    [self.taskView showWithModel:tm destinyVC:self completeBlock:^(MPMProcessTaskModel *taskModel) {
        __weak typeof(weakself) strongself = weakself;
        if (kIsNilString(taskModel.name)) {
            [strongself showAlertControllerToLogoutWithMessage:@"请输入节点名称" sureAction:nil needCancleButton:NO];
            return;
        }
        if (0 == taskModel.config.participants.count) {
            [strongself showAlertControllerToLogoutWithMessage:@"请添加审批人" sureAction:nil needCancleButton:NO];
            return;
        }
        // 调用终审加签接口
        NSString *url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_WORKFLOW,MPMINTERFACE_APPROVAL_ADDSIGN];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSMutableDictionary *participantConfig = [NSMutableDictionary dictionary];
        participantConfig[@"addsign"] = kSafeString(strongself.config.addsign);
        participantConfig[@"decision"] = kSafeString(strongself.config.decision);
        participantConfig[@"groupId"] = kSafeString(strongself.config.groupId);
        NSMutableArray *participants = [NSMutableArray arrayWithCapacity:taskModel.config.participants.count];
        for (int i = 0 ; i < taskModel.config.participants.count; i++) {
            MPMProcessPeople *people = taskModel.config.participants[i];
            [participants addObject:@{@"userId":people.userId,@"userName":people.userName}];
        }
        participantConfig[@"participants"] = participants;
        params[@"participantConfig"] = participantConfig;
        params[@"taskInstId"] = strongself.model.mpm_id;
        [[MPMSessionManager shareManager] postRequestWithURL:url setAuth:YES params:params loadingMessage:nil success:^(id response) {
            __weak typeof(strongself) wwself = strongself;
            if (kRequestSuccess == ((NSString *)response[kResponseDataKey][kCode]).integerValue) {
                [strongself showAlertControllerToLogoutWithMessage:@"加签成功" sureAction:^(UIAlertAction * _Nonnull action) {
                    __weak typeof(wwself) sself = wwself;
                    [sself.taskView dismiss];
                    [sself updateViewAfterAddSignModel:taskModel];
                } needCancleButton:NO];
            } else {
                [strongself showAlertControllerToLogoutWithMessage:@"加签失败" sureAction:nil needCancleButton:NO];
            }
        } failure:^(NSString *error) {
            [MPMProgressHUD showErrorWithStatus:@"加签失败"];
        }];
    }];
}

// 限制驳回理由输入框字数50个以内
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([MPMCommomTool textViewOrTextFieldHasEmoji:textField]) {
        return NO;
    }
    NSString *toBeString = [textField.text stringByAppendingString:string];
    if (toBeString.length > 50) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

#pragma mark - Lazy Init

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = kTableViewBGColor;
    }
    return _scrollView;
}
// header
#define kShadowOffset 0.5
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

- (MPMRoundPeopleView *)headerImage {
    if (!_headerImage) {
        _headerImage = [[MPMRoundPeopleView alloc] initWithWidth:50];
        _headerImage.backgroundColor = kWhiteColor;
        _headerImage.nameLabel.font = SystemFont(18);
    }
    return _headerImage;
}

- (UILabel *)headerNameDepartment {
    if (!_headerNameDepartment) {
        _headerNameDepartment = [[UILabel alloc] init];
        _headerNameDepartment.text = @"迪丽热巴 技术部";
        [_headerNameDepartment sizeToFit];
        _headerNameDepartment.font = SystemFont(17);
    }
    return _headerNameDepartment;
}

- (UILabel *)headerStatusLabel {
    if (!_headerStatusLabel) {
        _headerStatusLabel = [[UILabel alloc] init];
        _headerStatusLabel.text = @"状态：已完成";
        _headerStatusLabel.textColor = kMainLightGray;
        _headerStatusLabel.font = SystemFont(15);
    }
    return _headerStatusLabel;
}

- (UIView *)detailView {
    if (!_detailView) {
        _detailView = [[UIView alloc] init];
        [_detailView sizeToFit];
        _detailView.backgroundColor = kTableViewBGColor;
    }
    return _detailView;
}

// reason
- (UIView *)reasonView {
    if (!_reasonView) {
        _reasonView = [[UIView alloc] init];
        [_reasonView sizeToFit];
        _reasonView.backgroundColor = kWhiteColor;
    }
    return _reasonView;
}
- (UILabel *)reasonLabel {
    if (!_reasonLabel) {
        _reasonLabel = [[UILabel alloc] init];
        _reasonLabel.text = @"申请原因";
        [_reasonLabel sizeToFit];
        _reasonLabel.textColor = kMainLightGray;
        _reasonLabel.textAlignment = NSTextAlignmentRight;
        _reasonLabel.font = SystemFont(15);
    }
    return _reasonLabel;
}
- (UILabel *)reasonDetailLabel {
    if (!_reasonDetailLabel) {
        _reasonDetailLabel = [[UILabel alloc] init];
        _reasonDetailLabel.textAlignment = NSTextAlignmentLeft;
        [_reasonDetailLabel sizeToFit];
        _reasonDetailLabel.numberOfLines = 0;
        _reasonDetailLabel.font = SystemFont(15);
    }
    return _reasonDetailLabel;
}

// bottom
- (UIView *)bottomApprovedNodeView {
    if (!_bottomApprovedNodeView) {
        _bottomApprovedNodeView = [[UIView alloc] init];
        _bottomApprovedNodeView.backgroundColor = kTableViewBGColor;
    }
    return _bottomApprovedNodeView;
}
- (UILabel *)bottomApprovedNodeTitleLabel {
    if (!_bottomApprovedNodeTitleLabel) {
        _bottomApprovedNodeTitleLabel = [[UILabel alloc] init];
        _bottomApprovedNodeTitleLabel.text = @"审核信息";
        _bottomApprovedNodeTitleLabel.textAlignment = NSTextAlignmentRight;
        _bottomApprovedNodeTitleLabel.textColor = kMainLightGray;
        _bottomApprovedNodeTitleLabel.font = SystemFont(15);
        [_bottomApprovedNodeTitleLabel sizeToFit];
    }
    return _bottomApprovedNodeTitleLabel;
}

- (MPMProcessDetailDeliversView *)bottomDeliversView {
    if (!_bottomDeliversView) {
        _bottomDeliversView = [[MPMProcessDetailDeliversView alloc] init];
        _bottomDeliversView.backgroundColor = kTableViewBGColor;
    }
    return _bottomDeliversView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = kWhiteColor;
    }
    return _bottomView;
}

- (UIButton *)addSignButton {
    if (!_addSignButton) {
        _addSignButton = [MPMButton titleButtonWithTitle:@"+终审加签" nTitleColor:kMainBlueColor hTitleColor:kMainBlueColor bgColor:kTableViewBGColor];
        _addSignButton.titleLabel.font = SystemFont(15);
        [_addSignButton sizeToFit];
        _addSignButton.hidden = YES;
    }
    return _addSignButton;
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
        _bottomLeftButton = [[MPMDealingBorderButton alloc] initWithTitle:@"驳回" nColor:kMainBlueColor sColor:kMainLightGray font:SystemFont(18) cornerRadius:5 borderWidth:1];
        _bottomLeftButton.titleLabel.font = SystemFont(18);
    }
    return _bottomLeftButton;
}
- (UIButton *)bottomMiddleButton {
    if (!_bottomMiddleButton) {
        _bottomMiddleButton = [[MPMDealingBorderButton alloc] initWithTitle:@"转交" nColor:kMainBlueColor sColor:kMainLightGray font:SystemFont(18) cornerRadius:5 borderWidth:1];
        _bottomMiddleButton.titleLabel.font = SystemFont(18);
    }
    return _bottomMiddleButton;
}

- (UIButton *)bottomRightButton {
    if (!_bottomRightButton) {
        _bottomRightButton = [MPMButton titleButtonWithTitle:@"通过" nTitleColor:kWhiteColor hTitleColor:kMainLightGray bgColor:kMainBlueColor];
        _bottomRightButton.layer.cornerRadius = 5;
        _bottomRightButton.titleLabel.font = SystemFont(18);
    }
    return _bottomRightButton;
}

- (MPMTaskEditView *)taskView {
    if (!_taskView) {
        _taskView = [[MPMTaskEditView alloc] initWithFrame:self.view.bounds];
    }
    return _taskView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
