//
//  FromToView.m
//  HelloCordova
//
//  Created by ywen on 15/10/2.
//
//

#import "FromToView.h"

@implementation FromToView

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
    [_tabView registerClass:[FromToTableViewCell class] forCellReuseIdentifier:@"address_cell"];
    [self addSubview:_tabView];
    
}


-(void)setAddressList:(NSArray *)addressList {
    _addressList = addressList;
    [_tabView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _addressList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 27;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FromToTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"address_cell"];
    cell.addressDic = _addressList[indexPath.row];
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
