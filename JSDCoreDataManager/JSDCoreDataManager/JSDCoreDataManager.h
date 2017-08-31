//
//  JSDCoreDataManager.h
//  JSDCoreDataManager
//
//  Created by Abner on 2017/8/31.
//  Copyright © 2017年 姜守栋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface JSDCoreDataManager : NSObject

+ (instancetype)sharedManager;

/**
 管理对象上下文
 */
@property (readonly, strong) NSManagedObjectContext *moc;

/**
 保存上下文
 */
- (void)saveContext;
@end
