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
    
    //导航栏标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    [_titleLabel WY_SetFontSize:17 textColor:0xffffff];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = _titleLabel;
}

-(void)setTitle:(NSString *)title {
    [super setTitle:title];
    _titleLabel.text = title;
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
