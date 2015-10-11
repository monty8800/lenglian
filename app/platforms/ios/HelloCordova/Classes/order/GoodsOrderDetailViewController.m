//
//  GoodsOrderDetailViewController.m
//  HelloCordova
//
//  Created by ywen on 15/10/11.
//
//

#import "GoodsOrderDetailViewController.h"

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
