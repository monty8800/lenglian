//
//  OrderListViewController.m
//  HelloCordova
//
//  Created by ywen on 15/9/21.
//
//

#import "OrderListViewController.h"
#import "AppDelegate.h"
#import "CarOrderDetailViewController.h"
#import "WarehouseOrderDetailViewController.h"
#import "GoodsOrderDetailViewController.h"
#import "OrderPayViewController.h"
#import "DoCommentViewController.h"
#import "OrderCancelListViewController.h"

@interface OrderListViewController ()
@property (assign,nonatomic)NSInteger showOrderType;
@property (assign,nonatomic)BOOL isLoaded;
@end

@implementation OrderListViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"orderList.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    
}

-(void) createUI {
    self.title = @"订单";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"已取消" style:UIBarButtonItemStylePlain target:self action:@selector(goCancelList)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

-(void) goCancelList {
    OrderCancelListViewController *cancelListVC = [OrderCancelListViewController new];
    cancelListVC.hidesBottomBarWhenPushed = YES;
    cancelListVC.showOrderType = _showOrderType;
    [self.navigationController pushViewController:cancelListVC animated:YES];
}

-(void)showWithType:(NSInteger )type{
    NSLog(@"_______%d",(int)type);
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.orderVCLoaded) {
        _showOrderType = -1;
        [self.commandDelegate evalJs:[NSString stringWithFormat:@"comeFromFlag(%d)",(int)type]];
    }else{
        _showOrderType = type;
    }
#if DEBUG
    if (type == 0) {
        self.title = @"货主订单";
    }else if (type == 1){
        self.title = @"司机订单";
    }else if (type == 2){
        self.title = @"仓库订单";
    }
#endif

}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [super webViewDidFinishLoad:webView];
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.orderVCLoaded) {
        return;
    }
    if (_showOrderType == 0 || _showOrderType == 1 || _showOrderType == 2) {
        [self.commandDelegate evalJs:[NSString stringWithFormat:@"comeFromFlag(%d)",(int)_showOrderType]];
    }
    appdelegate.orderVCLoaded = YES;
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
        else if ([params[1] isEqualToString:@"orderPay"])
        {
            OrderPayViewController *payVC = [OrderPayViewController new];
            [self.navigationController pushViewController:payVC animated:YES];
        }
        else if ([params[1] isEqualToString:@"doComment"])
        {
            DoCommentViewController *commentVC = [DoCommentViewController new];
            [self.navigationController pushViewController:commentVC animated:YES];
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
