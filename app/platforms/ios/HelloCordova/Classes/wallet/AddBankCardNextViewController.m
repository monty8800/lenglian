//
//  AddBankCardNextViewController.m
//  HelloCordova
//
//  Created by YYQ on 15/10/6.
//
//

#import "AddBankCardNextViewController.h"
#import "AddBankCarVerifyViewController.h"

@interface AddBankCardNextViewController ()

@end

@implementation AddBankCardNextViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"addBankCardNext.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

-(void) createUI {
    self.title = @"添加银行卡";
}
-(void)commonCommand:(NSArray *)params{
    [super commonCommand:params];
    if ([params[0] integerValue] == 1) {
        if ([params[1] isEqualToString:@"addBankCardVerify"]) {
            AddBankCarVerifyViewController *addBankCardVerifyVC = [AddBankCarVerifyViewController new];
            [self.navigationController pushViewController:addBankCardVerifyVC animated:YES];
        }
        else if ([params[1] isEqualToString:@"branchCard"])
        {
            SelectBranchBankViewController *selectVC = [SelectBranchBankViewController new];
            selectVC.delegate = self;
            selectVC.bankName = params[2];
            [self.navigationController pushViewController:selectVC animated:YES];
        }
    }
}

-(void)setBranchBank:(NSString *)branchBank {
    NSString *js = [NSString stringWithFormat:@"window.setBranchBank('%@')", branchBank];
    [self.commandDelegate evalJs:js];
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
