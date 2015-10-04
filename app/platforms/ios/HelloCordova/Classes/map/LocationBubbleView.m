//
//  LocationBubbleView.m
//  HelloCordova
//
//  Created by ywen on 15/10/4.
//
//

#import "LocationBubbleView.h"
#import "Global.h"

@implementation LocationBubbleView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // Drawing code
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 0.5);
    
    //设置颜色
    CGContextSetRGBStrokeColor(context, 0.3, 0.3, 0.3, 0.3);
    //开始一个起始路径
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, 0, self.bounds.size.height-8);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, (self.bounds.size.width - 15) / 2, self.bounds.size.height-8);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, (self.bounds.size.width - 15) / 2 + 7.5, self.bounds.size.height-1);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, self.bounds.size.width - (self.bounds.size.width - 15) / 2, self.bounds.size.height-8);
    CGContextAddLineToPoint(context, self.bounds.size.width-1, self.bounds.size.height-8);
    
    CGContextAddLineToPoint(context, self.bounds.size.width-1, 1);
    CGContextAddLineToPoint(context, 0, 1);
    CGContextAddLineToPoint(context, 0, self.bounds.size.height-8);
    //连接上面定义的坐标点
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextDrawPath(context, kCGPathFillStroke);
    
}


-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    
    return self;
}

-(void) createUI {
    
    self.backgroundColor = [UIColor clearColor];
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, self.bounds.size.width-20, 16)];
    _addressLabel.font = [UIFont systemFontOfSize:14];
    _addressLabel.textColor = [UIColor WY_ColorWithHex:0xfe8c34];
    _addressLabel.text = @"正在定位，请稍候。。。";
    [self addSubview:_addressLabel];
    
    _streetLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.bounds.size.width-20, 14)];
    _streetLabel.font = [UIFont systemFontOfSize:12];
    _streetLabel.textColor = [UIColor WY_ColorWithHex:0x666666];
    [self addSubview:_streetLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 51, self.bounds.size.width - 20, 1)];
    line.backgroundColor = [UIColor WY_ColorWithHex:0xececec];
    [self addSubview:line];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60, 13, 17)];
    imageView.image = [UIImage imageNamed:@"map_point"];
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(28, 61, self.bounds.size.width - 38, 14)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor WY_ColorWithHex:0x666666];
    label.text = @"长按后拖动可以修改地点";
    [self addSubview:label];
}

-(void)setAddress:(NSString *)address {
    _address = address;
    _addressLabel.text = address;
}

-(void)setStreet:(NSString *)street {
    _street = street;
    _streetLabel.text = street;
}

@end
