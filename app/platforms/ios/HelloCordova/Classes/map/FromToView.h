//
//  FromToView.h
//  HelloCordova
//
//  Created by ywen on 15/10/2.
//
//

#import <UIKit/UIKit.h>
#import "FromToTableViewCell.h"

@interface FromToView : UIView<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tabView;
    CGFloat _cellHeight;
}

@property (strong, nonatomic) NSArray *addressList;

@end
