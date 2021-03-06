//
//  Net.m
//  HelloCordova
//
//  Created by ywen on 15/9/30.
//
//

#import "Net.h"
#import "Global.h"

@implementation Net

+(void)postFile:(NSString *)api params:(NSDictionary *)params files:(NSArray *)files cb:(SimpleNetHandler)cb
{
    DDLogDebug(@"post file params %@, files %@", params, files);
    YwenNetworkit *network = [Global sharedInstance].netEngine;
    NSMutableArray *newFiles = [NSMutableArray new];
    for (NSDictionary *file in files) {
        if ([file isKindOfClass:[NSNull class]]) {
            return;
        }
        NSString *originPath = [file objectForKey:@"path"];
        if ([originPath length] > 0) {

            NSArray *paths = [originPath componentsSeparatedByString:@"|"];
            NSString *path;
            if (paths.count > 1) {
                path = [AUTH_PIC_FOLDER stringByAppendingPathComponent: paths[0]];
            }
            else
            {
                path = originPath;
            }
            DDLogDebug(@"path is -----%@", path);
            
            [newFiles addObject:@{
                                  @"filed": [file objectForKey:@"filed"],
                                  @"name": @"foo.jpg",
                                  @"file": path
                                      }];
        }
       
    }
    
    [[Global sharedInstance] show:@"正在上传，请稍候..." force:YES];
    
    [network post:api params:params files:newFiles success:^(NSData *data) {
        [[Global sharedInstance] hide];
        //解析外层json
        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //除了dictionary类型，其他都是不正确的
        if ([result isKindOfClass:[NSDictionary class]]) {
            if (cb) {
                cb((NSDictionary *) result);
            }

        }
        else
        {
            DDLogError(@"server %@ response is not a dictionary", api);
#ifdef DEBUG
            [[Global sharedInstance] showErr :[NSString stringWithFormat:@"服务器异常\n%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]];
#endif
        }
    } err:^(NSError *error) {
        [[Global sharedInstance] hide];
        [[Global sharedInstance] showErr:@"网络出错，请检查网络设置"];
    }];
    
//    MKNetworkEngine *engine = [Global sharedInstance].netEngine;
//    MKNetworkOperation *op = [[MKNetworkOperation alloc] initWithURLString:api params:params httpMethod:@"POST"];
//    [op addData:[[NSData alloc] init] forKey:@"dummy-data"];
//    for (NSDictionary *file in files) {
//        if ([file isKindOfClass:[NSNull class]]) {
//            return;
//        }
//        NSString *originPath = [file objectForKey:@"path"];
//        if ([originPath length] > 0) {
//            
//            NSArray *paths = [originPath componentsSeparatedByString:@"|"];
//            NSString *path;
//            if (paths.count > 1) {
//                path = [AUTH_PIC_FOLDER stringByAppendingPathComponent: paths[0]];
//            }
//            else
//            {
//                path = originPath;
//            }
//            DDLogDebug(@"path is -----%@", path);
//            [op addFile:path forKey:[file objectForKey:@"filed"]];
//        }
//    }
//    
//    
//    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
//        [[Global sharedInstance] hide];
//        //解析外层json
//        id result = [NSJSONSerialization JSONObjectWithData:[completedOperation responseData] options:NSJSONReadingMutableContainers error:nil];
//        //除了dictionary类型，其他都是不正确的
//        if ([result isKindOfClass:[NSDictionary class]]) {
//            if (cb) {
//                cb((NSDictionary *) result);
//            }
//            
//        }
//        else
//        {
//            DDLogError(@"server %@ response is not a dictionary", completedOperation.url);
//#ifdef DEBUG
//            [[Global sharedInstance] showErr :[NSString stringWithFormat:@"服务器异常\n%@", [completedOperation responseString]]];
//#endif
//        }
//    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//        [[Global sharedInstance] hide];
//        [[Global sharedInstance] showErr:@"网络出错，请检查网络设置"];
//    }];
//    [[Global sharedInstance] show:@"正在上传，请稍候..." force:YES];
//    [engine enqueueOperation:op forceReload:YES];
}

+(void)post:(NSString *)api params:(NSDictionary *)params cb:(SimpleNetHandler)cb loading:(BOOL)loading {
    NSString *userId = [[Global getUser] objectForKey:@"id"];
    if (userId == nil) {
        userId = @"";
    }
    
    NSString *data = [params WY_ToJson];
    
    NSString *plainText = [NSString stringWithFormat:@"%@%@%@%@", [Global sharedInstance].uuid, TOKEN, data, CLIENT_TYPE];
    NSString *sign = [[plainText WY_MD5] lowercaseString];
    

    
    YwenNetworkit *engine = [Global sharedInstance].netEngine;
    
    NSDictionary *newParams = @{
                             @"uuid": [Global sharedInstance].uuid,
                             @"version": [Global sharedInstance].version,
                             @"client_type": CLIENT_TYPE,
                             @"userId": userId,
                             @"data": data,
                             @"sign": sign
                             };
    
    if (loading == YES) {
        [[Global sharedInstance] show:@"正在请求，请稍候..." force:YES];
    }

    [engine post:api params:newParams contentType:FORM success:^(NSData *data) {
        if (loading == YES) {
            [[Global sharedInstance] hide];
        }
        
        //解析外层json
        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //除了dictionary类型，其他都是不正确的
        if ([result isKindOfClass:[NSDictionary class]]) {
            if (cb) {
                cb((NSDictionary *) result);
            }
            
        }
        else
        {
            DDLogError(@"server %@ response is not a dictionary", api);
#ifdef DEBUG
            [[Global sharedInstance] showErr :[NSString stringWithFormat:@"服务器异常\n%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]];
#endif
        }

    } err:^(NSError *error) {
        [[Global sharedInstance] hide];
        [[Global sharedInstance] showErr:@"网络出错，请检查网络设置"];
    }];
    
//    MKNetworkOperation *op = [[MKNetworkOperation alloc] initWithURLString:api params:@{
//                                                                                        @"uuid": [Global sharedInstance].uuid,
//                                                                                        @"version": [Global sharedInstance].version,
//                                                                                        @"client_type": CLIENT_TYPE,
//                                                                                        @"userId": userId,
//                                                                                        @"data": data,
//                                                                                        @"sign": sign
//                                                                                        } httpMethod:@"POST"];
//
//    
//    DDLogDebug(@"请求接口%@, 参数%@", api, op);
//    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
//        if (loading == YES) {
//            [[Global sharedInstance] hide];
//        }
//        
//        //解析外层json
//        id result = [NSJSONSerialization JSONObjectWithData:[completedOperation responseData] options:NSJSONReadingMutableContainers error:nil];
//        //除了dictionary类型，其他都是不正确的
//        if ([result isKindOfClass:[NSDictionary class]]) {
//            if (cb) {
//                cb((NSDictionary *) result);
//            }
//            
//        }
//        else
//        {
//            DDLogError(@"server %@ response is not a dictionary", completedOperation.url);
//#ifdef DEBUG
//            [[Global sharedInstance] showErr :[NSString stringWithFormat:@"服务器异常\n%@", [completedOperation responseString]]];
//#endif
//        }
//    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//        [[Global sharedInstance] hide];
//        [[Global sharedInstance] showErr:@"网络出错，请检查网络设置"];
//    }];
//    if (loading == YES) {
//        [[Global sharedInstance] show:@"正在请求，请稍候..." force:YES];
//    }
//    
//    [engine enqueueOperation:op forceReload:YES];
}

@end
