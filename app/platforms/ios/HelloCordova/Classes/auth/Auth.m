//
//  Auth.m
//  HelloCordova
//
//  Created by ywen on 15/9/23.
//
//

#import "Auth.h"
#import "Global.h"

@implementation Auth

+(void)auth:(NSString *)api params:(NSDictionary *)params files:(NSArray *)files cb:(SimpleNetHandler)cb {
    MKNetworkEngine *engine = [Global sharedInstance].netEngine;
    MKNetworkOperation *op = [[MKNetworkOperation alloc] initWithURLString:api params:nil httpMethod:@"POST"];
    for (NSDictionary *file in files) {
        if ([[file objectForKey:@"path"] length] > 0) {
            [op addFile:[file objectForKey:@"path"] forKey:[file objectForKey:@"filed"]];
        }
    }
    
    [op addParams:params];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [[Global sharedInstance] hide];
        //解析外层json
        id result = [NSJSONSerialization JSONObjectWithData:[completedOperation responseData] options:NSJSONReadingMutableContainers error:nil];
        //除了dictionary类型，其他都是不正确的
        if ([result isKindOfClass:[NSDictionary class]]) {
            if (cb) {
                cb((NSDictionary *) result);
            }
            
        }
        else
        {
            DDLogError(@"server %@ response is not a dictionary", completedOperation.url);
#ifdef DEBUG
            [[Global sharedInstance] showErr :[NSString stringWithFormat:@"服务器异常\n%@", [completedOperation responseString]]];
#endif
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [[Global sharedInstance] hide];
        [[Global sharedInstance] showErr:@"网络出错，请检查网络设置"];
    }];
    [[Global sharedInstance] show:@"正在上传，请稍候..." force:YES];
    [engine enqueueOperation:op forceReload:YES];
}

@end
