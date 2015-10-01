//
//  XeAnnotationView.h
//  HelloCordova
//
//  Created by ywen on 15/10/1.
//
//

#import <BaiduMapAPI/BMapKit.h>

typedef enum : NSUInteger {
    CAR,
    GOODS,
    GOODS_NEED_WAREHOUSE,
    WAREHOUSE,
    POINT
} XeAnnoType;

@interface XeAnnotationView : BMKAnnotationView
{
    UIImageView *_imageView;
}

@property (assign, nonatomic) XeAnnoType type;
@property (strong, nonatomic) NSDictionary *data;


@end
