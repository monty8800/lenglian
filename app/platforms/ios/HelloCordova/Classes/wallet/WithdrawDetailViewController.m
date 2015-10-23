//
//  WithdrawDetailViewController.m
//  HelloCordova
//
//  Created by ywen on 15/10/22.
//
//

#import "WithdrawDetailViewController.h"

@interface WithdrawDetailViewController ()

@end

@implementation WithdrawDetailViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"withdrawDetail.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现详情";
}

-(void)commonCommand:(NSArray *)params {
    [super commonCommand:params];
    
    if ([params[0] integerValue] == 3) {
        if ([params[1] isEqualToString:@"withdraw:done"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
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
