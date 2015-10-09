//
//  UIImageView+XE.h
//  HelloCordova
//
//  Created by ywen on 15/10/9.
//
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    s250x250,
    s200x200,
    s130x130,
    s100x100,
    s80x80,
    s60x60,
} ImageSize;

typedef enum : NSUInteger {
    Avatar,
    Car,
    Goods,
    Warehouse,
} ImageType;

@interface UIImageView (XE)

-(void) XE_setImage:(NSString *) url size:(ImageSize) size type:(ImageType) type;

@end
