//
//  SelectWarehouseTableViewCell.m
//  HelloCordova
//
//  Created by ywen on 15/10/2.
//
//

#import "SelectWarehouseTableViewCell.h"

@implementation SelectWarehouseTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

//TODO: 没有切图，对勾
-(void) createUI {
    _infoView = [[InfoView alloc] initWithFrame:CGRectMake(20, 12, self.contentView.bounds.size.width-40, self.contentView.bounds.size.height - 22)];
    [self.contentView addSubview:_infoView];
}

-(void)setInfoList:(NSArray *)infoList {
    _infoList = infoList;
    _infoView.dataList = infoList;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
