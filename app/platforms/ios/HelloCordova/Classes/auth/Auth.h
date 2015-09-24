//
//  Auth.h
//  HelloCordova
//
//  Created by ywen on 15/9/23.
//
//

#import <Foundation/Foundation.h>
#import <MKNetworkKit.h>

typedef void (^SimpleNetHandler)(NSDictionary *responseDic);

@interface Auth : NSObject

+(void) auth:(NSString *) api params:(NSDictionary *) params files:(NSArray *) files cb:(SimpleNetHandler) cb;

@end
