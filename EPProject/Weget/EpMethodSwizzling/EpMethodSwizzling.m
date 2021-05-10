//
//  EpMethodSwizzling.m
//  Epweike_Witkey
//
//  Created by epwk on 2018/3/13.
//  Copyright © 2018年 Epwk. All rights reserved.
//

#import "EpMethodSwizzling.h"
#import <objc/runtime.h>

/**
 黑魔法 方法替换

 @param objClass 类名
 @param originSEL 原始方法
 @param customSEL 新建自定义交换方法
 */
void EpSwizzlingMethod(Class objClass,SEL originSEL,SEL customSEL){
    
    Method originMethod = class_getInstanceMethod(objClass, originSEL);//获取 实例方法
    Method customMethod = nil;
    if(!originMethod){//不存在 实例方法  则对类方法进行处理
        originMethod = class_getClassMethod(objClass, originSEL);
        if (!originMethod) {
            return;
        }
        customMethod = class_getClassMethod(objClass, customSEL);
        if (!customMethod) {
            return;
        }
    }else{//存在  处理实例方法
        customMethod = class_getInstanceMethod(objClass, customSEL);
        if (!customMethod) {
            return;
        }
    }
    
    BOOL isAddMethodSuccess = class_addMethod(objClass, originSEL, method_getImplementation(customMethod), method_getTypeEncoding(customMethod));//动态添加方法
    if (isAddMethodSuccess) {
        class_replaceMethod(objClass, customSEL, method_getImplementation(customMethod), method_getTypeEncoding(customMethod));
    }else{//自身已经有了该方法  那么交换方法即可
        method_exchangeImplementations(originMethod, customMethod);
    }
    
}
