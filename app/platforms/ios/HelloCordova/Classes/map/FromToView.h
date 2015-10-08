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

}

@property (strong, nonatomic) NSArray *addressList;
@property (strong, nonatomic) UITableView *tabView;

@end
