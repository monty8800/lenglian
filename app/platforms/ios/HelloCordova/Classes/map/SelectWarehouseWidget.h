//
//  SelectWarehouseWidget.h
//  HelloCordova
//
//  Created by ywen on 15/10/2.
//
//

#import <UIKit/UIKit.h>
#import "SelectWarehouseTableViewCell.h"

@interface SelectWarehouseWidget : UIView<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tabView;
}

@property (strong, nonatomic) NSArray *dataList;

@end
