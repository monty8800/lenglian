//
//  AddBankCardViewController.m
//  HelloCordova
//
//  Created by YYQ on 15/10/5.
//
//

#import "AddBankCardViewController.h"
#import "AddBankCardNextViewController.h"
@interface AddBankCardViewController ()

@end

@implementation AddBankCardViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"AddBankCard.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}
-(void)commonCommand:(NSArray *)params{
    [super commonCommand:params];
    if ([params[0] integerValue] == 1) {
        if ([params[1] isEqualToString:@"addBankCardNext"]) {
            AddBankCardNextViewController *addBankCardNextVC = [AddBankCardNextViewController new];
            [self.navigationController pushViewController:addBankCardNextVC animated:YES];
        }
    }
}
-(void) createUI {
    self.title = @"添加银行卡";
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
