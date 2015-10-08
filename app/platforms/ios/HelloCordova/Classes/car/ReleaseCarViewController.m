//
//  ReleaseCarViewController.m
//  HelloCordova
//
//  Created by YYQ on 15/10/2.
//
//

#import "ReleaseCarViewController.h"
#import "SelectAddressViewController.h"


@interface ReleaseCarViewController ()

@end

@implementation ReleaseCarViewController


-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"releaseVehicle.html";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void) createUI {
    self.title = @"发布车源";
    
    UIImage *navBgBlue = [UIImage WY_ImageWithColor:0x2a7df5 size:CGSizeMake(1, self.navigationController.navigationBar.bounds.size.height+20)];
    
    [self.navigationController.navigationBar setBackgroundImage:navBgBlue forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(void)commonCommand:(NSArray *)params {
    [super commonCommand:params];
    if ([params[0] integerValue] == 1) {
        if ([params[1] isEqualToString:@"select_start_address"] || [params[1] isEqualToString:@"select_end_address"]) {
            SelectAddressViewController *selectAddressVC = [SelectAddressViewController new];
            [self.navigationController pushViewController:selectAddressVC animated:YES];
        }
        else if ([params[1] isEqualToString:@"datepicker"])
        {
            if (_datePicker == nil) {
                _datePicker = [DatePicker new];
                _datePicker.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                _datePicker.pickerCount = 2;
                _datePicker.delegate = self;
            }
            [_datePicker show:@"install"];

        }
        else if ([params[1] isEqualToString:@"contact_list"])
        {
            ContactsViewController *contactsVC = [ContactsViewController new];
            contactsVC.type = params[1];
            contactsVC.delegate = self;
            [self.navigationController pushViewController:contactsVC animated:YES];
        }
    }
}

-(void)select:(NSDictionary *)contact type:(NSString *)type {
    NSString *name = [contact objectForKey:@"name"];
    NSString *mobile = [contact objectForKey:@"mobile"];
    NSString *js = [NSString stringWithFormat:@"(function(){window.updateContact('%@','%@')})()", name, mobile];
    [self.commandDelegate evalJs:js];
}

-(void)selectDate:(NSArray *)dateList type:(NSString *)type {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *start = [formatter stringFromDate:dateList[0]];
    NSString *end = [formatter stringFromDate:dateList[1]];
    NSString *js = [NSString stringWithFormat:@"(function(){window.updateDate('%@','%@')})()", start, end];
    DDLogDebug(@"js is %@" ,js);
    [self.commandDelegate evalJs:js];
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
