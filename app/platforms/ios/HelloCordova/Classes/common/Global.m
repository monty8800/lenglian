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


-(void)hide {
    DDLogDebug(@"hide loading");
    [Loading hide];
}

@end
