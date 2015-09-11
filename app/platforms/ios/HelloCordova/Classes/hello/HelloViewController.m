//
//  HelloViewController.m
//  HelloCordova
//
//  Created by ywen on 15/8/7.
//
//

#import "HelloViewController.h"

@interface HelloViewController ()

@end

@implementation HelloViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"hello.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [super webViewDidFinishLoad:webView];
    
    [self.commandDelegate evalJs:@"nativeCallJs()"];
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
