//
//  SelectBranchBankViewController.m
//  HelloCordova
//
//  Created by ywen on 15/11/23.
//
//

#import "SelectBranchBankViewController.h"
#import "Global.h"

@interface SelectBranchBankViewController ()

@end

@implementation SelectBranchBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    [titleLabel WY_SetFontSize:19 textColor:0xffffff];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    titleLabel.text = @"选择支行";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem  alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(navBack)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"bank" ofType:@"db" inDirectory:@"db"];
    DDLogDebug(@"sqlite path %@", path);
    
    _db = [FMDatabase databaseWithPath:path];
    if (![_db open]) {
        _db = nil;
    }
    
    _dataList = [[NSMutableArray alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, self.view.bounds.size.height-50) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_tableView];
    [self search:@""];
    
    //搜索框
    _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    _searchView.backgroundColor = [UIColor WY_ColorWithHex:0xf2f5f5];
    [self.view addSubview: _searchView];
    
    _searchField = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, SCREEN_WIDTH-40, 40)];
    [_searchField WY_SetBorder:0xececec width:1];
    _searchField.backgroundColor = [UIColor whiteColor];
    [_searchView addSubview:_searchField];
    _searchField.returnKeyType = UIReturnKeySearch;
    [_searchField WY_SetLeftSpace:10];
    _searchField.placeholder = @"请输入关键字搜索，如‘中关村’";
    [_searchField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
    
    _searchQuque = dispatch_queue_create("com.ywen.search", DISPATCH_QUEUE_SERIAL);
    _keyword = @"";
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (![_keyword isEqualToString: textField.text]) {
//            _keyword = textField.text;
//            [self search:textField.text];
//        }
//        
//    });
//    return YES;
//}

-(void) navBack {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) textChanged {
    if (_searchField.markedTextRange != nil) {
        return;
    }
    if (![_keyword isEqualToString:_searchField.text]) {
        _keyword = _searchField.text;
        [self search:_keyword];
    }
}

-(void) search:(NSString *) key {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *sql;
        if (key.length > 0) {
            sql = [NSString stringWithFormat:@"select branch_name from branch_bank where branch_name like '%%%@%%%@%%'", _bankName, key];
        }
        
        else
        {
            sql = [NSString stringWithFormat:@"select branch_name from branch_bank where branch_name like '%%%@%%'", _bankName];
        }
        DDLogDebug(@"query sql is %@", sql);
        FMResultSet *rs = [_db executeQuery:sql];
        [_dataList removeAllObjects];
        while ([rs next]) {
            NSString *name = [rs  stringForColumnIndex:0];
            [_dataList addObject:name];
            
        }
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"branch_bank_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = _dataList[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate setBranchBank:_dataList[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc {
    [_db close];
    _db = nil;
    _searchQuque = nil;
    
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
