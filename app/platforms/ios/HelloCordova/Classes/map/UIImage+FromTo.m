//
//  UIImage+FromTo.m
//  HelloCordova
//
//  Created by ywen on 15/10/8.
//
//

#import "UIImage+FromTo.h"

@implementation UIImage (FromTo)

-(UIImage *)addLine:(LineDirection)direction length:(CGFloat)length color:(UIColor *)color
{
    CGSize size = CGSizeMake(self.size.width, self.size.height + length);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 1);
    
    //设置颜色
    [color setStroke];
    //开始一个起始路径
    CGContextBeginPath(context);
    
    CGRect rect;

    switch (direction) {
        case TOP:
        {
            rect = CGRectMake(0, length, self.size.width, self.size.height);
            //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
            CGContextMoveToPoint(context, self.size.width / 2, 0);
            
            //设置下一个坐标点
            CGContextAddLineToPoint(context, self.size.width / 2, length);
        }
            
            break;
            
        case BOTTOM:
        {
            rect = CGRectMake(0, 0, self.size.width, self.size.height);
            //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
            CGContextMoveToPoint(context, self.size.width / 2, self.size.height);
            
            //设置下一个坐标点
            CGContextAddLineToPoint(context, self.size.width / 2, self.size.height + length);
        }
            
            break;
            
        case BOTH:
        {
            rect = CGRectMake(0, length / 2, self.size.width, self.size.height);
            //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
            CGContextMoveToPoint(context, self.size.width / 2, 0);
            
            //设置下一个坐标点
            CGContextAddLineToPoint(context, self.size.width / 2, length / 2);
            
            //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
            CGContextMoveToPoint(context, self.size.width / 2, self.size.height + length / 2);
            
            //设置下一个坐标点
            CGContextAddLineToPoint(context, self.size.width / 2, length + self.size.height);
            
        }
            
            break;
            
        default:
            break;
    }
    
    

   
    
    
    CGContextStrokePath(context);
    
    [self drawInRect:rect];
    
    
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

@end
