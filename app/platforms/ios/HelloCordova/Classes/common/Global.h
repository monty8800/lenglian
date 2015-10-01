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
#import <MKNetworkKit.h>

#pragma mark- api

//#define SERVER @"http://192.168.26.177:7080/llmj-app/"
#define SERVER @"http://192.168.29.204:8072/"
#define NEARBY_GOODS [SERVER stringByAppendingString: @"/findNear/nearGoods.shtml"]
#define NEARBY_CAR [SERVER stringByAppendingString: @"/findNear/nearCar.shtml"]
#define NEARBY_WAREHOUSE [SERVER stringByAppendingString: @"/findNear/nearWarehouse.shtml"]

#define NEARBY_GOODS_DETAIL [SERVER stringByAppendingString: @"/carFindGoods/list.shtml"]
#define NEARBY_CAR_DETAIL [SERVER stringByAppendingString: @"/searchCarCtl/searchCar.shtml"]
#define NEARBY_WAREHOUSE_DETAIL [SERVER stringByAppendingString: @"/searchWarehouseCtl/searchWarehouse.shtml"]



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

typedef void (^LocationCB)(BMKUserLocation *location);
typedef void (^ReverseGeoCB)(BMKReverseGeoCodeResult *result);
typedef void(^GeoCB) (BMKGeoCodeResult *result);

@interface Global : NSObject <ToastProtocol, LoadingProtocol, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>
{
    LocationCB _locationCB;
    ReverseGeoCB _reverseGeoCB;
    GeoCB _geoCB;
}

@property (strong, nonatomic) NSString *uuid;   //uuid
@property (strong, nonatomic) NSString *version;   //版本号
@property (strong, nonatomic) NSString *wwwVersion;  //静态目录版本号
@property (strong, nonatomic) BMKMapManager *mapManager;
@property (strong, nonatomic) BMKLocationService *locationService;
@property (strong, nonatomic) BMKUserLocation *userLocation;
@property (strong, nonatomic) BMKGeoCodeSearch *geoCoder;

@property (weak, nonatomic) UIViewController *currentVC;  //当前显示的vc

@property (weak, nonatomic) UITabBarController *tabVC; //tabbarvc

@property (strong, nonatomic) MKNetworkEngine *netEngine; 


+(Global *) sharedInstance;

+(void)setUpUmeng;

+(void) setUpLogger;

+(void) checkUpdate;

+(void) setupBaiduMap;

+(void) getLocation:(LocationCB) cb;
+(void) reverseGeo:(CLLocationCoordinate2D) point cb:(ReverseGeoCB) cb;

+(void) geo:(NSString *) city address:(NSString *) address cb:(GeoCB) cb;


@end
