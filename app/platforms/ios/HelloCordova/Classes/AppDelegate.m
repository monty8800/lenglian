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

#import "hello/HelloViewController.h"
#import "home/HomeViewController.h"
#import "map/NearByViewController.h"
#import "order/OrderListViewController.h"
#import "user/UserCenterViewController.h"

#import <Cordova/CDVPlugin.h>

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
    
    //hello world
    //self.window.rootViewController = [HelloViewController new];
    
    [self.window makeKeyAndVisible];

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

- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    // iPhone doesn't support upside down by default, while the iPad does.  Override to allow all orientations always, and let the root view controller decide what's allowed (the supported orientations mask gets intersected).
    NSUInteger supportedInterfaceOrientations = (1 << UIInterfaceOrientationPortrait);

    return supportedInterfaceOrientations;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
