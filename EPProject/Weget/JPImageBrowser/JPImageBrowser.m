//
//  JPImageBrowser.m
//  StarConnect
//
//  Created by jarhom on 2018/7/13.
//  Copyright © 2018年 厦门GMQ. All rights reserved.
//

#import "JPImageBrowser.h"
#import "YBImageBrowserPromptBar.h"


#define kImageDetectionID @"YBImageBrowserFunctionModel_ID_ImageDetectionID"


@interface JPImageBrowser ()<YBImageBrowserDelegate>

@end

@implementation JPImageBrowser

+ (void)showImageBrowserWithData:(NSArray <YBImageBrowserModel *>*)data currentIndex:(NSInteger)index {
    
    JPImageBrowser *browser = [[JPImageBrowser alloc] init];
    browser.delegate = browser;
    
    YBImageBrowserFunctionModel *model0 = [YBImageBrowserFunctionModel functionModelForSavePictureToAlbum];
    YBImageBrowserFunctionModel *model1 = [[YBImageBrowserFunctionModel alloc] init];
    model1.ID = kImageDetectionID;
    model1.name = @"识别图中二维码";
    
    browser.fuctionDataArray = @[model0,model1];
    browser.dataArray = data;
    browser.currentIndex = index;
    [browser show];
}



/**
 点击功能栏的回调
 
 @param imageBrowser 当前图片浏览器
 @param model 功能的数据model
 */
- (void)yBImageBrowser:(YBImageBrowser *)imageBrowser clickFunctionBarWithModel:(YBImageBrowserFunctionModel *)model {
    if ([model.ID isEqualToString:kImageDetectionID]) {
        YBImageBrowserModel *model = [imageBrowser.dataArray objectAtIndex:imageBrowser.currentIndex];
        
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSString *result = [self detectQRImage:model.image];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                UIWindow *window = [YBImageBrowserUtilities getNormalWindow];
                if (!result) {
                    [window yb_showForkPromptWithText:@"未检测到任何数据"];
                    return;
                }
                
                if ([result hasPrefix:@"http"]) {
//                    [UIApplication JP_openOutsideBrowserWithUrl:result];
                } else {
                    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
                    pastboard.string = result;
                    [window yb_showHookPromptWithText:@"扫描结果已复制到剪贴板"];
                }
            });
        });
        
        
        
        
    }
}



- (NSString *)detectQRImage:(UIImage *)image {
    if (!image) {
        return nil;
    }
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    NSData*imageData =UIImagePNGRepresentation(image);
    CIImage*ciImage = [CIImage imageWithData:imageData];
    if (!ciImage) {
        return nil;
    }
    NSArray*features = [detector featuresInImage:ciImage];
    if (!features.count) {
        return nil;
    }
    CIQRCodeFeature*feature = [features objectAtIndex:0];
    NSString*scannedResult = feature.messageString;
    return scannedResult;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
