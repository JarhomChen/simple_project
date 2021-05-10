//
//  JHImagePickerManager.m
//  XXConnect
//
//  Created by jarhom on 2017/12/15.
//  Copyright © 2017年 GMQ. All rights reserved.
//

#import "JHImagePickerManager.h"
#import "AppDelegate.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <TZImagePickerController/TZImageManager.h>
#import <Photos/Photos.h>



@interface JHImagePickerManager ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
//拍照回调
@property (copy, nonatomic) void(^getPhotoComplete)(NSArray *image);
//最大选择张数
@property (nonatomic) NSInteger maxImageCount;



@end

@implementation JHImagePickerManager

static JHImagePickerManager *pickerManager = nil;

+ (instancetype)shareInstance {
    if (!pickerManager) {
        pickerManager = [[JHImagePickerManager alloc] init];
    }
    return pickerManager;
}

//次方法会弹出actionsheet让用户选拍照或相册
- (void)pickImageWithMaxCount:(NSInteger)maxCount
        shouldCropWhenPickOne:(BOOL)shouldCropWhenPickOne
                     complete:(void(^)(NSArray *images))complete {
    if (maxCount <=0) {
        return;
    }
    
    self.shouldCropWhenPickOne = shouldCropWhenPickOne;
    
    __weak __typeof(self) weakSelf = self;
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [UIAlertController showActionSheetInViewController:delegate.window.rootViewController withTitle:nil message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"马上拍照",@"手机相册"] popoverPresentationControllerBlock:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 2) {
            [weakSelf getImageFromCamera:complete];
        } else if (buttonIndex == 3) {
            [weakSelf getImagesFromAlbumWithMaxImageCount:maxCount complete:complete];
        }
    }];

}


//从相机获取照片
- (void)getImageFromCamera:(void(^)(NSArray *images))complete; {
    self.maxImageCount = 1;
    self.getPhotoComplete = complete;
    [self takePhoto];
}

//从相册选取
- (void)getImagesFromAlbumWithMaxImageCount:(NSInteger)maxCount
                                   complete:(void(^)(NSArray *images))complete {
    self.maxImageCount = maxCount;
    self.getPhotoComplete = complete;
    [self pushTZImagePickerController];
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        self.imagePickerVc.allowsEditing = _shouldCropWhenPickOne;
        self.imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.window.rootViewController presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
        CGSize destSize = CGSizeZero;
        if (image.size.width >= image.size.height && image.size.width>kImageMaxSize) {
            destSize = CGSizeMake(kImageMaxSize, kImageMaxSize*image.size.height/image.size.width);
        } else if (image.size.width<image.size.height && image.size.height > kImageMaxSize) {
            destSize = CGSizeMake(kImageMaxSize*image.size.width/image.size.height, kImageMaxSize);
        }
        
        if (!CGSizeEqualToSize(destSize, CGSizeZero)) {
            image = [image imageByResizeToSize:destSize];
        }
        
        if (self.getPhotoComplete) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.getPhotoComplete(image? @[image]:nil);
            });
        }
        self.imagePickerVc = nil;
       
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    if (self.maxImageCount <= 0) {
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxImageCount columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.navigationBar.translucent = NO;
    

    
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    imagePickerVc.photoWidth = kImageMaxSize;
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // if (iOS7Later) {
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // }
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = self.maxImageCount==1 && _shouldCropWhenPickOne;
    imagePickerVc.allowCameraLocation = NO;
    imagePickerVc.needCircleCrop = NO;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 0;
    NSInteger widthHeight = kScreenWidth - 2 * left;
    NSInteger top = (kScreenHeight - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    // 设置横屏下的裁剪尺寸
    // imagePickerVc.cropRectLandscape = CGRectMake((self.view.tz_height - widthHeight) / 2, left, widthHeight, widthHeight);
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
    // 自定义导航栏上的返回按钮
    /*
     [imagePickerVc setNavLeftBarButtonSettingBlock:^(UIButton *leftButton){
     [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
     [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
     }];
     imagePickerVc.delegate = self;
     */
    
    imagePickerVc.isStatusBarDefault = NO;

    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
//    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//
//    }];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    if (self.getPhotoComplete) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.getPhotoComplete(photos);
        });
    }
  
}


#pragma mark - alert

- (void)warningAuthCamera {
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    
    [UIAlertController showAlertInViewController:delegate.window.rootViewController withTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" cancelButtonTitle:@"取消" destructiveButtonTitle:@"设置" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 1)
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
}

- (void)warningAuthAlbum {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    [UIAlertController showAlertInViewController:delegate.window.rootViewController withTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" cancelButtonTitle:@"取消" destructiveButtonTitle:@"设置" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 1)
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
}


#pragma mark - get

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
    }
    return _imagePickerVc;
}

@end
