//
//  MPMTaskApplyersScrollView.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/8/28.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMTaskApplyersScrollView.h"
#import "MPMButton.h"
#import "MPMProcessPeople.h"
#import "MPMRoundPeopleButton.h"

#define kButtonTag 666

@implementation MPMTaskApplyersScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setParticipants:(NSArray *)participants {
    [self layoutWithParticipants:participants];
    _participants = participants;
}

#pragma mark - Target Action
- (void)deletePeople:(UIButton *)sender {
    NSInteger index = sender.tag - kButtonTag;
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:self.participants.count];
    for (int i = 0; i < self.participants.count; i++) {
        if (index == i) {
            continue;
        }
        [temp addObject:self.participants[i]];
    }
    self.participants = temp.copy;
    if (self.delegate && [self.delegate respondsToSelector:@selector(taskApplyersDidDeleteParticipants:)]) {
        [self.delegate taskApplyersDidDeleteParticipants:self.participants];
    }
}

- (void)layoutWithParticipants:(NSArray *)participants {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MPMRoundPeopleButton class]]) {
            [obj removeFromSuperview];
        }
    }];
    
    int count = 5;
    int width = 50;
    int heigth = 50;
    int margin = ((kScreenWidth - 40) - width * count) / (count + 1);
    int bord = 6.5;
    for (int i = 0; i < participants.count; i++) {
        MPMProcessPeople *peo = participants[i];
        MPMRoundPeopleButton *btn = [[MPMRoundPeopleButton alloc] init];
        btn.deleteIcon.hidden = NO;
        btn.nameLabel.text = peo.userName;
        btn.roundPeople.nameLabel.text = peo.userName.length > 2 ? [peo.userName substringWithRange:NSMakeRange(peo.userName.length - 2, 2)] : peo.userName;
        btn.tag = i + kButtonTag;
        [btn addTarget:self action:@selector(deletePeople:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(margin + i*(margin+width), bord, width, heigth);
        [self addSubview:btn];
    }
    self.contentSize = CGSizeMake(participants.count * (width + margin) + margin, heigth);
}

@end
