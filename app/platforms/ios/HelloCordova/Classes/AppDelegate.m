/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  AppDelegate.m
//  HelloCordova
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "AppDelegate.h"

#import "Global.h"
#import "LoginViewController.h"
#import "hello/HelloViewController.h"
#import "home/HomeViewController.h"
#import "map/NearByViewController.h"
#import "order/OrderListViewController.h"
#import "user/UserCenterViewController.h"
#import "LoginViewController.h"
#import <Cordova/CDVPlugin.h>
@interface AppDelegate ()
{
    BOOL _orderVCShouldLoad;
    UIView *_alphaView;
    UIImageView *_menuView;
    NSInteger _orderMenuSelIndex;
}

@end
@implementation AppDelegate


- (id)init
{
    /** If you need to do any extra app-specific initialization, you can do it here
     *  -jm
     **/
    NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

    int cacheSizeMemory = 8 * 1024 * 1024; // 8MB
    int cacheSizeDisk = 32 * 1024 * 1024; // 32MB
#if __has_feature(objc_arc)
        NSURLCache* sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
#else
        NSURLCache* sharedCache = [[[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"] autorelease];
#endif
    [NSURLCache setSharedURLCache:sharedCache];

    self = [super init];
    return self;
}

#pragma mark UIApplicationDelegate implementation

/**
 * This is main kick off after the app inits, the views and Settings are setup here. (preferred - iOS4 and up)
 */
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    //MARK:  初始化
    [Global setUpLogger];
    
    [Global setupBaiduMap];
    
    [Global setUpUmeng];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];

#if __has_feature(objc_arc)
        self.window = [[UIWindow alloc] initWithFrame:screenBounds];
#else
        self.window = [[[UIWindow alloc] initWithFrame:screenBounds] autorelease];
#endif
    self.window.autoresizesSubviews = YES;



    // Set your app's start page by setting the <content src='foo.html' /> tag in config.xml.
    // If necessary, uncomment the line below to override it.
    // self.viewController.startPage = @"index.html";

    // NOTE: To customize the view's frame size (which defaults to full screen), override
    // [self.viewController viewWillAppear:] in your view controller.
    _tabVC = [UITabBarController new];
    _tabVC.delegate = self;
    
    //首页
    HomeViewController *homeVC = [HomeViewController new];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[[UIImage imageNamed:@"tab_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"tab_home_hl"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [homeNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor WY_ColorWithHex:0x28b3ec]} forState:UIControlStateHighlighted];
    
    //附近
    NearByViewController *nearByVC = [NearByViewController new];
    UINavigationController *nearByNav = [[UINavigationController alloc] initWithRootViewController:nearByVC];
    nearByNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"附近" image:[[UIImage imageNamed:@"tab_nearby"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"tab_nearby_hl"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [nearByNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor WY_ColorWithHex:0x28b3ec]} forState:UIControlStateHighlighted];
    
    //订单
    OrderListViewController *orderListVC = [OrderListViewController new];
    UINavigationController *orderListNav = [[UINavigationController alloc] initWithRootViewController:orderListVC];
    orderListNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"订单" image:[[UIImage imageNamed:@"tab_order"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"tab_order_hl"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [orderListNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor WY_ColorWithHex:0x28b3ec]} forState:UIControlStateHighlighted];
    
    //我的
    UserCenterViewController *userCenterVC = [UserCenterViewController new];
    UINavigationController *userCenterNav = [[UINavigationController alloc] initWithRootViewController:userCenterVC];
    userCenterNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"tab_user"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"tab_user_hl"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [userCenterNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor WY_ColorWithHex:0x28b3ec]} forState:UIControlStateHighlighted];
    
    _tabVC.viewControllers = @[homeNav, nearByNav, orderListNav, userCenterNav];
    _tabVC.tabBar.backgroundColor = [UIColor WY_ColorWithHex:0xf8f8f8];
    
    self.window.rootViewController = _tabVC;
    
    [Global sharedInstance].tabVC = _tabVC;
    
    [Global sharedInstance].mapVC = nearByVC;
    
    //hello world
    //self.window.rootViewController = [HelloViewController new];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(findNewVersion:) name:@"Notification_findNewVersion" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogout) name:@"Notification_user_logout" object:nil];
    [self.window makeKeyAndVisible];
    [[Global sharedInstance] showGuideViews];

    return YES;
}

// this happens while we are running ( in the background, or from within our own app )
// only valid if HelloCordova-Info.plist specifies a protocol to handle
- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation
{
    if (!url) {
        return NO;
    }

    // all plugins will get the notification, and their handlers will be called
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CDVPluginHandleOpenURLNotification object:url]];

    return YES;
}

// repost all remote and local notification using the default NSNotificationCenter so multiple plugins may respond
- (void)            application:(UIApplication*)application
    didReceiveLocalNotification:(UILocalNotification*)notification
{
    // re-post ( broadcast )
    [[NSNotificationCenter defaultCenter] postNotificationName:CDVLocalNotification object:notification];
}

#ifndef DISABLE_PUSH_NOTIFICATIONS

    - (void)                                 application:(UIApplication*)application
        didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
    {
        // re-post ( broadcast )
        NSString* token = [[[[deviceToken description]
            stringByReplacingOccurrencesOfString:@"<" withString:@""]
            stringByReplacingOccurrencesOfString:@">" withString:@""]
            stringByReplacingOccurrencesOfString:@" " withString:@""];

        [[NSNotificationCenter defaultCenter] postNotificationName:CDVRemoteNotification object:token];
    }

    - (void)                                 application:(UIApplication*)application
        didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
    {
        // re-post ( broadcast )
        [[NSNotificationCenter defaultCenter] postNotificationName:CDVRemoteNotificationError object:error];
    }
#endif
- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

#pragma mark - handle orderMenu

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (viewController == [tabBarController.viewControllers objectAtIndex:0] || viewController == [tabBarController.viewControllers objectAtIndex:1] || viewController == [tabBarController.viewControllers objectAtIndex:3]){
        [self hideOrderMenu];
        return YES;
    }else{
        
    }
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"user"];

    if ([tabBarController.viewControllers[tabBarController.selectedIndex] isEqual:viewController] && tabBarController.selectedIndex == 2) {
        if (!_alphaView) {
            [self showOrderMenu];
        }else{
            [self hideOrderMenu];
        }
        return YES;
    }
    
    if (viewController == [tabBarController.viewControllers objectAtIndex:2]){
        if (!userDic) {
            LoginViewController *loginVC = [LoginViewController new];
            UINavigationController *currentNav = (UINavigationController *)tabBarController.viewControllers[tabBarController.selectedIndex];
            loginVC.hidesBottomBarWhenPushed = YES;
            [currentNav pushViewController:loginVC animated:YES];
            return NO;
        }
        if (_orderVCShouldLoad) {
            if (_alphaView) {
                [self hideOrderMenu];
            }else{
                if (!_orderVCLoaded) {
                    [self showOrderMenu];
                }
            }
            return YES;
        }else{
            if (_alphaView) {
                [self hideOrderMenu];
            }else{
                _orderMenuSelIndex = -1;
                [self showOrderMenu];
            }
            return NO;
        }
    }else {
        [self hideOrderMenu];
        return YES;
    }
}

-(void)hideOrderMenu{
    if (_alphaView) {
        [_menuView removeFromSuperview];
        _menuView = nil;
        [_alphaView removeFromSuperview];
        _alphaView = nil;
    }
}
-(void)showOrderMenu{
    if (!_alphaView) {
        _alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
        [_alphaView setBackgroundColor:[UIColor clearColor]];
        [_alphaView setAlpha:0.5];
        [self.window addSubview:_alphaView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideOrderMenu)];
        [_alphaView addGestureRecognizer:tap];
        _menuView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 75, 136)];
        [_menuView setCenter:CGPointMake(SCREEN_WIDTH * 5 / 8, SCREEN_HEIGHT - 49 - _menuView.frame.size.height/2)];
        [_menuView setImage:[UIImage imageNamed:@"pop_bg"]];
        [_menuView setUserInteractionEnabled:YES];
        [self.window addSubview:_menuView];
        NSArray *titleArr = @[@"货主",@"司机",@"仓库"];
        CGFloat perH = (_menuView.frame.size.height - 5)/3;
        for (int i = 0; i < 3; i ++) {
            UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [menuBtn setFrame:CGRectMake(0, perH * i, _menuView.frame.size.width, perH)];
            [menuBtn setTag:800 + i];
            [menuBtn setTitle:titleArr[i] forState:UIControlStateNormal];
            [menuBtn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [menuBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_menuView addSubview:menuBtn];
            if (i != 0) {
                UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(10, perH * i , _menuView.frame.size.width - 20, 1)];
                [sepLine setBackgroundColor:[UIColor grayColor]];
                [sepLine.layer setCornerRadius:0.5];
                [_menuView addSubview:sepLine];
            }
        }
        if (_orderMenuSelIndex > -1 && _orderMenuSelIndex < 3) {
            UIButton *selBtn = (UIButton *)[_menuView viewWithTag:800 + _orderMenuSelIndex];
            [selBtn setTitleColor:[UIColor WY_ColorWithHex:0x1987c6] forState:UIControlStateNormal];
        }
    }else{
        [_menuView removeFromSuperview];
        _menuView = nil;
        [_alphaView removeFromSuperview];
        _alphaView = nil;
    }
}

-(void)menuBtnClick:(UIButton *)btn{
    NSInteger index = btn.tag - 800;
    _orderMenuSelIndex = index;
    _orderVCShouldLoad = YES;
    [self.tabVC setSelectedIndex:2];
    OrderListViewController *orderVC = (OrderListViewController *)((UINavigationController *)self.tabVC.viewControllers[2]).topViewController;
    [orderVC showWithType:index];
    [self hideOrderMenu];
}
-(void)userLogout{
    _orderVCLoaded = NO;
    _orderVCShouldLoad = NO;
}
-(void)findNewVersion:(NSNotification *)notify{
    NSString *newVersionURL = notify.object[@"newVersionURL"];
    NSInteger len = [newVersionURL length];
    if (len < 1) {
        return;
    }
    UIViewController *vc = (UIViewController *)((UINavigationController *)((UITabBarController *)self.window.rootViewController).selectedViewController).topViewController;
    if ([notify.object[@"force"] integerValue] == 1) {
        [YwenAlert alert:@"发现新版本" vc:vc confirmStr:@"立即更新" confirmCb:^{
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:newVersionURL]];
            [self findNewVersion:notify];
        }];
    }else{
        [YwenAlert alert:@"发现新版本" vc:vc confirmStr:@"立即更新" confirmCb:^{
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:newVersionURL]];
        } cancelStr:@"取消" cancelCb:^{
            
        }];
    }
}

@end
