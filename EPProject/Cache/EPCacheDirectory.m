//
//  EPCacheDirectory.m
//  EPProject
//
//  Created by Jarhom on 2019/2/13.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import "EPCacheDirectory.h"

//sqlite文件夹 Library/Caches/sqlite
#define kSqliteCachePath @"SQLite"
#define kDownloadCachePath @"Download"

@implementation EPCacheDirectory

//sqlite 文件存放目录
+ (NSString *)SQLiteDocumentPath {
    NSString *cahcePath = [[UIApplication sharedApplication] cachesPath];
    NSString *sqlitePath = [cahcePath stringByAppendingPathComponent:kSqliteCachePath];
    [EPCacheDirectory checkIsExistAndCreate:sqlitePath];
    
    
    return sqlitePath;
}


+ (void)checkIsExistAndCreate:(NSString *)directoryPath {
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
}

#pragma mark - 下载缓存
//下载缓存目录
+ (NSString *)downloadCachePath {
    NSString *cahcePath = [[UIApplication sharedApplication] documentsPath];
    NSString *downloadPath = [cahcePath stringByAppendingPathComponent:kDownloadCachePath];
    [EPCacheDirectory checkIsExistAndCreate:downloadPath];
    return downloadPath;
}

#pragma mark - 计算文件大小
//单个文件的大小
+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
+ (long long) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}


@end
