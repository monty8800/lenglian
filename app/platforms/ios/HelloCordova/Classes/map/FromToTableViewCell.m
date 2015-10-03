//
//  FromToTableViewCell.m
//  HelloCordova
//
//  Created by ywen on 15/10/2.
//
//

#import "FromToTableViewCell.h"
#import "Global.h"




@implementation FromToTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

//TODO: ui切图后对齐图片
-(void) createUI {
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 17, 27)];
    [self.contentView addSubview:_iconView];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 7, self.bounds.size.width, 14)];
    _addressLabel.font = [UIFont systemFontOfSize:14];
    _addressLabel.textColor = [UIColor WY_ColorWithHex:0x7a7a7a];
    [self.contentView addSubview:_addressLabel];
}

-(void)setAddressDic:(NSDictionary *)addressDic {
    _addressDic = addressDic;
    
    UIImage *icon;
    switch ([[_addressDic objectForKey:@"type"] integerValue]) {
        case FROM:
        {
            icon = [UIImage imageNamed:@"address_start"];
        }
            break;
        
        case TO:
        {
            icon = [UIImage imageNamed:@"address_to"];
        }
            break;
            
        case PASSBY:
        {
            icon = [UIImage imageNamed:@"address_passby"];
        }
            break;
        
            
        default:
            break;
    }
    
    _iconView.image = icon;
    
    _addressLabel.text = [_addressDic objectForKey:@"text"];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
