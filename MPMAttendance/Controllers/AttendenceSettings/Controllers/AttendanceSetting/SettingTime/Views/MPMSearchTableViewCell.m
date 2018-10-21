//
//  MPMSearchTableViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/8/20.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMSearchTableViewCell.h"

@interface MPMSearchTableViewCell () <UISearchBarDelegate>

@end

@implementation MPMSearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.searchBar];
        [self.searchBar mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (self.searchWillEdtingBlock) {
        self.searchWillEdtingBlock();
    }
    return NO;
}

#pragma mark - Lazy Init
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"搜索班次";
        _searchBar.delegate = self;
        _searchBar.barTintColor = kClearColor;
        _searchBar.backgroundColor = kTableViewBGColor;
        _searchBar.backgroundImage = [[UIImage alloc] init];
    }
    return _searchBar;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
