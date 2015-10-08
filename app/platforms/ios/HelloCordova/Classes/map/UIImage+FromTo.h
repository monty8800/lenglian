//
//  UIImage+FromTo.h
//  HelloCordova
//
//  Created by ywen on 15/10/8.
//
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TOP,
    BOTH,
    BOTTOM,
} LineDirection;

@interface UIImage (FromTo)

-(UIImage *) addLine:(LineDirection) direction length:(CGFloat) length color:(UIColor *)color;

@end
