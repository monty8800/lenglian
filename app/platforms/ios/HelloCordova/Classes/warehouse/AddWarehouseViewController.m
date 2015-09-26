//
//  AddWarehouseViewController.m
//  HelloCordova
//
//  Created by YYQ on 15/9/26.
//
//

#import "AddWarehouseViewController.h"

@interface AddWarehouseViewController ()

@end

@implementation AddWarehouseViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"addWarehouse.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

-(void) createUI {
    self.title = @"新增仓库";
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setFrame:CGRectMake(0, 0, 40, 44)];
    [saveButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [saveButton setTitle:@"完成" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:saveButton];
    
}

-(void)saveBtnClick{
    
    [self.commandDelegate evalJs:@"addCurrentWarehouse()"];
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
