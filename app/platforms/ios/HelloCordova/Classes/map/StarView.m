//
//  StarView.m
//  HelloCordova
//
//  Created by ywen on 15/10/21.
//
//

#import "StarView.h"

@implementation StarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void) createUI {
    _fullStar = [UIImage imageNamed:@"star"];
    _emptyStar = [UIImage imageNamed:@"star_empty"];
    _halfStar = [[UIImage imageNamed:@"star_half"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    for (int i=0; i<5; i++) {
        UIImageView *starView = [[UIImageView alloc] initWithFrame:CGRectMake(0+i*15, 0, 15, 15)];
        starView.tag = 100 + i;
        [self addSubview:starView];
    }
}

-(void)setScore:(NSInteger)score {
    _score = score;
    
    NSInteger starCount = score / 2;
    
    int i = 0;
    while (i<starCount) {
        UIImageView *starView = (UIImageView *)[self viewWithTag:100+i];
        starView.image = _fullStar;
        i++;
    }
    if (score % 2 != 0) {
        UIImageView *starView = (UIImageView *)[self viewWithTag:100+i];
        starView.image = _halfStar;
        i++;
    }
    while (i<5) {
        UIImageView *starView = (UIImageView *)[self viewWithTag:100+i];
        starView.image = _emptyStar;
        i++;
    }
}


@end
