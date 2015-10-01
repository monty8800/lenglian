//
//  XeAnnotation.h
//  HelloCordova
//
//  Created by ywen on 15/10/1.
//
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI/BMapKit.h>

@interface XeAnnotation : BMKPointAnnotation

@property (strong, nonatomic) NSDictionary *data;

@end
