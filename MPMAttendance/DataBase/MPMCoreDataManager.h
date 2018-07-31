//
//  MPMCoreDataManager.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/14.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MPMCoreDataManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *mainManagedObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *backManagedObjectContext;

+ (instancetype)shareManager;

- (void)saveToMainContext;
- (void)saveToBackContext;

@end
