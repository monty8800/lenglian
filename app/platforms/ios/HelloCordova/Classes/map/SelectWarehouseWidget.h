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
-(void) selectWarehouse:(NSString *) warehouseId goods:(NSString *) goodsId;

@end

@interface SelectWarehouseWidget : UIView<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tabView;
    UIButton *_closeBtn;
}

@property (strong, nonatomic) NSArray *dataList;
@property (weak, nonatomic) id<SelectWarehouseDelegate> delegate;
@property (strong, nonatomic) NSString *warehouseId;

+(void) show:(id<SelectWarehouseDelegate>) delegate warehouseId:(NSString *) warehouseId;

@end
