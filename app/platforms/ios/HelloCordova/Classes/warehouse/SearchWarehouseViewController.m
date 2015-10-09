//
//  SearchWarehouseViewController.m
//  HelloCordova
//
//  Created by YYQ on 15/9/24.
//
//

#import "SearchWarehouseViewController.h"
#import "Net.h"
#import "SearchWarehouseDetailViewController.h"
@interface SearchWarehouseViewController ()

@end

@implementation SearchWarehouseViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"searchWarehouse.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

-(void) createUI {
    self.title = @"找仓库";
    UIButton *addWarehouseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addWarehouseButton setFrame:CGRectMake(0, 0, 40, 44)];
    [addWarehouseButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [addWarehouseButton setTitle:@"搜索" forState:UIControlStateNormal];
    [addWarehouseButton addTarget:self action:@selector(sureToSearch) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addWarehouseButton];
}
-(void)sureToSearch{
    NSString *js = [NSString stringWithFormat:@"(function(){window.doSearchWarehouse()})()"];
    [self.commandDelegate evalJs: js];
    
}

-(void)commonCommand:(NSArray *)params {
    [super commonCommand:params];
    
    if ([params[0] integerValue] == 3) {
        if ([params[1] isEqualToString:@"select:goods"]) {
            [SelectWarehouseWidget show:self warehouseId:params[2]];
        }
    }else if ([params[0] integerValue] == 1){
        if ([params[1] isEqualToString:@"searchWarehouseDetail"]) {
            SearchWarehouseDetailViewController *searchWarehouseDetailVC = [SearchWarehouseDetailViewController new];
            [self.navigationController pushViewController:searchWarehouseDetailVC animated:YES];
        }
    }
}

-(void)selectWarehouse:(NSString *)warehouseId goods:(NSString *)goodsId {
    NSDictionary *params = @{
                             @"userId": [[Global getUser] objectForKey:@"id"],
                             @"warehouseId": warehouseId,
                             @"orderGoodsId": goodsId
                             };
    [Net post:ORDER_GOODS_SELECT_WAREHOUSE params:params cb:^(NSDictionary *responseDic) {
        DDLogDebug(@"goods select warehouse result %@", responseDic);
        if ([[responseDic objectForKey:@"code"] isEqualToString:@"0000"]) {
            [[Global sharedInstance] showSuccess:@"成功选择该仓库"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            [[Global sharedInstance] showErr:[responseDic objectForKey:@"msg"]];
        }
    } loading:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [super webViewDidFinishLoad:webView];
    
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.uuid=%@;",[Global sharedInstance].uuid]];
//    [webView stringByEvaluatingJavaScriptFromString:@"alert(window.uuid)"];
    NSLog(@"网页加载完成");
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
