//
//  BaseAuthViewController.m
//  HelloCordova
//
//  Created by ywen on 15/9/24.
//
//

#import "BaseAuthViewController.h"

@interface BaseAuthViewController ()

@end

@implementation BaseAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)commonCommand:(NSArray *)params {
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
            DDLogDebug(@"auth result is %@", responseDic);
            if ([[responseDic objectForKey:@"code"] isEqualToString:@"0000"]) {
                [[Global sharedInstance] showSuccess:@"上传成功！"];
                [self.commandDelegate evalJs:@"(function(){window.authDone()})()"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

-(void)selectImage:(NSString *)imagePath type:(NSString *)type{
    NSString *js = [NSString stringWithFormat:@"(function(){window.setAuthPic('%@', '%@')})()", imagePath, type];
    DDLogDebug(@"image path %@, type: %@, js: %@", imagePath, type, js);
    [self.commandDelegate evalJs: js];
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
