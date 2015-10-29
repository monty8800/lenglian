//
//  WithdrawViewController.m
//  HelloCordova
//
//  Created by ywen on 15/10/22.
//
//

#import "WithdrawViewController.h"
#import "WithdrawDetailViewController.h"
#import "BankCardsListViewController.h"
#import "ChangePasswdViewController.h"

@interface WithdrawViewController ()

@end

@implementation WithdrawViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"withdraw.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现";
}

-(void)commonCommand:(NSArray *)params {
    [super commonCommand:params];
    if ([params[0] integerValue] == 1) {
        if ([params[1] isEqualToString:@"withdrawDetail"]) {
            WithdrawDetailViewController *detailVC = [WithdrawDetailViewController new];
            [self.navigationController pushViewController: detailVC animated:YES];
        }
        else if ([params[1] isEqualToString:@"bankCardsList"])
        {
            BankCardsListViewController *bankCardListVC = [BankCardsListViewController new];
            [self.navigationController pushViewController:bankCardListVC animated:YES];
        }
//        else if ([params[1] isEqualToString:@"changePasswd"])
//        {
//            ChangePasswdViewController *changePwdVC = [ChangePasswdViewController new];
//            [self.navigationController pushViewController:changePwdVC animated:YES];
//        }
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
