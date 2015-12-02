//
//  ModifyAddressViewController.m
//  HelloCordova
//
//  Created by ywen on 15/9/28.
//
//

#import "ModifyAddressViewController.h"

@interface ModifyAddressViewController ()

@end

@implementation ModifyAddressViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"modifyAddress.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

-(void) createUI {
    
}

-(void)select:(BMKAddressComponent *)address coor:(CLLocationCoordinate2D)coor {
    NSString *userProps = [NSString stringWithFormat: @"{provinceName:'%@', cityName:'%@', areaName:'%@', street:'%@%@', lati: '%f', longi: '%f'}", address.province, address.city, address.district, address.streetName, address.streetNumber, coor.latitude, coor.longitude];
    NSString *js = [NSString stringWithFormat:@"(function(){window.updateAddress(%@)})()", userProps];
    [self.commandDelegate evalJs:js];
}

-(void)commonCommand:(NSArray *)params {
    [super commonCommand:params];
    
    if ([params[0] integerValue] == 19) {
        [Global geo:params[1] address:params[2] cb:^(BMKGeoCodeResult *result) {
            DDLogDebug(@"result--%f---%f", result.location.latitude, result.location.longitude);
            NSString *js = [NSString stringWithFormat:@"(function(){window.doSubmit('%f', '%f')})()", result.location.latitude, result.location.longitude];
            [self.commandDelegate evalJs:js];
        }];
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
