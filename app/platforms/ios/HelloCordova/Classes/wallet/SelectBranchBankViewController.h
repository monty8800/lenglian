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

@protocol SelectBranchBankDelegate <NSObject>

@required
-(void) setBranchBank:(NSString *) branchBank;

@end

@interface SelectBranchBankViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    FMDatabase *_db;
    UITableView *_tableView;
    NSMutableArray *_dataList;
    
    UIView *_searchView;
    UITextField *_searchField;
    NSString *_keyword;
    dispatch_queue_t _searchQuque;
}

@property (strong, nonatomic) NSString *bankName;
@property (weak, nonatomic) id<SelectBranchBankDelegate> delegate;

@end
