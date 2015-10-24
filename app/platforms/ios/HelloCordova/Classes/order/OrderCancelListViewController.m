//
//  OrderCancelListViewController.m
//  HelloCordova
//
//  Created by ywen on 15/10/13.
//
//

#import "OrderCancelListViewController.h"

#import "AppDelegate.h"
#import "CarOrderDetailViewController.h"
#import "WarehouseOrderDetailViewController.h"
#import "GoodsOrderDetailViewController.h"
#import "OrderPayViewController.h"
#import "DoCommentViewController.h"

@interface OrderCancelListViewController ()

@end

@implementation OrderCancelListViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"orderCancelList.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

-(void) createUI {
    self.title = @"已取消订单";
}



-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [super webViewDidFinishLoad:webView];
    DDLogDebug(@"_show order type %d", (int)_showOrderType);
    if (_showOrderType == 0 || _showOrderType == 1 || _showOrderType == 2) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.commandDelegate evalJs:[NSString stringWithFormat:@"comeFromFlag(%d, %d)",(int)_showOrderType, 5]];
        });
        
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

//    NSString *js = @"(function(){window.updateStore()})()";
//    [self.commandDelegate evalJs: js];
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
