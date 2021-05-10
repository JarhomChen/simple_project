//
//  UIScrollView+XXRefresh.m
//  LBGoods
//
//  Created by Jarhom on 2017/10/12.
//  Copyright © 2017年 GMQ. All rights reserved.
//

#import "UIScrollView+XXRefresh.h"
#import "AJWaveRefreshAutoStateFooter.h"
#import "AJWaveRefreshHeader.h"




@implementation UIScrollView (XXRefresh)



- (void)addHeaderRefresh:(void(^)(void))refreshingBlock {
    self.mj_header = [AJWaveRefreshHeader headerWithRefreshingBlock:refreshingBlock];
    
}

- (void)refreshFinished {
    
    if ([self.mj_header isRefreshing]) {
        [self.mj_header endRefreshing];
    }
    
    [self.mj_footer endRefreshing];
    
}

-(void)refreshFinishedWithCache
{
    BOOL noMore = self.mj_footer.state == MJRefreshStateNoMoreData;
    [self refreshFinished];
    if (noMore) {
        [self loadMoreFinishedAndNoMoreData];
    }
}

- (void)addFooterLoadMore:(void(^)(void))loadMoreBlock {
    self.mj_footer = [AJWaveRefreshAutoStateFooter footerWithRefreshingBlock:loadMoreBlock];
}


- (void)loadMoreFinished {
    
    [self.mj_footer endRefreshing];
    
}

- (void)loadMoreFinishedAndNoMoreData {

    [self.mj_footer endRefreshingWithNoMoreData];

}

- (void)addHeaderRefresh:(void (^)(void))refreshingBlock footerRefresh:(void (^)(void))loadMoreBlock {
    [self addHeaderRefresh:refreshingBlock];
    [self addFooterLoadMore:loadMoreBlock];
}

@end
