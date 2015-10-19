//
//  CarListViewController.m
//  HelloCordova
//
//  Created by ywen on 15/9/22.
//
//

#import "CarListViewController.h"
#import "AddCarViewController.h"
#import "CarDetailViewController.h"
#import "ReleaseCarViewController.h"

@interface CarListViewController ()

@end

@implementation CarListViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"myCar.html";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

-(void) createUI {
    self.title = @"我的车辆";
    UIButton *addWarehouseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addWarehouseButton setFrame:CGRectMake(0, 0, 60, 44)];
    [addWarehouseButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [addWarehouseButton setTitle:@"新增车辆" forState:UIControlStateNormal];
    [addWarehouseButton addTarget:self action:@selector(addNewCar) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addWarehouseButton];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateCarListAfterAddNewCar) name:@"ADD_CAR_SUCCESS" object:nil];
}
- (void)addNewCar{
    AddCarViewController *addNewCarVC = [AddCarViewController new];
    [self.navigationController pushViewController:addNewCarVC animated:YES];
}
-(void)updateCarListAfterAddNewCar{
    NSString *js = [NSString stringWithFormat:@"(function(){window.updateMyCarList('1')})()"];
    [self.commandDelegate evalJs: js];
}
-(void)commonCommand:(NSArray *)params {
    [super commonCommand:params];
    if ([params[0] integerValue] == 1) {
        if ([params[1] isEqualToString:@"carDetail"]) {
            CarDetailViewController *carDetailVC = [CarDetailViewController new];
            [self.navigationController pushViewController:carDetailVC animated:YES];
        }
        else if ([params[1] isEqualToString:@"releaseVehicle"])
        {
            ReleaseCarViewController *releaseVC = [ReleaseCarViewController new];
            [self.navigationController pushViewController:releaseVC animated:YES];
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
