//
//  SelectGoodsWidget.h
//  HelloCordova
//
//  Created by ywen on 15/10/4.
//
//

#import <UIKit/UIKit.h>
#import "SelectGoodsTableViewCell.h"
#import "SelectWarehouseTableViewCell2.h"
typedef enum : NSUInteger {
    Cars,
    Warehouses,
} GoodsWidgetType;

@protocol SelectGoodsDelegate <NSObject>

@optional
-(void) selectGoods:(NSString *) goodsId car:(NSString *) carId;
-(void) selectGoods:(NSString *) goodsId warehouse:(NSString *) warehouseId;

@end

@interface SelectGoodsWidget : UIView <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tabView;

    UIButton *_closeBtn;

}

@property (strong, nonatomic) NSArray *dataList;
@property (weak, nonatomic) id<SelectGoodsDelegate> delegate;
@property (strong, nonatomic) NSString *goodsId;
@property (assign, nonatomic) GoodsWidgetType type;


+(void) show:(id<SelectGoodsDelegate>) delegate goods:(NSString *) goodsId type:(GoodsWidgetType) type;



@end
