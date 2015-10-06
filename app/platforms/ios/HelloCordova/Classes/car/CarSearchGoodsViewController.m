//
//  CarSearchGoodsViewController.m
//  HelloCordova
//
//  Created by YYQ on 15/10/5.
//
//

#import "CarSearchGoodsViewController.h"

@interface CarSearchGoodsViewController ()

@end

@implementation CarSearchGoodsViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"carFindGoods.html";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

-(void) createUI {
    self.title = @"司机找货";
    UIButton *addWarehouseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addWarehouseButton setFrame:CGRectMake(0, 0, 40, 44)];
    [addWarehouseButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [addWarehouseButton setTitle:@"搜索" forState:UIControlStateNormal];
    [addWarehouseButton addTarget:self action:@selector(sureToSearch) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addWarehouseButton];
}
-(void)sureToSearch{
    
}

-(void)commonCommand:(NSArray *)params {
    [super commonCommand:params];
    if ([params[0] integerValue] == 3) {
        if ([params [1] isEqualToString:@"order:car:select:goods:done"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            //TODO: 跳转到订单页面
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
