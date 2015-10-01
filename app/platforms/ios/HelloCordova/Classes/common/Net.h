//
//  Net.h
//  HelloCordova
//
//  Created by ywen on 15/9/30.
//
//

#import <Foundation/Foundation.h>

typedef void (^SimpleNetHandler)(NSDictionary *responseDic);

@interface Net : NSObject

+(void) postFile:(NSString *) api params:(NSDictionary *) params files:(NSArray *) files cb:(SimpleNetHandler) cb;

+(void) post:(NSString *)api params:(NSDictionary *)params cb:(SimpleNetHandler)cb;

@end
