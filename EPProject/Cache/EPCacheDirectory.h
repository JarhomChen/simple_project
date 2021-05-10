//
//  EPCacheDirectory.h
//  EPProject
//
//  Created by Jarhom on 2019/2/13.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EPCacheDirectory : NSObject


//sqlite 文件存放目录
+ (NSString *)SQLiteDocumentPath;

#pragma mark - 下载缓存
//下载缓存目录
+ (NSString *)downloadCachePath;

#pragma mark - 计算当前缓存大小
+ (NSString *)getCacheSizeFormat;
+ (void)clearAllCache:(void(^)(void))complete;

@end

NS_ASSUME_NONNULL_END
