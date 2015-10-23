//
//  CarOnwerDetailViewController.m
//  HelloCordova
//
//  Created by YYQ on 15/10/16.
//
//

#import "CarOwnerDetailViewController.h"

@interface CarOwnerDetailViewController ()

@end

@implementation CarOwnerDetailViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"carOwnerDetail.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

-(void) createUI {
    self.title = @"车主详情";
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
 [Log] 请求接口: – "http://192.168.26.177:7080/llmj-app//mjCarinfoCtl/queryMjCarinfoLoad.shtml" (carOwnerDetail.js, line 23783)
 [Log] 发送参数: – "{\"uuid\":\"89A93C63-1993-4D9F-A934-8272FBC6C70F\",\"version\":\"0.0.1\",\"client_type\":2,\"data\":\"{\\"carId\\":\\"7cf840e527da40c483af16f763033aec\\",\\"userId\\":\\"3925f5ad878144bb9248708847491bcb\\",\\"focusid\\":\\"2a8c0eeaf1e342fb9b89cf7de25c1090\\"}\"}" (carOwnerDetail.js, line 23784)
 [Log] 返回数据 (console-via-logger.js, line 173)
*/

@end
