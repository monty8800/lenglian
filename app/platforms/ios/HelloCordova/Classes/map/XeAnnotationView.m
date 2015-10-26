//
//  XeAnnotationView.m
//  HelloCordova
//
//  Created by ywen on 15/10/1.
//
//

#import "XeAnnotationView.h"

@implementation XeAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)setType:(XeAnnoType)type {
    _type = type;
    [self createUI];
}

-(void) createUI {
    UIImage *image;
    switch (_type) {
        case CAR:
            image = [UIImage imageNamed:@"map_car"];
            break;
            
        case GOODS:
            image = [UIImage imageNamed:@"map_goods"];
            break;
            
        case WAREHOUSE:
            image = [UIImage imageNamed:@"map_warehouse"];
            break;
            
        case GOODS_NEED_WAREHOUSE:
            image = [UIImage imageNamed:@"map_goods_need_warehouse"];
            break;
            
        case POINT:
            
        default:
            image = [UIImage imageNamed:@"map_point"];
            break;
    }
    if (_imageView == nil) {
        self.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
    }
    
    _imageView.image = image;
   
}

-(void)setData:(NSDictionary *)data {
    _data = data;
}

@end
