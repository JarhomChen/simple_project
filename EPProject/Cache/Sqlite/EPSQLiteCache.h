//
//  MGSQLiteCache.h
//
//  Created by Jarhom on 16/2/13.
//  Copyright © 2016年 Jarhom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

#define kDefaultDBName @"epweike.sqlite"

@interface EPSQLiteCache : NSObject


@property (nonatomic,strong) FMDatabaseQueue *dbQueue;



- (NSString *)getDbFolderPath;

//
- (NSString *)getDBFullPath;


/**
 *  关闭数据库
 */
- (void)close;



@end
