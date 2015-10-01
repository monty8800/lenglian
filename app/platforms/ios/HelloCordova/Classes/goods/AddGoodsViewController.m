//
//  AddGoodsViewController.m
//  HelloCordova
//
//  Created by ywen on 15/9/26.
//
//

#import "AddGoodsViewController.h"
#import "Net.h"

@interface AddGoodsViewController ()

@end

@implementation AddGoodsViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"addGoods.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

-(void) createUI {
    self.title = @"发布货源";
    UIImage *navBgBlue = [UIImage WY_ImageWithColor:0x2a7df5 size:CGSizeMake(1, self.navigationController.navigationBar.bounds.size.height+20)];
    
    [self.navigationController.navigationBar setBackgroundImage:navBgBlue forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
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
    else if ([params[0] integerValue] == 6)
    {
        if (_datePicker == nil) {
            _datePicker = [DatePicker new];
            _datePicker.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            _datePicker.pickerCount = 2;
            _datePicker.delegate = self;
        }
        if ([params[1] isEqualToString:@"select:time:install"]) {
            [_datePicker show:@"install"];
        }
        else if ([params[1] isEqualToString:@"select:time:arrive"])
        {
            [_datePicker show:@"arrive"];
        }
    }
    else if ([params[0] integerValue] == 7)
    {
        [Net postFile:params[1] params:params[2] files:params[3] cb:^(NSDictionary *responseDic) {
            if ([[responseDic objectForKey:@"code"] isEqualToString:@"0000"]) {
                [[Global sharedInstance] showSuccess:@"货源发布成功！"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [[Global sharedInstance] showErr:[responseDic objectForKey:@"msg"]];
            }
        }];
    }
    else if ([params[0] integerValue] == 4)
    {
        ContactsViewController *contactsVC = [ContactsViewController new];
        contactsVC.type = params[1];
        contactsVC.delegate = self;
        [self.navigationController pushViewController:contactsVC animated:YES];
    }
}
-(void)select:(NSDictionary *)contact type:(NSString *)type {
    NSString *name = [contact objectForKey:@"name"];
    NSString *mobile = [contact objectForKey:@"mobile"];
    NSString *js = [NSString stringWithFormat:@"(function(){window.updateContact('%@','%@','%@')})()", name, mobile, type];
    [self.commandDelegate evalJs:js];
}

-(void)selectDate:(NSArray *)dateList type:(NSString *)type {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *start = [formatter stringFromDate:dateList[0]];
    NSString *end = [formatter stringFromDate:dateList[1]];
    NSString *js = [NSString stringWithFormat:@"(function(){window.updateTime('%@','%@','%@')})()", start, end, type];
    DDLogDebug(@"js is %@" ,js);
    [self.commandDelegate evalJs:js];
}

-(void)selectImage:(NSString *)imagePath type:(NSString *)type{
    NSString *js = [NSString stringWithFormat:@"(function(){window.setGoodsPic('%@')})()", imagePath];
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
