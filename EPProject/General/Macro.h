//
//  Macro.h
//  EPProject
//
//  Created by Jarhom on 2019/2/13.
//  Copyright © 2019 Jarhom. All rights reserved.
//  实现宏定义

///是否打包线上环境 0 - 开发  1 - 线上  2 - 测试
#define kIsReleaseEnv  0

#if kIsReleaseEnv == 0

//服务器地址 测试环境
#define kServerBaseURL @"http://basic_new.yxsoft.net/"



#elif kIsReleaseEnv == 1

//服务器地址 线上环境
#define kServerBaseURL @"https://api.zhimeixingqiu.com/api/v1/"

#else

//服务器地址 测试环境
#define kServerBaseURL @"https://api.zhimeixingqiu.com/api/v1/"

#endif


//图片最大尺寸
#define kImageMaxSize 1000

//列表记录每页数量
#define kPageListCount 20


#ifdef DEBUG    //测试环境log

#define DTLog(format, ...) NSLog((@"[文件名:%s]" "[函数名:%s]" "[行号:%d]" format), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);

#define DLog(...) NSLog(__VA_ARGS__);

#else   //release 不log

#define DTLog(...);
#define DLog(...);

#endif

//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//int->string
#define NSStringFromInteger(int) [NSString stringWithFormat:@"%@",@(int)]
#define NSStringFromDecimal(decimal) [NSString stringWithFormat:@"%@",decimal]
#define NSDecimalNumberFromString(string) [NSDecimalNumber decimalNumberWithString:string]


#define kScreenWidth (YYScreenSize().width)
#define kScreenHeight (YYScreenSize().height)

#define showAlert(_msg){UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];[alert show];}
