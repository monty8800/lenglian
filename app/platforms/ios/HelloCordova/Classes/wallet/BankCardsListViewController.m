//
//  BnakCardsListViewController.m
//  HelloCordova
//
//  Created by YYQ on 15/10/5.
//
//

#import "BankCardsListViewController.h"
#import "AddBankCardViewController.h"
@interface BankCardsListViewController ()
{
    UIButton *_deleteBtn;
}

@end

@implementation BankCardsListViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"bankCardsList.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

-(void) createUI {
    self.title = @"我的银行卡";
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setFrame:CGRectMake(0, 0, 40, 44)];
    [_deleteBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_deleteBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deleteBankCard:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBtn setHidden:NO];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_deleteBtn];

}
-(void)deleteBankCard:(UIButton *)button{
    if ([button.titleLabel.text isEqualToString:@"编辑"]) {
        [_deleteBtn setTitle:@"完成" forState:UIControlStateNormal];
        NSString *js = [NSString stringWithFormat:@"(function(){window.changeStatusToDelete()})()"];
        [self.commandDelegate evalJs:js];
    }else{
        [_deleteBtn setTitle:@"编辑" forState:UIControlStateNormal];
        NSString *js = [NSString stringWithFormat:@"(function(){window.changeStatusToNormal ()})()"];
        [self.commandDelegate evalJs:js];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.commandDelegate evalJs:@"(function(){window.tryReloadBandCardsList()})()"];
}

-(void)commonCommand:(NSArray *)params{
    [super commonCommand:params];
    if ([params[0] integerValue] == 1) {
        if ([params[1] isEqualToString:@"addBankCard"]) {
            AddBankCardViewController *addBankCarVC = [AddBankCardViewController new];
            [self.navigationController pushViewController:addBankCarVC animated:YES];
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
