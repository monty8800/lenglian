//
//  SelectCarWidget.h
//  HelloCordova
//
//  Created by ywen on 15/10/3.
//
//

#import <UIKit/UIKit.h>

@protocol SelectCarDelegate <NSObject>

@required
-(void) selectCar:(NSString *) carId goods:(NSString *) goodsId;

@end

@interface SelectCarWidget : UIView<UITableViewDataSource, UITableViewDelegate>
{
    UIView *_commonView;
    UITableView *_tabView;
    UIButton *_closeBtn;
    UIButton *_sureBtn;

}
@property (nonatomic,assign) NSInteger selectedIndex;

@property (strong, nonatomic) NSArray *dataList;
@property (weak, nonatomic) id<SelectCarDelegate> delegate;
@property (strong, nonatomic) NSString *carId;


+(void) show:(id<SelectCarDelegate>) delegate carId:(NSString *) carId;


@end
