//
//  SelectWarehouseWidget.h
//  HelloCordova
//
//  Created by ywen on 15/10/2.
//
//

#import <UIKit/UIKit.h>
#import "SelectWarehouseTableViewCell.h"

@protocol SelectWarehouseDelegate <NSObject>

@required
-(void) selectWarehouse:(NSDictionary *) warehouse;

@end

@interface SelectWarehouseWidget : UIView<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tabView;
}

@property (strong, nonatomic) NSArray *dataList;
@property (weak, nonatomic) id<SelectWarehouseDelegate> delegate;

+(void) show;

@end
