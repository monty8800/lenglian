//
//  Global.h
//  HelloCordova
//
//  Created by ywen on 15/7/21.
//
//


#import <Foundation/Foundation.h>

#import <TAKUUID/TAKUUID.h>
#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "XELogFormatter.h"
#import <MKNetworkKit/MKNetworkKit.h>
#import "XEPlugin.h"
#import <YwenKit/YwenKit.h>
#import <BaiduMapAPI/BMapKit.h>


#define CLIENT_TYPE @"2"  //客户端类型
#define UMENG_KEY @"559500cc67e58ee95500064a"  //友盟的key
//效果图与实际屏幕比例
#define REALSCREEN_MULTIPBY  (SCREEN_WIDTH / 320)

#define UPDATE_FOLDER [[CDVViewController applicationDocumentsDirectory] stringByAppendingPathComponent:@"update"]  //存放www的升级目录

#define AUTH_PIC_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

//通知
#define NOTI_UPDATE_USER @"update:user"

//百度地图key
#define BAIDU_MAP_AK @"zG8D9l28S3b9CaZiFRlmYkhl"

@interface Global : NSObject <ToastProtocol, LoadingProtocol>

@property (strong, nonatomic) NSString *uuid;   //uuid
@property (strong, nonatomic) NSString *version;   //版本号
@property (strong, nonatomic) NSString *wwwVersion;  //静态目录版本号
@property (strong, nonatomic) BMKMapManager *mapManager;

@property (weak, nonatomic) UIViewController *currentVC;  //当前显示的vc

@property (weak, nonatomic) UITabBarController *tabVC; //tabbarvc


+(Global *) sharedInstance;

+(void)setUpUmeng;

+(void) setUpLogger;

+(void) checkUpdate;

+(void) setupBaiduMap;

@end
