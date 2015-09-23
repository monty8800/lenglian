//
//  PersonalCarAuthViewController.m
//  HelloCordova
//
//  Created by ywen on 15/9/23.
//
//

#import "PersonalCarAuthViewController.h"


@interface PersonalCarAuthViewController ()

@end

@implementation PersonalCarAuthViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"personalCarAuth.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

-(void) createUI {
    
    self.title = @"个人车主认证";
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
    }
}

-(void)selectImage:(NSString *)imagePath type:(NSString *)type{
    NSString *js = [NSString stringWithFormat:@"(function(){window.setAuthPic('%@', '%@')})()", imagePath, type];
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
