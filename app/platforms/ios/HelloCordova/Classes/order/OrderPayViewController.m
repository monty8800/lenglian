//
//  OrderPayViewController.m
//  HelloCordova
//
//  Created by ywen on 15/10/11.
//
//

#import "OrderPayViewController.h"
#import "AddBankCardViewController.h"
#import "PaySuccessViewController.h"

@interface OrderPayViewController ()

@end

@implementation OrderPayViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"orderPay.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

-(void) createUI {
    self.title = @"支付订单";
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
//    [self.commandDelegate evalJs:@"(function(){window.updateStore()})()"];
}


-(void)commonCommand:(NSArray *)params {
    [super commonCommand:params];
    if ([params[0] integerValue] == 1) {
        if ([params[1] isEqualToString:@"addBankCard"]) {
            AddBankCardViewController *addVC = [AddBankCardViewController new];
            [self.navigationController pushViewController:addVC animated:YES];
        }
        else if ([params[1] isEqualToString:@"paySuccess"])
        {
            PaySuccessViewController *successVC = [PaySuccessViewController new];
            [self.navigationController pushViewController:successVC animated:YES];
        }
    }
}

-(void)navBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
