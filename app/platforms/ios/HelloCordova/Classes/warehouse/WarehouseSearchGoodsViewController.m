//
//  WarehouseSearchGoodsViewController.m
//  HelloCordova
//
//  Created by YYQ on 15/9/24.
//
//

#import "WarehouseSearchGoodsViewController.h"
#import "SearchGoodsDetailViewController.h"

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
    self.title = @"仓库找货";
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
            [SelectGoodsWidget show:self goods:params[2]];
        }
    }
}
-(void) selectGoods:(NSString *) goodsId car:(NSString *) carId{
    
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
