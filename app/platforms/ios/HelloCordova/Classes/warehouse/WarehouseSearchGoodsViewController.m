//
//  WarehouseSearchGoodsViewController.m
//  HelloCordova
//
//  Created by YYQ on 15/9/24.
//
//

#import "WarehouseSearchGoodsViewController.h"
#import "SearchGoodsDetailViewController.h"
#import "Net.h"

@interface WarehouseSearchGoodsViewController ()

@end

@implementation WarehouseSearchGoodsViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"warehouseSearchGoods.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

-(void) createUI {
    self.title = @"我要找货";
    UIButton *addWarehouseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addWarehouseButton setFrame:CGRectMake(0, 0, 40, 44)];
    [addWarehouseButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [addWarehouseButton setTitle:@"搜索" forState:UIControlStateNormal];
    [addWarehouseButton addTarget:self action:@selector(sureToSearch) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addWarehouseButton];
}
-(void)sureToSearch{
    NSString *js = [NSString stringWithFormat:@"(function(){window.doWarehouseSearchGoods()})()"];
    [self.commandDelegate evalJs: js];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)commonCommand:(NSArray *)params{
    [super commonCommand:params];
    if ([params[0] integerValue] == 1) {
        if ([params[1] isEqualToString:@"searchGoodsDetail"]) {
            SearchGoodsDetailViewController *searchGoodsVC = [SearchGoodsDetailViewController new];
            [self.navigationController pushViewController:searchGoodsVC animated:YES];
        }
    }
    else if ([params[0] integerValue] == 3) {
        if ([params[1] isEqualToString:@"select:warehouse"]) {
            [SelectGoodsWidget show:self goods:params[2] type:Warehouses];
        }
    }
}


-(void)selectGoods:(NSString *)goodsId warehouse:(NSString *)warehouseId
{
    NSDictionary *params = @{
                             @"userId": [[Global getUser] objectForKey:@"id"],
                             @"warehouseId": warehouseId,
                             @"orderGoodsId": goodsId
                             };
    [Net post:ORDER_WAREHOUSE_SELECT_GOODS params:params cb:^(NSDictionary *responseDic) {
        DDLogDebug(@"goods select car result %@", responseDic);
        if ([[responseDic objectForKey:@"code"] isEqualToString:@"0000"]) {
            [[Global sharedInstance] showSuccess:@"抢单成功！"];
        }
        else
        {
            [[Global sharedInstance] showErr:[responseDic objectForKey:@"msg"]];
        }
    } loading:YES];
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
