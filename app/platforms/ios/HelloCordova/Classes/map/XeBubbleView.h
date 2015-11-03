//
//  XeBubbleView.h
//  HelloCordova
//
//  Created by ywen on 15/10/1.
//
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CarAuth,
    GoodsAuth,
    WarehouseAuth,
} AuthType;

typedef void (^AuthCb)();

@interface XeBubbleView : UIView
{
    UIButton *_btn;
}

@property (strong, nonatomic) NSDictionary *data;

-(void) clickBtn;
-(void) createUI;

-(void) checkAuth:(AuthType) type cb:(AuthCb) cb;

@end
