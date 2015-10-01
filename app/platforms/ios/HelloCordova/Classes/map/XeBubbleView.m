//
//  XeBubbleView.m
//  HelloCordova
//
//  Created by ywen on 15/10/1.
//
//

#import "XeBubbleView.h"
#import "Global.h"

@implementation XeBubbleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}

-(void) createUI {
    _btn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 40, self.bounds.size.width, 40)];
    [_btn WY_SetBgColor:0x28b3ec title:@"抢单" titleColor:0xffffff corn:2 fontSize:19];
    [_btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn];
}

-(void) clickBtn {
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
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
    CGContextMoveToPoint(context, 0, 8);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, (self.bounds.size.width - 15) / 2, 8);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, (self.bounds.size.width - 15) / 2 + 7.5, 0);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, self.bounds.size.width - (self.bounds.size.width - 15) / 2, 8);
    CGContextAddLineToPoint(context, self.bounds.size.width-1, 8);
    
    CGContextAddLineToPoint(context, self.bounds.size.width-1, self.bounds.size.height - 45);
    CGContextAddLineToPoint(context, 0, self.bounds.size.height - 45);
    CGContextAddLineToPoint(context, 0, 8);
    //连接上面定义的坐标点
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextDrawPath(context, kCGPathFillStroke);

}

-(void)setData:(NSDictionary *)data {
    _data = data;
}

@end
