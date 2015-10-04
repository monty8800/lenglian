//
//  SelectGoodsWidget.h
//  HelloCordova
//
//  Created by ywen on 15/10/4.
//
//

#import <UIKit/UIKit.h>
#import "SelectGoodsTableViewCell.h"

@protocol SelectGoodsDelegate <NSObject>

@required
-(void) selectGoods:(NSString *) goodsId car:(NSString *) carId;

@end

@interface SelectGoodsWidget : UIView <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tabView;

    UIButton *_closeBtn;
}

@property (strong, nonatomic) NSArray *dataList;
@property (weak, nonatomic) id<SelectGoodsDelegate> delegate;
@property (strong, nonatomic) NSString *goodsId;


+(void) show:(id<SelectGoodsDelegate>) delegate goods:(NSString *) goodsId;



@end
