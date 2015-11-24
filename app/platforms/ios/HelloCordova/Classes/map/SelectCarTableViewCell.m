//
//  SelectCarTableViewCell.m
//  HelloCordova
//
//  Created by ywen on 15/10/3.
//
//

#import "SelectCarTableViewCell.h"
#import "Global.h"

@implementation SelectCarTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

//TODO: 没有切图，对勾
-(void) createUI {
    self.backgroundColor = [UIColor whiteColor];
    _fromToView = [[FromToView alloc] initWithFrame:CGRectMake(20, 12, SCREEN_WIDTH-80, 55)];

    [self.contentView addSubview:_fromToView];
    
    _infoView = [[InfoView alloc] initWithFrame:CGRectMake(20, _fromToView.frame.origin.y + _fromToView.frame.size.height + 10, SCREEN_WIDTH-80, 60 )];
    _infoView.tabView.scrollEnabled = NO;
    _infoView.userInteractionEnabled = NO;
    [self.contentView addSubview:_infoView];
    
    _selectedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    [_selectedImageView setCenter:CGPointMake(SCREEN_WIDTH-40 - 20, 130/2)];
    [_selectedImageView setHidden:YES];
    [self.contentView addSubview:_selectedImageView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 129, SCREEN_WIDTH-40, 1)];
    line.backgroundColor = [UIColor WY_ColorWithHex:0xececec];
    [self.contentView addSubview:line];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

-(void)setAddressList:(NSArray *)addressList {
    _fromToView.addressList = addressList;
}

-(void) setInfoList:(NSArray *)infoList {
    _infoView.dataList = infoList;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [_selectedImageView setHidden:!selected];
    // Configure the view for the selected state
}

@end
