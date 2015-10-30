//
//  Global.m
//  HelloCordova
//
//  Created by ywen on 15/7/21.
//
//

#import "Global.h"
#import "ZipArchive.h"
@interface Global ()<UIScrollViewDelegate>
{
    UIScrollView *guideScrollView;
}
@end
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
        self.wwwVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefault_wwwVersion];
        self.netEngine = [[MKNetworkEngine alloc] init];
    }
    return self;
}

+(void)setUpUmeng {
    
    //MARK: 友盟统计
    [MobClick startWithAppkey:UMENG_KEY reportPolicy:BATCH channelId:@"our_web"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
//配置在线参数
    [MobClick updateOnlineConfig];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UmengOnLine:) name:UMOnlineConfigDidFinishedNotification object:nil];
    

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

#pragma mark - 热更新

+(void)UmengOnLine:(NSNotification *)notify{
    
    NSDictionary *paramsOnLine = notify.userInfo;//[MobClick getConfigParams];
    NSString *jsonStr = paramsOnLine[@"ios"];
    if (!jsonStr) {
        return;
    }
    NSError *error = nil;
    NSData *dates = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData: dates
                                                              options: NSJSONReadingAllowFragments
                                                                error: &error];
    NSLog(@"__在线参数___ %@",resultDic);

    [[Global sharedInstance] hanldProjectWithParamsOnLine:resultDic];
}

-(void) hanldProjectWithParamsOnLine:(NSDictionary *)paramsDic{
    
    NSString *currentAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *newestAppVersion = paramsDic[@"version"];
    NSComparisonResult result = [currentAppVersion compare:newestAppVersion];
    if (result != NSOrderedAscending) {
        if ([paramsDic[@"backToRelease"] integerValue] == 1) {
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:kUserDefault_wwwVersion];
            return;
        }else{
            
        }
    }
    switch (result) {
        case NSOrderedAscending:
            NSLog(@"升序");
            NSLog(@"app store 有新版本 不再支持旧版本的热更新");
            [self updateWithDic:paramsDic];
            break;
        case NSOrderedSame:
            NSLog(@"same 检查热更新");
            
            [self checkHotVersion:paramsDic];
            break;
        case NSOrderedDescending:
            NSLog(@"降序");
            break;
        default:
            break;
    }
}
-(void)updateWithDic:(NSDictionary *)paramsDic{
//    通知AppDelegate 提示用户更新
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_findNewVersion" object:paramsDic];
}
-(void)checkHotVersion:(NSDictionary *)paramsDic{
    if (!([paramsDic[@"hotUpdateSwitch"] integerValue] == 1 && [paramsDic[@"file"] length] > 0)){
        //        热更新开关
        return;
    }
    NSString *wwwVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefault_wwwVersion];
    if (wwwVersion == nil) {
        wwwVersion = @"0";
    }
    //    初次安装 应该是空字符串
    NSString *newestHotVersion = paramsDic[@"hot_version"];
    NSComparisonResult res = [wwwVersion compare:newestHotVersion];
    switch (res) {
        case NSOrderedAscending:
            NSLog(@"升序 热更新");
            [self downloadSourceWithPath:paramsDic[@"file"] newestVersion:newestHotVersion];
            break;
        case NSOrderedSame:
            NSLog(@"same");
            break;
        case NSOrderedDescending:
            NSLog(@"降序");
            break;
        default:
            break;
    }
}
-(void)downloadSourceWithPath:(NSString *)path newestVersion:(NSString *)newestHotVersion{
    //    下载zip文件
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:path];
        NSError *error = nil;
        NSData *resdata = [NSData dataWithContentsOfURL:url options:0 error:&error];
        if(!error)
        {
            NSString *targetPath = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"update"] stringByAppendingPathComponent:newestHotVersion];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:targetPath]) {
                NSLog(@"exit");
                //               update文件夹存在
            }else{
                BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:targetPath withIntermediateDirectories:YES attributes:nil error:nil];
                if (bo) {
                    NSLog(@"update不存在 创建success");
                }else{
                    NSLog(@"update不存在 创建faile");
                    return;
                }
            }
            //            设置下载zip文件路径
            NSString *zipPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"www.zip"];
            //            zip写入Cashes
            [resdata writeToFile:zipPath options:0 error:&error];
            if(!error)
            {
                //                解压
                ZipArchive *za = [[ZipArchive alloc] init];
                if ([za UnzipOpenFile: zipPath]) {
                    BOOL ret = [za UnzipFileTo: targetPath overWrite: YES];
                    if (NO == ret){
                        NSLog(@"下载 失败");
                    }else{
                        [za UnzipCloseFile];
                        [[NSUserDefaults standardUserDefaults] setObject:newestHotVersion forKey:kUserDefault_wwwVersion];
                        NSLog(@"##### 热更新完成 下次启动使用最新程序 ####");
                        NSLog(@"\n zipPath  \n %@ \n\n",zipPath);
                    }
                }
                else
                {
                    NSLog(@"Error saving file %@",error);
                }
            }
            else
            {
                NSLog(@"Error downloading zip file: %@", error);
            }
        }
    });
    
}
+(NSString *)filterHtmlMarkWithContent:(NSString *)content{
    NSRegularExpression *regularExpretion = [NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|/n" options:0 error:nil];
    content = [regularExpretion stringByReplacingMatchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length) withTemplate:@""];
    return content;
}


#pragma mark - 用户引导界面
-(void)showGuideViews
{
    NSString *oldVersion = [[NSUserDefaults standardUserDefaults]objectForKey:kUserDefault_Version];
    //        NSUserDefaults中没有储存版本号 或者版本号跟当前版本号不一致 则显示 引导页面
    if (oldVersion == nil || ![oldVersion isEqual:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]) {
        
    }else{
        return;
    }
    NSInteger pageNum = 5;
    guideScrollView = [[UIScrollView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    guideScrollView.contentSize = CGSizeMake(IPHONEWIDTH * pageNum, IPHONEHEIGHT);
    guideScrollView.delegate = self;
    guideScrollView.backgroundColor = [UIColor redColor];
    guideScrollView.showsHorizontalScrollIndicator = NO;
    guideScrollView.pagingEnabled = YES;
    
    UIButton *gonow = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSString *widthStr = @"";
    if (IPHONESCREEN3p5) {
        widthStr = @"guide_3_5";
        [gonow setFrame:CGRectMake(0, 0, 135, 40)];
        [gonow setCenter:CGPointMake(IPHONEWIDTH/2, IPHONEHEIGHT - 65)];
    }else if (IPHONESCREEN4){
        widthStr = @"guide_4_0";
        [gonow setFrame:CGRectMake(0, 0, 135, 40)];
        [gonow setCenter:CGPointMake(IPHONEWIDTH/2, IPHONEHEIGHT - 65)];
    }else if (IPHONESCREEN4p7){
        widthStr = @"guide_4_7";
        [gonow setFrame:CGRectMake(0, 0, 160, 60)];
        [gonow setCenter:CGPointMake(IPHONEWIDTH/2, IPHONEHEIGHT - 75)];
    }else if (IPHONESCREEN5p5){
        widthStr = @"guide_5_5";
        [gonow setFrame:CGRectMake(0, 0, 180, 60)];
        [gonow setCenter:CGPointMake(IPHONEWIDTH/2, IPHONEHEIGHT - 85)];
    }
    
    [gonow setBackgroundColor:[UIColor clearColor]];
    
    [gonow addTarget:self action:@selector(hiddenGuideView) forControlEvents:UIControlEventTouchUpInside];
    
    for (int i = 0; i < pageNum; i ++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(IPHONEWIDTH * i, 0, IPHONEWIDTH, IPHONEHEIGHT)];
        [imgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_%d.jpg",widthStr,i+1]]];
        imgView.userInteractionEnabled = YES;
        if (i == pageNum - 1 ) {
            [imgView addSubview:gonow];
        }
        [guideScrollView addSubview:imgView];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:guideScrollView];
}

-(void)hiddenGuideView
{
    [[NSUserDefaults standardUserDefaults] setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:kUserDefault_Version];
    [UIView animateWithDuration:0.8 animations:^{
        [guideScrollView setTransform:CGAffineTransformMakeScale(1.3, 1.3)];
        guideScrollView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [guideScrollView removeFromSuperview];
    }];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:guideScrollView]) {
        if (guideScrollView.contentOffset.x < IPHONEWIDTH) {
            [guideScrollView setBackgroundColor:[UIColor  WY_ColorWithHex:0xe54835]];
        }else{
            [guideScrollView setBackgroundColor:[UIColor WY_ColorWithHex:0x7d58ca]];
        }
    }
}

@end
