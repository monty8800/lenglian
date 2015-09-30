//
//  SelectAddressViewController.m
//  HelloCordova
//
//  Created by ywen on 15/9/26.
//
//

#import "SelectAddressViewController.h"

@interface SelectAddressViewController ()

@end

@implementation SelectAddressViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"selectAddress.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

-(void) createUI {
    self.title = @"选择地区";
    
     UIImage *navBgBlue = [UIImage WY_ImageWithColor:0x2a7df5 size:CGSizeMake(1, self.navigationController.navigationBar.bounds.size.height+20)];
    [self.navigationController.navigationBar setBackgroundImage:navBgBlue forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickDone)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

-(void) clickDone {
    [self.commandDelegate evalJs:@"(function(){window.selectCurrent()})()"];
}

-(void)commonCommand:(NSArray *)params {
    [super commonCommand:params];
}

-(void)select:(BMKAddressComponent *)address coor:(CLLocationCoordinate2D)coor {
    NSString *userProps = [NSString stringWithFormat: @"{provinceName:'%@', cityName:'%@', areaName:'%@', street:'%@%@', lati: '%f', longi: '%f'}", address.province, address.city, address.district, address.streetName, address.streetNumber, coor.latitude, coor.longitude];
    NSString *js = [NSString stringWithFormat:@"(function(){window.updateAddress(%@)})()", userProps];
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
