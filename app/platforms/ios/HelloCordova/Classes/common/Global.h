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
#import "XEPlugin.h"
#import <YwenKit/YwenKit.h>
#import <BaiduMapAPI/BMapKit.h>
#import <YwenNetworkit.h>



#pragma mark- api




#define TOKEN @"da971f8e9e024f579800cf20c146e6df"

#ifdef DEBUG

//#define SERVER @"http://m.lenglianmajia.com/"

//#define IMG_SERVER @"http://qa-pic.lenglianmajia.com/"
#define IMG_SERVER @"http://pic.lenglianmajia.com/"

#define SERVER @"http://192.168.26.177:7080/llmj-app/"
//#define SERVER @"http://192.168.29.149:8072/"
//#define SERVER @"http://192.168.29.210:8072/"
//#define SERVER @"http://192.168.29.204:8072/"
//#define SERVER @"http://192.168.29.22:8072/"
//#define SERVER @"http://192.168.29.203:8072/"

#else

#define SERVER @"http://m.lenglianmajia.com/"
#define IMG_SERVER @"http://pic.lenglianmajia.com/"

#endif

//附近
//货源
#define NEARBY_GOODS [SERVER stringByAppendingString: @"/findNear/nearGoods.shtml"]
//车源
#define NEARBY_CAR [SERVER stringByAppendingString: @"/findNear/nearCar.shtml"]
//库源
#define NEARBY_WAREHOUSE [SERVER stringByAppendingString: @"/findNear/nearWarehouse.shtml"]

//详情
//货
#define NEARBY_GOODS_DETAIL [SERVER stringByAppendingString: @"/carFindGoods/list.shtml"]
//车
#define NEARBY_CAR_DETAIL [SERVER stringByAppendingString: @"/searchCarCtl/searchCar.shtml"]
//库
#define NEARBY_WAREHOUSE_DETAIL [SERVER stringByAppendingString: @"/searchWarehouseCtl/searchWarehouse.shtml"]

//地图弹窗
//我的货源列表
#define MY_GOODS [SERVER stringByAppendingString: @"/mjGoodsResource/queryMjGoodsResourceList.shtml"]
//我的车源列表
#define MY_CARS [SERVER stringByAppendingString: @"/carFindGoods/listCarResources.shtml"]
//我的仓库列表
#define MY_WAREHOUSE [SERVER stringByAppendingString: @"mjWarehouseCtl/queryMjWarehouse.shtml"]


//订单
//货找库
#define ORDER_GOODS_SELECT_WAREHOUSE [SERVER stringByAppendingString: @"/mjOrderWarhouse/addGoodsFoundWarhouseOrder.shtml"]
//货找车
#define ORDER_GOODS_SELECT_CAR [SERVER stringByAppendingString: @"/goodFoundCarCtl/goodFoundCar.shtml"]

//车找货
#define ORDER_CAR_SELECT_GOODS [SERVER stringByAppendingString: @"/carFindGoods/orderTrade.shtml"]

//库找货
#define ORDER_WAREHOUSE_SELECT_GOODS [SERVER stringByAppendingString: @"mjOrderWarhouse/addWarhouseFoundGoodsOrder.shtml"]

//上传头像
#define SET_AVATAR [SERVER stringByAppendingString: @"/loginCtl/changHeadPic.shtml"]



#define CLIENT_TYPE @"2"  //客户端类型

#if DEBUG
#define UMENG_KEY @"564011b6e0f55ae18e005267"//DEBUG下的测试appkey
#else
#define UMENG_KEY @"56303ec167e58e51530059f4"  //友盟的key
#endif

//效果图与实际屏幕比例
#define REALSCREEN_MULTIPBY  (SCREEN_WIDTH / 320)

//热更新
#define UPDATE_FOLDER [[CDVViewController applicationDocumentsDirectory] stringByAppendingPathComponent:@"update"]  //存放www的升级目录11
#define kUserDefault_Version @"Version"   //userdefault中存储的版本号 用来决定是否显示引导页
#define kUserDefault_wwwVersion @"wwwVersion"   //userdefault中存储的www版本号


#define AUTH_PIC_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

//通知
#define NOTI_UPDATE_USER @"update:user"

//百度地图key
#define BAIDU_MAP_AK @"zG8D9l28S3b9CaZiFRlmYkhl"


#define KEY_WINDOW          [[UIApplication sharedApplication]keyWindow]
#define IPHONEWIDTH         [UIScreen mainScreen].bounds.size.width
#define IPHONEHEIGHT        [UIScreen mainScreen].bounds.size.height
#define IPHONESCREEN5p5     IPHONEHEIGHT == 736.00
#define IPHONESCREEN4p7     IPHONEHEIGHT == 667.00
#define IPHONESCREEN4       IPHONEHEIGHT == 568.00
#define IPHONESCREEN3p5     IPHONEHEIGHT == 480.00

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

@property (weak, nonatomic) UIViewController *mapVC; //地图vc

@property (strong, nonatomic) YwenNetworkit *netEngine;


+(Global *) sharedInstance;

+(void)setUpUmeng;

+(void) setUpLogger;

+(void) checkUpdate;

+(void) setupBaiduMap;

-(void)showGuideViews;

+(void) getLocation:(LocationCB) cb;
+(void) reverseGeo:(CLLocationCoordinate2D) point cb:(ReverseGeoCB) cb;

+(void) geo:(NSString *) city address:(NSString *) address cb:(GeoCB) cb;

+(NSDictionary *) getUser;

+(NSString *) goodsType:(NSInteger) type;

@end
