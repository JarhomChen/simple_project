#项目框架介绍

##1、 项目框架目录

```
|--project 项目目录
      |--singleton 单例目录
      |--Module 项目业务模块
      |--Cache 缓存模块
            |-- FileCache 文件缓存（YYCache） 暂无
            |-- Sqlite 数据库缓存（FMDB）
            |-- JPUserDefault NSUserDefault设置
            |-- JPCacheManager app的缓存sanbox目录管理
      |--Model 数据对象
      |--Network 网络处理模块
      |--General 通用类和基类
            |-- Class 通用基类
            |-- Category 通用Category类型
            |-- Macro.h 全局宏定义头文件
            |-- PromptString.h 常用提示语和key设置
            |-- TypeDefine.h 枚举类型定义
      |--Wedget 第三方工具
|--Pods cocoapods第三方库管理
```
### 1.1 singleton 目录
app的单例全部放置在该目录，***非必要尽量不要做单例***

下面主要说一下两个单例类
#### 1.1.1 EPClient.h

```
@interface EPClient : NSObject

//App启动或者唤醒时间
@property (nonatomic, strong) NSDate *wakeupDate;
//App 当前登录用户
@property (nonatomic, strong) EPUser *loginUser;

+ (instancetype)shareInstance;


#pragma mark - login
//loginUser的唯一set方法
+ (void)loginWithUser:(EPUser *)user;
//退出登录
+ (void)logout;
//保存当前用户
+ (void)saveCurrentUserLocal;
//没次启动用户自动登录
+ (void)userAutoLogin;
//判断登录状态  shouldLogin==YES时，未登录状态会弹出登录窗口
+ (BOOL)checkLoginStatus:(BOOL)shouldLogin;
//登录令牌
+ (NSString *)accessToken;
//是否已设置支付密码
+ (BOOL)isSetPayPassword;
//刷新用户信息
+ (void)refreshUserInfo:(void(^)(BOOL isSucc, EPUser *user, NSString *msg))complete;
```
主要EPClient文件主要管理App客户端的相关全局参数和功能，比如登录用户数据持久化
#### 1.1.2 EPRooterManager.h

```
@interface EPRooterManager : NSObject

+ (instancetype)shareInstance;

//启动初始化
- (void)initialWindowWhenDidFinishLaunching;
//跳转到首页
- (void)gotoHomePage;
//登录页面
- (void)gotoLoginViewController;

#pragma mark - HTML
- (void)gotoHtmlPageWithUrl:(NSString *)urlString;

#pragma mark - present
- (void)presentViewController:(UIViewController *)vc animated:(BOOL)flag;
- (void)dissmissViewControllerWithAnimated:(BOOL)flag;

//public
- (UIViewController *)getViewControllerWithStoryBoardName:(NSString *)storyBoardName
                                             storyBoardId:(NSString *)storyBoardId;

@end
```
EPRooterManager文件用于管理模块之间的跳转，比如支付模块需要调用用户模块的登录功能，就需要在EPRooterManager实现跳转登录页面的方法；

**注意：相同模块内部的常规跳转不需要再EPRooterManager里面实现跳转**
### 1.2 Module  目录
该目录用户实现App的逻辑功能和UI,下面给个示例
```
|--Module 项目业务模块目录
    |-- UserCenter
        |-- Login 登录页面目录
            |-- SubViews    //登录页面自定义View或者Cell目录
                |--CustomView.h
                |--CustomView.m
            |-- EPLoginViewController.h
            |-- EPLoginViewController.m
            |-- Login.StoryBoard
        |-- Register 注册页面目录
            |-- EPRegisterViewController.h
            |-- EPRegisterViewController.m
        |-- User.Storyboard       //UserCenter的公共storyboard
    |-- HTML
    ...........
  
```
*建议根据产品UE来划分模块目录，也可以根据功能模块划分比如H5浏览器的HTML模块目录，原则上大模块内部下的子目录不做硬性规定，但是也要尽量做到一目了然

*创建Group的时候不要选择【New Group Without Folder】要连物理目录一起创建，小模块可以共用一个StoryBoard，大模块下子模块可以另行创建StoryBoard。


### 1.3 Cache   目录
#### 1.3.1 EPCacheDirectory Category类
EPCacheDirectory 用于规范沙盒目录下自定义目录的路径，比如音视频文件、sqlite文件等文件的目录安排；
**注意：Documents文件下的内容默认会备份到icloud中，非必要数据必须配置不备份，否则上线审核可能会被拒**
#### 1.3.2 Sqlite 数据库缓存
```
|-- Cache
    |-- Sqlite //sqlite目录
        |-- sqls     //.sql 文件存放位置
            |-- RemoteNotification.sql   //sql语句文件 
        |-- EPSQLiteCache.h     //sqlite缓存基类
        |-- EPSQLiteCache.m
        |-- EPRemoteNotificationCache.h   //eg.消息通知数据缓存类  
        |-- EPRemoteNotificationCache.m
```
1、EPSQLiteCache 基类文件实现了数据的创建，以及FMDatabaseQueue的初始化；
2、EPRemoteNotificationCache是后期开发的离线未读消息数据缓存类，必须继承EPSQLiteCache类，并在init方法中完成了RemoteNotification数据表的创建；
```
- (id)init
{
    self = [super init];
    if (self) {
        //数据库的操作全部必须使用FMDatabaseQueue队列来执行事务，这样能确保线程安全
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            //判断数据表是否已建立
            if (![db tableExists:DB_TABLENAME_RemoteNotification]) {
                //读取Sqls目录下的.sql文件来建立数据表
                NSString *path = [[NSBundle mainBundle] pathForResource:DB_TABLENAME_RemoteNotification ofType:@"sql"];
                
                NSError *err = nil;
                NSString *sql = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
                
                if (sql) {
                    //执行sql语句
                    if ([db executeStatements:sql]) {
                        DLog(@"创建成功!");
                    }
                }
            }
        }];
    }
    return self;
}

/插入数据
- (void)insertNotificationObject:(id )notification
                        complete:(void(^)(BOOL isOK))completeBlock {
    if (notification.type != TyMessageType_System) {
        if (completeBlock)  completeBlock (NO);
        return;
    }

    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {

        NSString *sql = [NSString stringWithFormat:@"REPLACE INTO %@ (`msgId`,`userId`,`type`,`dateTime`,`title`,`content`,`url`) VALUES ('%@','%@',%ld,%ld,'%@','%@','%@');",
                         DB_TABLENAME_RemoteNotification,
                         notification.msgId,
                         [JPClient shareInstance].userCode? :@"0",
                         (long)notification.type,
                         notification.dateTime,
                         notification.title,
                         notification.content,
                         notification.url];

        BOOL isSuccess = [db executeUpdate:sql];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completeBlock) completeBlock(isSuccess);
        });

    }];
}

```
3、RemoteNotification.sql 文件示例

```
DROP TABLE IF EXISTS `RemoteNotification`;
CREATE TABLE `RemoteNotification` (
  `msgId` varchar(10),
  `userId` varchar(10),
  `type` integer(5) NOT NULL,
  `dateTime` integer(15) NOT NULL,
  `title` varchar(100) NOT NULL,
  `content` varchar(100) NOT NULL,
  `url` varchar(100),
  PRIMARY KEY (`msgId`,`userId`,`type`)
);
```
#### 1.3.3 EPUserDefault 类

EPUserDefault 是一个工厂类，***所有NSUserDefault的存储读取必须写在这个文件中***。

这样能方便后期维护NSUserDefaults的所有key，和查看哪些地方使用了NSUserDefaults缓存

EPUserDefault.h
```
@interface EPUserDefault : NSObject
/**
 *  登录用户
 */
+ (void)saveLoginUserInfo:(NSDictionary *)info;
+ (NSDictionary *)getLoginUserInfo;

@end

```
EPUserDefault.m
```
#define UserDefault [NSUserDefaults standardUserDefaults]


@implementation EPUserDefault

/**
 *  登录用户
 */
+ (void)saveLoginUserInfo:(NSDictionary *)info {
    if (!info) {
        [UserDefault removeObjectForKey:@"UDKey_LoginUserInfo"];
    } else {
        [UserDefault setObject:info forKey:@"UDKey_LoginUserInfo"];
    }
    [UserDefault synchronize];
}

+ (NSDictionary *)getLoginUserInfo {
    NSDictionary *info = [UserDefault objectForKey:@"UDKey_LoginUserInfo"];
    return info;
}

@end
```

#### 1.3.4 FileCache缓存
后续会完善添加，主要使用YYCache来管理momery和Disk缓存的策略

### 1.4 Model   目录

1、Model目录用户存放所有数据Model，通常为服务端json数据转化类对象。
2、所有Model必须继承EPModel基类，解析json数据为model实例对象的时候使用YYModel工具。
***3、命名需要后缀Model，比如 EPUserModel，EPPhotoModel,EPTaskModel等***


### 1.6 Network    目录
网络请求模块是基于AFNetworking第三方框架的基础上进行二次封装；
1、设置服务器地址：在General目录下的Macro.h文件中进行配置 kServerBaseURL；
2、网络请求示例

```
typedef NS_ENUM(NSInteger, TyNetworkMethod) {
    TyNetworkMethod_GET = 1,   //GET
    TyNetworkMethod_POST,  //POST
    TyNetworkMethod_PUT,   //PUT
    TyNetworkMethod_DELETE,    //Delete
};


/**
 登录
 
 @param account 账号
 @param password 密码
 */
- (void)userLoginByAccount:(NSString *)account
                  password:(NSString *)password
                   complete:(EPNetworkCallBack)complete {
                   
    [self requestWithMethod:TyNetworkMethod_POST
                       path:@"/api/user/loginByAccount"
                      param:@{@"account":account,
                              @"password":@"xxxxxxx"]}
                   complete:complete];
}

```

3、在服务器请求接口不多的情况下，可以直接再EPNetwork类底下陆续写入，如果接口较多可以新建Category进行划分，比如 登录独立出来一个category类 EPNetwork+Login
4、Network 目录下的Encryption目录内容可以不用理会，主要放置接口调用加密相关加密工具


### 1.7 General    通用目录
#### 1.7.1 Calss 基类目录
1、放置继承于UIViewController、UITableViewCell、UIcollectionViewCell等UIKit常用类的基类，用于项目开发中继承使用；
2、部分类对象的说明
    1) EPTableViewCell 和 EPCollectionViewCell 
    下面以EPTableViewCell.h为例
```
#import <UIKit/UIKit.h>

@class EPTableViewCell;

@protocol EPTableViewCellDelegate<NSObject>

- (void)view:(EPTableViewCell *)cell clickElement:(UIView *)element;

@end

@interface EPTableViewCell : UITableViewCell

//获取重用标识符
+(NSString *)getCellWithReuseIdentifier;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;

@property (weak, nonatomic) IBOutlet UILabel *thirdTitleLab;

@property (weak, nonatomic) IBOutlet UIImageView *selectImageV;



@property (weak, nonatomic) id<EPTableViewCellDelegate>delegate;

@end
```
EPTableViewCell类中已经添加若干UILabel、UIButton和UIImageView的IBOutlet属性，如果项目开发过程中Cell只是简单的展示不需要过多的cell内部逻辑，可以直接将storyboard（或Xib）的UITableViewCell直接设置为EPTableViewCell，而不需要再创建新的Cell，减少文件的创建；
同理也添加了EPTableViewCellDelegate协议的delegate属性，若是cell需要回调可直接使用

3、当项目需要动态管理UIViewController的InterfaceOrientations或者statusBar的style时，项目的控制器堆栈中的类必须使用以下几个类作为基类或者直接使用

EPTabBarController 
EPNavigationController 
EPViewController
EPTableViewController

4、EPUtil 为工具类，常用的函数方法可以写在此文件里面

### 1.8 Wedget    目录
第三方插件和工具因为需要进行二次开发或者由于某种原因无法使用cocoapod引用的库可直接拉入该目录中；
项目需要使用什么第三方库来拉入使用，不需要的不可放进来

**不需要定制的第三方库请使用cocoapods管理*
