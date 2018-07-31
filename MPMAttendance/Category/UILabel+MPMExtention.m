//
//  UILabel+MPMExtention.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/7/16.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "UILabel+MPMExtention.h"

@implementation UILabel (MPMExtention)

- (void)setAttributedString:(NSString *)string font:(UIFont *)font lineSpace:(CGFloat)lineSpace {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    NSDictionary *attrDict = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:string attributes:attrDict];
    self.attributedText = attrStr;
}

@end
