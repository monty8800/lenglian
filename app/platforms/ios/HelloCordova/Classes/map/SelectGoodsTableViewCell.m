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
    
    _selectedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 16, 13)];
    [_selectedImageView setCenter:CGPointMake(SCREEN_WIDTH-40 - 20, 90/2)];
    [_selectedImageView setHidden:YES];
    [_selectedImageView setImage:[UIImage imageNamed:@"icon_selected"]];
    [self.contentView addSubview:_selectedImageView];
    
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
    [_selectedImageView setHidden:!selected];

    // Configure the view for the selected state
}

@end
