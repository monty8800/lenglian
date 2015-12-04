//
//  MessageListViewController.m
//  HelloCordova
//
//  Created by ywen on 15/9/22.
//
//

#import "MessageListViewController.h"
#import "CarOrderDetailViewController.h"
#import "GoodsOrderDetailViewController.h"
#import "WarehouseOrderDetailViewController.h"
@interface MessageListViewController ()

@end

@implementation MessageListViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"messageList.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

-(void) createUI {
    self.title = @"我的消息";
}

-(void)commonCommand:(NSArray *)params {
    [super commonCommand:params];
    
    if ([params[0] integerValue] == 1) {
        if ([params[1] isEqualToString:@"carOwnerOrderDetail"]) {
            CarOrderDetailViewController *carOrderVC = [CarOrderDetailViewController new];
            carOrderVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:carOrderVC animated:YES];
        }
        else if ([params[1] isEqualToString:@"warehouseOrderDetail"])
        {
            WarehouseOrderDetailViewController *warehouseOrderDetailVC = [WarehouseOrderDetailViewController new];
            warehouseOrderDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:warehouseOrderDetailVC animated:YES];
        }
        else if ([params[1] isEqualToString:@"goodsOrderDetail"])
        {
            GoodsOrderDetailViewController *goodsOrderDetailVC = [GoodsOrderDetailViewController new];
            goodsOrderDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodsOrderDetailVC animated:YES];
        }
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
