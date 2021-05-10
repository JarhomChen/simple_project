//
//  MGSQLiteCache.m
//
//  Created by Jarhom on 16/2/13.
//  Copyright © 2016年 Jarhom. All rights reserved.
//

#import "EPSQLiteCache.h"
#import "EPCacheDirectory.h"



@implementation EPSQLiteCache

-(NSString *)getDbFolderPath{
    // 存放sqlite目录
    NSString *sqliteFolder = [EPCacheDirectory SQLiteDocumentPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:sqliteFolder]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:sqliteFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return sqliteFolder;
}

- (NSString *)getDBFullPath {
    NSString *folder = [self getDbFolderPath];
    NSString *fullPath = [folder stringByAppendingPathComponent:kDefaultDBName];
    
    return fullPath;
}


//获取数据库执行队列
-(FMDatabaseQueue *)dbQueue{
    if (!_dbQueue) {
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:[self getDBFullPath]];
    }
    return _dbQueue;
}



//关闭数据库
-(void)close{
    
    [_dbQueue close];
    
}

-(void)dealloc{
    [self close];
}


@end
