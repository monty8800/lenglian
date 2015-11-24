//
//  SelectWarehouseTableViewCell2.m
//  HelloCordova
//
//  Created by YYQ on 15/10/22.
//
//

#import "SelectWarehouseTableViewCell2.h"
#import "Global.h"
@implementation SelectWarehouseTableViewCell2

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,0, SCREEN_WIDTH-65, 30)];
    [self.contentView addSubview:_nameLabel];
    
    _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, SCREEN_WIDTH-65, 35)];
    [_addressLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.contentView addSubview:_addressLabel];
    [_addressLabel setNumberOfLines:0];
    
    _selectedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 16, 13)];
    [_selectedImageView setCenter:CGPointMake(SCREEN_WIDTH-40 - 20, 65/2)];
    [_selectedImageView setHidden:YES];
    [_selectedImageView setImage:[UIImage imageNamed:@"icon_selected"]];
    [self.contentView addSubview:_selectedImageView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH-40, 1)];
    line.backgroundColor = [UIColor WY_ColorWithHex:0xececec];
    [self.contentView addSubview:line];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setWarehouseDic:(NSDictionary *)warehouseDic{
    _nameLabel.attributedText = warehouseDic[@"name"];
    _addressLabel.text = warehouseDic[@"address"];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [_selectedImageView setHidden:!selected];

    // Configure the view for the selected state
}

@end
