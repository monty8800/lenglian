//
//  AddressListViewController.m
//  HelloCordova
//
//  Created by ywen on 15/9/22.
//
//

#import "AddressListViewController.h"
#import "ModifyAddressViewController.h"

@interface AddressListViewController ()

@end

@implementation AddressListViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"addressList.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

-(void) createUI {
    self.title = @"我的地址";
    
    UIBarButtonItem *rigthBtn = [[UIBarButtonItem alloc] initWithTitle:@"新增地址" style:UIBarButtonItemStylePlain target:self action:@selector(newAddress)];
    rigthBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rigthBtn;
}

-(void) newAddress {
    ModifyAddressViewController *addressVC = [ModifyAddressViewController new];
    addressVC.title = @"新增地址";
    [self.navigationController pushViewController:addressVC animated:YES];
    
}

-(void)commonCommand:(NSArray *)params {
    [super commonCommand:params];
    
    if ([params[0] integerValue] == 1 ) {
        if ([params[1] isEqualToString:@"modifyAddress"]) {
            ModifyAddressViewController *addressVC = [ModifyAddressViewController new];
            addressVC.title = @"编辑地址";
            [self.navigationController pushViewController:addressVC animated:YES];
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
