//
//  ChargeViewController.m
//  HelloCordova
//
//  Created by YYQ on 15/10/8.
//
//

#import "ChargeViewController.h"
#import "AddBankCardViewController.h"
@interface ChargeViewController ()

@end

@implementation ChargeViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"charge.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional  setup after loading the view.
    
    [self createUI];
}

-(void) createUI {
    self.title = @"充值";
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
