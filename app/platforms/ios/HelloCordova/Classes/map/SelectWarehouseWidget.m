//
//  SelectWarehouseWidget.m
//  HelloCordova
//
//  Created by ywen on 15/10/2.
//
//

#import "SelectWarehouseWidget.h"

@implementation SelectWarehouseWidget

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void) createUI {
    _tabView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _tabView.dataSource = self;
    _tabView.delegate = self;
    _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabView.backgroundColor = [UIColor whiteColor];
    [_tabView registerClass:[SelectWarehouseTableViewCell class] forCellReuseIdentifier:@"select_warehouse_cell"];
    [self addSubview:_tabView];
}

-(void)setDataList:(NSArray *)dataList {
    _dataList = dataList;
    [_tabView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"select_warehouse_cell";
    SelectWarehouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.infoList = _dataList[indexPath.row];
    return cell;
}

@end
