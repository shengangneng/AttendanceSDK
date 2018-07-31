//
//  ColorConstant.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/13.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#ifndef ColorConstant_h
#define ColorConstant_h

/************************************************************************************************************************/
/***** 系统颜色 *****/
#define kBlackColor         [UIColor blackColor]
#define kDarkGrayColor      [UIColor darkGrayColor]
#define kLightGrayColor     [UIColor lightGrayColor]
#define kWhiteColor         [UIColor whiteColor]
#define kGrayColor          [UIColor grayColor]
#define kRedColor           [UIColor redColor]
#define kGreenColor         [UIColor greenColor]
#define kBlueColor          [UIColor blueColor]
#define kCyanColor          [UIColor cyanColor]
#define kYellowColor        [UIColor yellowColor]
#define kMagentaColor       [UIColor magentaColor]
#define kOrangeColor        [UIColor orangeColor]
#define kPurpleColor        [UIColor purpleColor]
#define kBrownColor         [UIColor brownColor]
#define kClearColor         [UIColor clearColor]

/************************************************************************************************************************/
/***** 系统颜色 *****/
#define kColorRange 255.0
#define kRGBA(r, g, b, a)           [UIColor colorWithRed:r/kColorRange green:g/kColorRange blue:b/kColorRange alpha:a]
#define kRandomColorOfAlpha(a)      [UIColor colorWithRed:(arc4random()%255)/kColorRange green:(arc4random()%255)/kColorRange blue:(arc4random()%255)/kColorRange alpha:a]
#define kRGBColorHEX(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/kColorRange green:((float)((rgbValue & 0xFF00) >> 8))/kColorRange blue:((float)(rgbValue & 0xFF))/kColorRange alpha:1.0]

#define kBorderLineColor    kLightGrayColor
#define kLightBlueColor     kRGBA(97, 177, 250, 1)
#define kBasicBlueColor     kRGBA(81, 146, 213, 1)
#define kBackgroundAlpha    kRGBA(164, 158, 163, 0.38)
// 三种主颜色
#define kMainBlueColor      kRGBA(60, 143, 232, 1)
#define kMainLightGray      kRGBA(161, 161, 161, 1)
#define kLoginLightGray     kRGBA(186, 186, 186, 1)
#define kMainBlackColor     kRGBA(40, 40, 40, 1)
#define kMainTextFontColor  kRGBA(102, 102, 102, 1)
// 灰色分割色
#define kSeperateColor      kRGBA(241, 241, 241, 1)
#define kTableViewBGColor   kRGBA(245, 245, 249, 1)


#endif /* ColorConstant_h */
