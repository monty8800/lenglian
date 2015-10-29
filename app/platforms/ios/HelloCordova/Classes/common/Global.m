//
//  Global.m
//  HelloCordova
//
//  Created by ywen on 15/7/21.
//
//

#import "Global.h"

@implementation Global

+(Global *)sharedInstance {
    static Global *global = nil;
    @synchronized(self) {
        if (global == nil) {
            global = [[self alloc] init];
        }
    }
    return global;
}

#pragma mark- 初始化

-(instancetype)init {
    self = [super init];
    if (self) {
        self.uuid = [[TAKUUIDStorage sharedInstance] findOrCreate];
        
        NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
        self.version =[infoDict objectForKey:@"CFBundleShortVersionString"];
        self.wwwVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"wwwVersion"];
        self.netEngine = [[MKNetworkEngine alloc] init];
    }
    return self;
}

+(void)setUpUmeng {
    
    //MARK: 友盟统计
    [MobClick startWithAppkey:UMENG_KEY reportPolicy:BATCH channelId:@"our_web"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
}

+(void) setUpLogger {
#ifdef DEBUG
    static const DDLogLevel level = DDLogLevelVerbose;
    
    [DDLog addLogger:[DDASLLogger sharedInstance] withLevel:level];
    [[DDASLLogger sharedInstance] setLogFormatter:[[XELogFormatter alloc] init]];
#else
    static const DDLogLevel level = DDLogLevelOff;
#endif
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLevel:level];
    [[DDTTYLogger sharedInstance] setLogFormatter:[[XELogFormatter alloc] init]];
    
    DDLogDebug(@"uuid is %@, version is %@, wwwVersion is %@", [Global sharedInstance].uuid, [Global sharedInstance].version, [Global sharedInstance].wwwVersion);
}

#pragma mark- 地图相关

+(void)setupBaiduMap {
    [Global sharedInstance].mapManager = [BMKMapManager new];
    BOOL ret = [[Global sharedInstance].mapManager start:BAIDU_MAP_AK generalDelegate:nil];
    if (ret == NO) {
        DDLogDebug(@"初始化百度地图失败！");
    }
    else
    {
        DDLogDebug(@"初始化百度地图成功！");
    }
}

//MARK:- 获取地理位置
+(void)getLocation:(LocationCB)cb {
    
    [[Global sharedInstance] updateLocation: cb];
}

-(void) updateLocation:(LocationCB) cb {
    if (_locationService == nil) {
        _locationService = [BMKLocationService new];
        _locationService.delegate = self;
    }
    _locationCB = cb;
    [_locationService startUserLocationService];
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    DDLogDebug(@"user loaction update %@", userLocation);
    [_locationService stopUserLocationService];
    _userLocation = userLocation;
    _locationCB(_userLocation);
    _locationCB = nil;
}

//MARK:- 反向地址查询
+(void)reverseGeo:(CLLocationCoordinate2D)point cb:(ReverseGeoCB)cb {
    [[Global sharedInstance] doReverseGeo:point cb:cb];
}

-(void) doReverseGeo:(CLLocationCoordinate2D) point cb:(ReverseGeoCB) cb {
    _reverseGeoCB = cb;
    if (_geoCoder == nil) {
        _geoCoder = [BMKGeoCodeSearch new];
        _geoCoder.delegate = self;
    }
    
    BMKReverseGeoCodeOption *option = [BMKReverseGeoCodeOption new];
    option.reverseGeoPoint = point;
    BOOL ret = [_geoCoder reverseGeoCode:option];
    if (ret) {
        DDLogDebug(@"反向解析请求发送成功");
    }
    else
    {
        
        DDLogError(@"反向解析请求发送失败 %f, %f", point.latitude, point.longitude);
    }
    
}

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    DDLogDebug(@"result---%@", result);
    if (error == 0) {
        _reverseGeoCB(result);
    }
    else
    {
        DDLogError(@"反向解析失败 %d", error);
    }
    _reverseGeoCB = nil;
}

//MARK:- 地理位置解析
+(void)geo:(NSString *)city address:(NSString *)address cb:(GeoCB)cb {
    [[Global sharedInstance] geo:city address:address cb:cb];
}

//MARK:- 用户信息
+(NSDictionary *)getUser {
    NSString *userStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    if (userStr) {
        NSDictionary *user = [NSJSONSerialization JSONObjectWithData:[userStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        if ([user isKindOfClass:[NSDictionary class]]) {
            DDLogDebug(@"user in native is %@", user);
            return user;
        }
        else
        {
            return nil;
        }
        
    }
    else
    {
        return nil;
    }
}

-(void)geo:(NSString *)city address:(NSString *)address cb:(GeoCB)cb {
    _geoCB = cb;
    if (_geoCoder == nil) {
        _geoCoder = [BMKGeoCodeSearch new];
        _geoCoder.delegate = self;
    }
    
    BMKGeoCodeSearchOption *option = [BMKGeoCodeSearchOption new];
    option.city = city;
    option.address = address;
    BOOL ret = [_geoCoder geoCode:option];
    if (ret) {
        DDLogDebug(@"正向解析请求发送成功");
    }
    else
    {
        
        DDLogError(@"正向解析请求发送失败");
    }

}

-(void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    DDLogDebug(@"result------%@", result);
    if (error == 0) {
        _geoCB(result);
    }
    else
    {
        DDLogError(@"正向解析失败 %d", error);
    }
    _geoCB = nil;
}


#pragma mark- 检查更新, 服务器版本号大于本地版本号就下载，小于就直接回退本地版本号做降级
+(void)checkUpdate {
    //TODO:  等接口，再具体实现
}

-(void) updateWWW {
    //TODO: 等接口，热更新
}


#pragma mark- cordova插件xeplugin协议实现
//MARK: toast
-(void)showToastWithContent:(NSString *)content showTime:(NSTimeInterval)showTime postion:(ToastPosition)position {
    DDLogDebug(@"show toast messge %@, time %f, postion, %@", content, showTime, @(position));
    [Toast showToastWithContent:content showTime:1.5 postion:position];
    
}

-(void) showToastWithContent:(NSString *)content {
    DDLogDebug(@"default show message %@", content);
    [Toast showToastWithContent:content];
}

-(void) showErr:(NSString *)message {
    DDLogDebug(@"show err %@", message);
    [Toast showErr:message];
}

-(void)showSuccess:(NSString *)message {
    DDLogDebug(@"show success %@", message);
    [Toast showSuccess:message];
}

//MARK: loading
-(void)show:(NSString *)message force:(BOOL)force {
    DDLogDebug(@"show force %d, message %@", force, message);
    [Loading show:message isForce:force];
}

+(NSString *)goodsType:(NSInteger)type {
    NSString *result;
    switch (type) {
        case 1:
            result = @"常温";
            break;
            
        case 2:
            result = @"冷藏";
            break;
            
        case 3:
            result = @"冷冻";
            break;
            
        case 4:
            result = @"急冻";
            break;
            
        case 5:
            result = @"深冷";
            break;
            
        default:
            break;
    }
    return result;
}

-(void)hide {
    DDLogDebug(@"hide loading");
    [Loading hide];
}

@end
