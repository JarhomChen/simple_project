//
//  UIScrollView+XXRefresh.h
//  LBGoods
//
//  Created by Jarhom on 2017/10/12.
//  Copyright © 2017年 GMQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (XXRefresh)

//添加刷新
- (void)addHeaderRefresh:(void(^)(void))refreshingBlock;
//刷新完毕
- (void)refreshFinished;
//启动下啦刷新
//带有缓存性质的结束刷新
-(void)refreshFinishedWithCache;

//添加加载更多
- (void)addFooterLoadMore:(void(^)(void))loadMoreBlock;
//加载更多完毕
- (void)loadMoreFinished;
//加载更多无更多数据(满屏提示“已加载完毕”，否则不提示)
- (void)loadMoreFinishedAndNoMoreData;

//
- (void)addHeaderRefresh:(void(^)(void))refreshingBlock footerRefresh:(void(^)(void))loadMoreBlock;


@end
