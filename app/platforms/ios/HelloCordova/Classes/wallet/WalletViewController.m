//
//  WalletViewController.m
//  HelloCordova
//
//  Created by ywen on 15/9/22.
//
//

#import "WalletViewController.h"
#import "BankCardsListViewController.h"
@interface WalletViewController ()

@end

@implementation WalletViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"wallet.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

-(void) createUI {
    self.title = @"我的钱包";
    UIButton *addWarehouseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addWarehouseButton setFrame:CGRectMake(0, 0, 60, 44)];
    [addWarehouseButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [addWarehouseButton setTitle:@"我的银行卡" forState:UIControlStateNormal];
    [addWarehouseButton addTarget:self action:@selector(showMyCards) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addWarehouseButton];
}
-(void)showMyCards{
    BankCardsListViewController *bankCardListVC = [BankCardsListViewController new];
    [self.navigationController pushViewController:bankCardListVC animated:YES];
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
