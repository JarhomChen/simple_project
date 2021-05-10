//
//  JPImageBrowser.h
//  StarConnect
//
//  Created by jarhom on 2018/7/13.
//  Copyright © 2018年 厦门GMQ. All rights reserved.
//

// 使用示例：
//
//  YBImageBrowserModel *model = [[YBImageBrowserModel alloc] init];
//  [model setUrl:[NSURL URLWithString:_url]];
//  model.sourceImageView = imageView;
//
//  [JPImageBrowser showImageBrowserWithData:@[model] currentIndex:0];



#import "YBImageBrowser.h"

@interface JPImageBrowser : YBImageBrowser

+ (void)showImageBrowserWithData:(NSArray <YBImageBrowserModel *>*)data currentIndex:(NSInteger)index;




@end
