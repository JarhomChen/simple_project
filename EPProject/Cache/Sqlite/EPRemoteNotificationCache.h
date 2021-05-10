//
//  EPRemoteNotificationCache.h
//  LBGoods
//
//  Created by jarhom on 2017/11/13.
//  Copyright © 2017年 厦门一品威客. All rights reserved.
//

#import "EPSQLiteCache.h"


@interface EPRemoteNotificationCache : EPSQLiteCache

//插入数据
- (void)insertNotificationObject:(id )notification
                        complete:(void(^)(BOOL isOK))completeBlock;

////清空数据
- (void)deleteNotificationObjectsByType:(NSInteger)type
                               complete:(void(^)(BOOL isOK))completeBlock;

//删除消息
- (void)deleteNotificationWithMsgId:(NSString *)msgId
                           complete:(void(^)(BOOL isOK))completeBlock;

//查询消息是否已经被读
-(void)searchNotificationWithMsgId:(NSString *)msgId complete:(void(^)(BOOL read))completeBlock;

//获取数据总数
- (void)getUnReadNotificationIdsWithType:(NSInteger)type
                                complete:(void(^)(NSArray *ids))completeBlock;


//获取消息类别最新消息和消息数
- (void)getUnReadNotificationWithType:(NSInteger)type
                             complete:(void(^)(NSInteger count))completeBlock;

@end
