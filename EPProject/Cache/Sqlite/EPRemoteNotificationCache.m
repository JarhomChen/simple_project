//
//  JPRemoteNotificationCache.m
//  LBGoods
//
//  Created by jarhom on 2017/11/13.
//  Copyright © 2017年 厦门一品威客. All rights reserved.
//

#import "EPRemoteNotificationCache.h"

#define DB_TABLENAME_RemoteNotification @"RemoteNotification"


@implementation EPRemoteNotificationCache

- (id)init
{
    self = [super init];
    if (self) {
        //数据库的操作全部必须使用FMDatabaseQueue队列来执行事务，这样能确保线程安全
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            //判断数据表是否已建立
            if (![db tableExists:DB_TABLENAME_RemoteNotification]) {
                //读取Sqls目录下的.sql文件来建立数据表
                NSString *path = [[NSBundle mainBundle] pathForResource:DB_TABLENAME_RemoteNotification ofType:@"sql"];
                
                NSError *err = nil;
                NSString *sql = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
                
                if (sql) {
                    //执行sql语句
                    if ([db executeStatements:sql]) {
                        DLog(@"创建成功!");
                    }
                }
            }
        }];
    }
    return self;
}

//插入数据
- (void)insertNotificationObject:(id )notification
                        complete:(void(^)(BOOL isOK))completeBlock {
//    if (notification.type != TyMessageType_System) {
//        if (completeBlock)  completeBlock (NO);
//        return;
//    }
//
//    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//
//        NSString *sql = [NSString stringWithFormat:@"REPLACE INTO %@ (`msgId`,`userId`,`type`,`dateTime`,`title`,`content`,`url`) VALUES ('%@','%@',%ld,%ld,'%@','%@','%@');",
//                         DB_TABLENAME_RemoteNotification,
//                         notification.msgId,
//                         [JPClient shareInstance].userCode? :@"0",
//                         (long)notification.type,
//                         notification.dateTime,
//                         notification.title,
//                         notification.content,
//                         notification.url];
//
//        BOOL isSuccess = [db executeUpdate:sql];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (completeBlock) completeBlock(isSuccess);
//        });
//
//    }];
}

//清空数据
- (void)deleteNotificationObjectsByType:(NSInteger)type
                               complete:(void(^)(BOOL isOK))completeBlock {

//    NSString *sql = nil;
//
//    if (type == TyMessageType_None) {
//        sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE userId ='%@';",DB_TABLENAME_RemoteNotification,[JPClient shareInstance].userCode? :@"0"];
//    } else {
//        sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE type=%ld AND userId ='%@';",DB_TABLENAME_RemoteNotification,(long)type,[JPClient shareInstance].userCode? :@"0"];
//    }
//
//    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        BOOL isSuccess = [db executeUpdate:sql];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (completeBlock) completeBlock(isSuccess);
//        });
//    }];
}

//删除消息
- (void)deleteNotificationWithMsgId:(NSString *)msgId
                           complete:(void(^)(BOOL isOK))completeBlock {
//    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE msgId ='%@' AND userId ='%@';",DB_TABLENAME_RemoteNotification,msgId,[JPClient shareInstance].userCode? :@"0"];
//    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        BOOL isSuccess = [db executeUpdate:sql];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (completeBlock) completeBlock(isSuccess);
//        });
//    }];
}

//查询消息是否已经被读
-(void)searchNotificationWithMsgId:(NSString *)msgId complete:(void(^)(BOOL read))completeBlock{
//    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        NSInteger count = 0;
//        //统计
//        NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE msgId='%@' AND userId ='%@';",DB_TABLENAME_RemoteNotification,msgId,[JPClient shareInstance].userCode? :@"0"];
//        FMResultSet *s = [db executeQuery:sql];
//        if ([s next]) {
//            count = [s intForColumnIndex:0];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (completeBlock) completeBlock(count==0);
//        });
//    }];
}



//获取消息所有id
- (void)getUnReadNotificationIdsWithType:(NSInteger)type
                                complete:(void(^)(NSArray *ids))completeBlock {
    
//    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        //统计
//        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE type=%ld AND userId ='%@';",DB_TABLENAME_RemoteNotification,type,[JPClient shareInstance].userCode? :@"0"];
//        FMResultSet *s = [db executeQuery:sql];
//        NSMutableArray *tmp = [[NSMutableArray alloc] init];
//
//        while ([s next]) {
//            NSString *msgId = [s stringForColumn:@"msgId"];
//            [tmp addObject:msgId];
//        }
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (completeBlock) completeBlock(tmp);
//        });
//    }];
}


//获取消息类别最新消息和消息数
- (void)getUnReadNotificationWithType:(NSInteger)type
                             complete:(void(^)(NSInteger count))completeBlock {

//
//    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//
//        NSInteger count = 0;
//
//        //统计
//        NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE type=%ld AND userId ='%@';",DB_TABLENAME_RemoteNotification,(long)type,[EPClient shareInstance].userCode? :@"0"];
//
//
//        FMResultSet *s = [db executeQuery:sql];
//        if ([s next]) {
//            count = [s intForColumnIndex:0];
//        }
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (completeBlock) completeBlock(count);
//        });
//    }];
    
}


@end
