//
//  UserCenterViewController.m
//  HelloCordova
//
//  Created by ywen on 15/9/21.
//
//

#import "UserCenterViewController.h"
#import "MoreViewController.h"
#import "WalletViewController.h"
#import "MessageListViewController.h"
#import "CarListViewController.h"
#import "AddressListViewController.h"
#import "FollowListViewController.h"
#import "MyWarehouseViewController.h"
#import "CommentViewController.h"
#import "MyGoodsListViewController.h"

@interface UserCenterViewController ()

@end

@implementation UserCenterViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"userCenter.html";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:_navBgBlue forBarMetrics: UIBarMetricsDefault];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:_navBg forBarMetrics: UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

-(void) createUI {
    self.title = @"我的";
    
    _navBg = [UIImage imageNamed:@"nav_bg"];
    _navBgBlue = [UIImage WY_ImageWithColor:0x2a7df5 size:CGSizeMake(1, self.navigationController.navigationBar.bounds.size.height+20)];
}

-(void)commonCommand:(NSArray *)params {
    [super commonCommand:params];
    
    if ([params[0] integerValue] == 1) {
        if ([params[1] isEqualToString:@"more"]) {
            MoreViewController *moreVC = [MoreViewController new];
            moreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:moreVC animated:YES];
        }
        else if ([params[1] isEqualToString:@"wallet"])
        {
            WalletViewController *walletVC = [WalletViewController new];
            walletVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:walletVC animated:YES];
        }
        else if ([params[1] isEqualToString:@"messageList"])
        {
            MessageListViewController *messageListVC = [MessageListViewController new];
            messageListVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:messageListVC animated:YES];
        }
        else if ([params[1] isEqualToString:@"myCar"])
        {
            CarListViewController *carListVC = [CarListViewController new];
            carListVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:carListVC animated:YES];
        }
        else if ([params[1] isEqualToString:@"addressList"])
        {
            AddressListViewController *addressVC = [AddressListViewController new];
            addressVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:addressVC animated:YES];
        }
        else if ([params[1] isEqualToString:@"attentionList"])
        {
            FollowListViewController *followVC = [FollowListViewController new];
            followVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:followVC animated:YES];
        }
        else if ([params[1] isEqualToString:@"myWarehouse"])
        {
            MyWarehouseViewController *myWarehouse = [MyWarehouseViewController new];
            myWarehouse.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myWarehouse animated:YES];
        }
        else if ([params[1] isEqualToString:@"myComment"])
        {
            CommentViewController *commentVC = [CommentViewController new];
            commentVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:commentVC animated:YES];
        }
        else if ([params[1] isEqualToString:@"myGoods"])
        {
            MyGoodsListViewController *myGoodsVC = [MyGoodsListViewController new];
            myGoodsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myGoodsVC animated:YES];
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
