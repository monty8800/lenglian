//
//  SelectGoodsTableViewCell.m
//  HelloCordova
//
//  Created by ywen on 15/10/4.
//
//

#import "SelectGoodsTableViewCell.h"
#import "Global.h"

@implementation SelectGoodsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void) createUI {
    _infoView = [[InfoView alloc] initWithFrame:CGRectMake(20, 8, SCREEN_WIDTH - 80, 88)];
    _infoView.tabView.scrollEnabled = NO;
    _infoView.tabView.userInteractionEnabled = NO;
    [self.contentView addSubview:_infoView];
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 89, SCREEN_WIDTH-80, 1)];
    line.backgroundColor = [UIColor WY_ColorWithHex:0xececec];
    [self.contentView addSubview:line];
    
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
