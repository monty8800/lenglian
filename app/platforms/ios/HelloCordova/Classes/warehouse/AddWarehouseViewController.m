//
//  AddWarehouseViewController.m
//  HelloCordova
//
//  Created by YYQ on 15/9/26.
//
//

#import "AddWarehouseViewController.h"
#import "Auth.h"
#import "MyWarehouseViewController.h"
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
    [self.view endEditing:YES];
    NSString *saveJs = [NSString stringWithFormat:@"(function(){window.postAddWarehouse()})()"];
    [self.commandDelegate evalJs: saveJs];
}
- (void)commonCommand:(NSArray *)params{
    [super commonCommand:params];
    if ([params[0] integerValue] == 8) {
        DDLogDebug(@"show pic selector!");
        if (_imagePikcer == nil) {
            _imagePikcer = [ImagePicker new];
            _imagePikcer.delegate = self;
        }
        [_imagePikcer show:params[1] vc:self];
    }
    else if ([params[0] integerValue] == 7)
    {
        [Auth auth:params[1] params:params[2] files:params[3] cb:^(NSDictionary *responseDic) {
            DDLogDebug(@"新增仓库 结果 %@", responseDic);
            if ([[responseDic objectForKey:@"code"] isEqualToString:@"0000"]) {
                [[Global sharedInstance] showSuccess:@"上传成功！"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadMyWarehouseList" object:nil];
//                [self.commandDelegate evalJs:@"(function(){window.refreshWarehousListAfterAdd()})()"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [[Global sharedInstance] showErr:[responseDic objectForKey:@"msg"]];
            }
        }];
    }

}

-(void)selectImage:(NSString *)imagePath type:(NSString *)type{
    NSString *js = [NSString stringWithFormat:@"(function(){window.showAddWarehouseImage('%@', '%@')})()", imagePath, type];
    DDLogDebug(@"image path %@, type: %@, js: %@", imagePath, type, js);
    [self.commandDelegate evalJs: js];
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