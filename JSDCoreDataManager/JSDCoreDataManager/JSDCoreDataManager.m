//
//  JSDCoreDataManager.m
//  JSDCoreDataManager
//
//  Created by Abner on 2017/8/31.
//  Copyright © 2017年 姜守栋. All rights reserved.
//

#import "JSDCoreDataManager.h"
static JSDCoreDataManager *instance;
static NSString * const dbName = @"jsd.db";
@implementation JSDCoreDataManager
+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [JSDCoreDataManager new];
    });
    return instance;
}
@synthesize moc = _moc;

- (NSManagedObjectContext *)moc{
    //实例化管理上下文
    _moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    //实例化管理对象模型
    NSManagedObjectModel *mom = [NSManagedObjectModel mergedModelFromBundles:nil];
    //实例化持久化存储调度器
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    //让psc跟数据库建立联系
    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString *path = [cacheDir stringByAppendingString:dbName];
    NSURL *url = [NSURL fileURLWithPath:path];
    //数据迁移策略
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption:@(YES),
                              NSInferMappingModelAutomaticallyOption:@(YES)
                              };
    [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:options error:NULL];
    //给管理上下文指定持久化存储调度器
    _moc.persistentStoreCoordinator = psc;
    return _moc;
}
- (void)saveContext{
    
}
@end
