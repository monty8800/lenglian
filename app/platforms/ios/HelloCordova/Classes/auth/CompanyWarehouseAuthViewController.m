//
//  CompanyWarehouseAuthViewController.m
//  HelloCordova
//
//  Created by ywen on 15/9/24.
//
//

#import "CompanyWarehouseAuthViewController.h"

@interface CompanyWarehouseAuthViewController ()

@end

@implementation CompanyWarehouseAuthViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"companyWarehouseAuth.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"公司仓库主认证";
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
