//
//  GoodsOrderDetailViewController.m
//  HelloCordova
//
//  Created by ywen on 15/10/11.
//
//

#import "GoodsOrderDetailViewController.h"
#import "OrderPayViewController.h"
#import "DoCommentViewController.h"
#import "CarOwnerDetailViewController.h"
#import "SearchWarehouseDetailViewController.h"
@interface GoodsOrderDetailViewController ()

@end

@implementation GoodsOrderDetailViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"goodsOrderDetail.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

-(void) createUI {
    self.title = @"货主订单详情";
}


-(void)commonCommand:(NSArray *)params {
    [super commonCommand:params];
    
    if ([params[0] integerValue] == 1) {
        if ([params[1] isEqualToString:@"orderPay"])
        {
            OrderPayViewController *payVC = [OrderPayViewController new];
            [self.navigationController pushViewController:payVC animated:YES];
        }
        else if ([params[1] isEqualToString:@"doComment"])
        {
            DoCommentViewController *commentVC = [DoCommentViewController new];
            [self.navigationController pushViewController:commentVC animated:YES];
        }
        else if ([params[1] isEqualToString:@"carOnwerDetail"])
        {
            CarOwnerDetailViewController *carOnwerDetailVC = [CarOwnerDetailViewController new];
            [self.navigationController pushViewController:carOnwerDetailVC animated:YES];
        }
        else if ([params[1] isEqualToString:@"warehouseOnwerDetail"])
        {
            SearchWarehouseDetailViewController *warehouseOwnerDetailVC = [SearchWarehouseDetailViewController new];
            [self.navigationController pushViewController:warehouseOwnerDetailVC animated:YES];
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
