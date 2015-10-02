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

-(void) createUI {
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconView];
    
    _addressLabel = [[UILabel alloc] init];
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
            _iconView.contentMode = UIViewContentModeBottom;
        }
            break;
        
        case TO:
        {
            icon = [UIImage imageNamed:@"address_to"];
            _iconView.contentMode = UIViewContentModeTop;
        }
            break;
            
        case PASSBY:
        {
            icon = [UIImage imageNamed:@"address_passby"];
            _iconView.contentMode = UIViewContentModeCenter;
        }
            break;
        
            
        default:
            break;
    }
    
    _iconView.frame = CGRectMake(0, 0, icon.size.width, self.contentView.bounds.size.height);
    
    _iconView.image = icon;
    
    _addressLabel.frame = CGRectMake(25, 0, self.contentView.bounds.size.width - 25, self.contentView.bounds.size.height-2);
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
