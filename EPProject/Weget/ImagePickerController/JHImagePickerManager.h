//
//  JHImagePickerManager.h
//  XXConnect
//
//  Created by jarhom on 2017/12/15.
//  Copyright © 2017年 GMQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHImagePickerManager : NSObject

//是否需要截图
@property (nonatomic) BOOL shouldCropWhenPickOne;

+ (instancetype)shareInstance;

//次方法会弹出actionsheet让用户选拍照或相册
- (void)pickImageWithMaxCount:(NSInteger)maxCount
        shouldCropWhenPickOne:(BOOL)shouldCropWhenPickOne
                     complete:(void(^)(NSArray *images))complete;

//从相机获取照片
- (void)getImageFromCamera:(void(^)(NSArray *images))complete;

//从相册选取
- (void)getImagesFromAlbumWithMaxImageCount:(NSInteger)maxCount
                                   complete:(void(^)(NSArray *images))complete;


@end
