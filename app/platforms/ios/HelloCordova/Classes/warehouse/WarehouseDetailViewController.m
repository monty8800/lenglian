//
//  WarehouseDetailViewController.m
//  HelloCordova
//
//  Created by YYQ on 15/9/29.
//
//

#import "WarehouseDetailViewController.h"

@interface WarehouseDetailViewController ()

@end

@implementation WarehouseDetailViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"warehouseDetail.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

-(void) createUI {
    self.title = @"仓库详情";
    UIButton *editWarehouseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editWarehouseButton setFrame:CGRectMake(0, 0, 80, 44)];
    [editWarehouseButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [editWarehouseButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editWarehouseButton addTarget:self action:@selector(editWarehouse) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:editWarehouseButton];
}
-(void)editWarehouse{
    [self.commandDelegate evalJs:@"startEditWarehouse()"];
}
-(void)commonCommand:(NSArray *)params{
    [super commonCommand:params];

    
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
