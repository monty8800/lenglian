//
//  GoodsBubbleView.m
//  HelloCordova
//
//  Created by ywen on 15/10/2.
//
//

#import "GoodsBubbleView.h"
#import "Global.h"
#import "SelectGoodsWidget.h"

@implementation GoodsBubbleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) createUI {
    [super createUI];
    _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2, 32, 32)];
    [self addSubview:_avatar];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(37, 20, 167, 18)];
    _nameLabel.font = [UIFont systemFontOfSize:18];
    _nameLabel.textColor = [UIColor WY_ColorWithHex:0x333333];
    [self addSubview:_nameLabel];
    
    _fromToView = [[FromToView alloc] initWithFrame:CGRectMake(10, 31, self.bounds.size.width-20, 64)];
    [self addSubview:_fromToView];
}

-(void)setData:(NSDictionary *)data {
//TODO: 更新界面
    [super setData:data];
}

-(void)clickBtn {
    [SelectGoodsWidget show:(id<SelectGoodsDelegate>)([Global sharedInstance].mapVC) goods:[self.data objectForKey:@"id"]];
}

@end
