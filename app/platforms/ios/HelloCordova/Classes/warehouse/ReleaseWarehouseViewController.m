//
//  ReleaseWarehouseViewController.m
//  HelloCordova
//
//  Created by YYQ on 15/9/30.
//
//

#import "ReleaseWarehouseViewController.h"
#import "WarehouseDetailViewController.h"
#import "AddWarehouseViewController.h"
@interface ReleaseWarehouseViewController ()

@end

@implementation ReleaseWarehouseViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"releaseWarehouse.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}
-(void)createUI{
    self.title = @"发布库源";
    
    UIButton *addWarehouseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addWarehouseButton setFrame:CGRectMake(0, 0, 60, 44)];
    [addWarehouseButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [addWarehouseButton setTitle:@"新增仓库" forState:UIControlStateNormal];
    [addWarehouseButton addTarget:self action:@selector(addWarehouse) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addWarehouseButton];
}
-(void)addWarehouse{
    AddWarehouseViewController *addWarehouseVC = [AddWarehouseViewController new];
    [self.navigationController pushViewController:addWarehouseVC animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.commandDelegate evalJs:@"(function(){window.tryReloadWarehousList()})()"];
}
-(void)commonCommand:(NSArray *)params{
    [super commonCommand:params];
    if ([params[0] integerValue] == 1) {
        if ([params[1] isEqualToString:@"warehouseDetail"]) {
            WarehouseDetailViewController *warehouseDetailVC = [WarehouseDetailViewController new];
            [self.navigationController pushViewController:warehouseDetailVC animated:YES];
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
