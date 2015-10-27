//
//  SelectWarehouseTableViewCell.m
//  HelloCordova
//
//  Created by ywen on 15/10/2.
//
//

#import "SelectWarehouseTableViewCell.h"
#import "Global.h"

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
    _infoView = [[InfoView alloc] initWithFrame:CGRectMake(20, 12, SCREEN_WIDTH-80, 80 )];
    _infoView.tabView.scrollEnabled = NO;
    _infoView.userInteractionEnabled = NO;
    [self.contentView addSubview:_infoView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 98, SCREEN_WIDTH-40, 1)];
    line.backgroundColor = [UIColor WY_ColorWithHex:0xececec];
    [self.contentView addSubview:line];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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
