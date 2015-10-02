//
//  InfoTableViewCell.m
//  HelloCordova
//
//  Created by ywen on 15/10/2.
//
//

#import "InfoTableViewCell.h"
#import "Global.h"

@implementation InfoTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void) createUI {
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, 18)];
    _infoLabel.textColor = [UIColor WY_ColorWithHex:0x666666];
    _infoLabel.font = [UIFont systemFontOfSize:13];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:_infoLabel];
}

-(void)setInfoText:(NSString *)infoText {
    _infoText = infoText;
    if ([_infoText isKindOfClass:[NSAttributedString class]]) {
        _infoLabel.attributedText = (NSAttributedString *)infoText;
    }
    else
    {
        _infoLabel.text = infoText;
    }
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
