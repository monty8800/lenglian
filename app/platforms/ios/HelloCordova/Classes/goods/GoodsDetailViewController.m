//
//  GoodsDetailViewController.m
//  HelloCordova
//
//  Created by YYQ on 15/10/4.
//
//

#import "GoodsDetailViewController.h"

@interface GoodsDetailViewController ()
{
    UIButton *_editButton;
}
@end

@implementation GoodsDetailViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"goodsDetail.html";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

-(void)createUI{
    self.title = @"货源详情";
    _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editButton setFrame:CGRectMake(0, 0, 40, 44)];
    [_editButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_editButton addTarget:self action:@selector(editGoodsSource:) forControlEvents:UIControlEventTouchUpInside];
    [_editButton setHidden:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_editButton];

}
-(void)editGoodsSource:(UIButton *)button{
    if ([button.titleLabel.text isEqualToString:@"编辑"]) {
        NSString *js = [NSString stringWithFormat:@"(function(){window.editGoodsSource()})()"];
        [self.commandDelegate evalJs:js];
    }else{
        NSString *js = [NSString stringWithFormat:@"(function(){window.saveEditGoodsSource()})()"];
        [self.commandDelegate evalJs:js];
    }
}
-(void)commonCommand:(NSArray *)params{
    [super commonCommand:params];
    if ([params[0] integerValue] == 1) {
        if ([params[1] isEqualToString:@"goodsDetail_showEditButton"]) {
            [_editButton setHidden:NO];
        }
        else if ([params[1] isEqualToString:@"goodsDetail_editButton_changeToDone"])
        {
            [_editButton setTitle:@"完成" forState:UIControlStateNormal];
        }
    }
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
