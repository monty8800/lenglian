//
//  XeBubbleView.h
//  HelloCordova
//
//  Created by ywen on 15/10/1.
//
//

#import <UIKit/UIKit.h>

@interface XeBubbleView : UIView
{
    UIButton *_btn;
}

@property (strong, nonatomic) NSDictionary *data;

-(void) clickBtn;
-(void) createUI;

@end
