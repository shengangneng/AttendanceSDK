//
//  MPMCoreDataManager.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/14.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMCoreDataManager.h"
#import "MPMAttendanceHeader.h"

static MPMCoreDataManager *coreDataManager;
@interface MPMCoreDataManager ()

@property (nonatomic, strong) NSManagedObjectModel *model;
@property (nonatomic, strong) NSPersistentStoreCoordinator *coordinator;

@end

@implementation MPMCoreDataManager

#pragma mark - Public Method
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coreDataManager = [[MPMCoreDataManager alloc] init];
    });
    return coreDataManager;
}

- (void)saveToMainContext {
    NSError *error;
    if ([self.mainManagedObjectContext hasChanges]) {
        [self.mainManagedObjectContext save:&error];
        if (error) {
            DLog(@"%@",error.localizedDescription);
        }
    }
}

- (void)saveToBackContext {
    NSError *error;
    if ([self.backManagedObjectContext hasChanges]) {
        [self.backManagedObjectContext save:&error];
        if (error) {
            DLog(@"%@",error.localizedDescription);
        }
    }
}

#pragma mark - Lazy Init
- (NSManagedObjectContext *)mainManagedObjectContext {
    if (!_mainManagedObjectContext) {
        _mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainManagedObjectContext.persistentStoreCoordinator = self.coordinator;
    }
    return _mainManagedObjectContext;
}

- (NSManagedObjectContext *)backManagedObjectContext {
    if (!_backManagedObjectContext) {
        _backManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _backManagedObjectContext.persistentStoreCoordinator = self.coordinator;
    }
    return _backManagedObjectContext;
}

- (NSPersistentStoreCoordinator *)coordinator {
    if (!_coordinator) {
        NSError *error;
        NSString *saveURL = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        saveURL = [saveURL stringByAppendingFormat:@"/%@.sqlite",@"MPMAttendence"];
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
        [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:saveURL] options:nil error:&error];
        if (error) {
            DLog(@"%@",error.localizedDescription);
            // 更改了CoreData的xcdatamodeld里面的属性或者新增类时候，需要删掉原来的数据库再重新创建
            error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:saveURL error:&error];
            if (error) {
                DLog(@"%@",error.localizedDescription);
            } else {
                [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:saveURL] options:nil error:&error];
            }

        }
    }
    return _coordinator;
}

- (NSManagedObjectModel *)model {
    if (!_model) {
//        NSString *bundlepath = [[NSBundle mainBundle] pathForResource:@"MPMAttendance" ofType:@"framework"];
        NSBundle *realBundle = [NSBundle mainBundle];
        NSURL *modelURL = [NSURL URLWithString:[realBundle pathForResource:@"MPMAtendence" ofType:@"mom"]];
        _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _model;
}

@end
