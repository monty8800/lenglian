//
//  AddCarViewController.m
//  HelloCordova
//
//  Created by YYQ on 15/10/1.
//
//

#import "AddCarViewController.h"
#import "Net.h"

@interface AddCarViewController ()

@end

@implementation AddCarViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"addCar.html";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

-(void) createUI {
    self.title = @"新增车辆";
}

-(void)commonCommand:(NSArray *)params {
    [super commonCommand:params];
    
    if ([params[0] integerValue] == 8) {
        DDLogDebug(@"show pic selector!");
        if (_imagePicker == nil) {
            _imagePicker = [ImagePicker new];
            _imagePicker.delegate = self;
        }
        [_imagePicker show:params[1] vc:self];
    }
    else if ([params[0] integerValue] == 7)
    {
        [Net postFile:params[1] params:params[2] files:params[3] cb:^(NSDictionary *responseDic) {
            if ([[responseDic objectForKey:@"code"] isEqualToString:@"0000"]) {
                [[Global sharedInstance] showSuccess:@"车辆添加成功！"];
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ADD_CAR_SUCCESS" object:nil];
            }
            else
            {
                [[Global sharedInstance] showErr:[responseDic objectForKey:@"msg"]];
            }
        }];
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
