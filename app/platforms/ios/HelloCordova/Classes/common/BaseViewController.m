//
//  BaseViewController.m
//  HelloCordova
//
//  Created by ywen on 15/7/21.
//
//

#import "BaseViewController.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        if ([Global sharedInstance].wwwVersion != nil) {
            self.wwwFolderName = [NSString stringWithFormat:@"file://%@/%@/www",  UPDATE_FOLDER, [Global sharedInstance].wwwVersion];
        }
    }
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *vcName = NSStringFromClass([self class]);
    [MobClick beginLogPageView: vcName];
    [Global sharedInstance].currentVC = self;
    DDLogVerbose(@"enter page %@", vcName);
    
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSString *vcName = NSStringFromClass([self class]);
    [MobClick endLogPageView: vcName];
    DDLogVerbose(@"leave page %@", vcName);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    XEPlugin *xePlugin = [self getCommandInstance:@"XEPlugin"];
    xePlugin.loading = [Global sharedInstance];
    xePlugin.toast = [Global sharedInstance];
    
    self.webView.backgroundColor = [UIColor WY_ColorWithHex:0xf2f5f5];
    
    //导航栏标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    [_titleLabel WY_SetFontSize:19 textColor:0xffffff];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = _titleLabel;
    
    self.navigationController.navigationBar.backgroundColor = [UIColor WY_ColorWithHex:0x1987c6];
    
    //去掉导航栏分割线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics: UIBarMetricsDefault];
    
    //返回
    if (self.navigationController.viewControllers.count > 1) {
        UIBarButtonItem *backItem = [[UIBarButtonItem  alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(navBack)];
        self.navigationItem.leftBarButtonItem = backItem;
    }
}

-(void) navBack {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setTitle:(NSString *)title {
    [super setTitle:title];
    _titleLabel.text = title;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [super webViewDidFinishLoad:webView];
    NSString *uuid = [Global sharedInstance].uuid;
    NSString *version = [Global sharedInstance].version;
    NSAssert(uuid, @"没有uuid！");
    NSAssert(version, @"没有版本号!");
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"(function(){window.uuid='%@'; window.version='%@'; window.client_type='%@'})()", uuid, version, CLIENT_TYPE]];
    
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
