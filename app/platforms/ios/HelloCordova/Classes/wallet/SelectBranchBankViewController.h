//
//  SelectBranchBankViewController.h
//  HelloCordova
//
//  Created by ywen on 15/11/23.
//
//

#import <UIKit/UIKit.h>
#import <FMDB.h>
#import <CocoaLumberjack.h>

@interface SelectBranchBankViewController : UIViewController
{
    FMDatabase *_db;
}

@property (strong, nonatomic) NSString *bankName;

@end
