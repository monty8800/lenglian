//
//  SearchWarehouseViewController.m
//  HelloCordova
//
//  Created by YYQ on 15/9/24.
//
//

#import "SearchWarehouseViewController.h"

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
