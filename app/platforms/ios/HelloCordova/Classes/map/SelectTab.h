//
//  SelectTab.h
//  HelloCordova
//
//  Created by ywen on 15/9/22.
//
//

#import <UIKit/UIKit.h>

@protocol SelectTabProtocl <NSObject>

@required
-(void) selectTab:(NSInteger) index;

@end

@interface SelectTab : UIView
{
    UIButton *_selectTab;
    UIView *_tabLine;
    NSLayoutConstraint *_linePosition;
}

@property (strong, nonatomic) NSArray *tabs;
@property (weak, nonatomic) id<SelectTabProtocl> delegate;

@end
