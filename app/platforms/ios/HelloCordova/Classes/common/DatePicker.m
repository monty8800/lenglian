//
//  DatePicker.m
//  HelloCordova
//
//  Created by ywen on 15/9/30.
//
//

#import "DatePicker.h"
#import "Global.h"

@implementation DatePicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setPickerCount:(NSInteger)pickerCount {
    _pickerCount = pickerCount;
    self.backgroundColor = [UIColor WY_ColorWithHex:0x000000 alpha:0.3];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, SCREEN_WIDTH, 276)];
    _bgView.backgroundColor = [UIColor WY_ColorWithHex:0xffffff alpha:1];
    _bgView.alpha = 1;
    [self addSubview:_bgView];
    
    CGFloat width = ceilf(SCREEN_WIDTH / _pickerCount);
    for (int i=0; i<pickerCount; i++) {
        UIDatePicker *datePicer = [[UIDatePicker alloc] initWithFrame:CGRectMake(i * width, 0, width, 216)];
        datePicer.backgroundColor = [UIColor WY_ColorWithHex:0xffffff alpha:1];
        datePicer.minimumDate = [NSDate date];
        datePicer.maximumDate = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 365 * 2];
        datePicer.datePickerMode = UIDatePickerModeDate;
        datePicer.tag = 100 + i;

        if (i == 0) {
            _startDate = datePicer.date;
        }
        else
        {
            _endDate = datePicer.date;
        }
        [datePicer addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [_bgView addSubview:datePicer];
    }
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, _bgView.bounds.size.height - 60, SCREEN_WIDTH, 60)];
    barView.backgroundColor = [UIColor WY_ColorWithHex:0xffffff alpha:1];
    [_bgView addSubview:barView];
    
    CGFloat btnWidth = (SCREEN_WIDTH - 30) / 2;
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, btnWidth, 40)];
    [cancelBtn WY_SetBgColor:0xfe8c2b title:@"取消" titleColor:0xffffff corn:2 fontSize:18];
    [barView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - btnWidth, 10, btnWidth, 40)];
    [confirmBtn WY_SetBgColor:0x28b3ec title:@"确定" titleColor:0xffffff corn:2 fontSize:18];
    [barView addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(clickConfirm) forControlEvents:UIControlEventTouchUpInside];
}

-(void) clickCancel {
    [self hide];
}

-(void) clickConfirm {
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:_startDate, nil];
    if (_pickerCount > 1) {
        [arr addObject:_endDate];
    }
    DDLogDebug(@"select date list %@", arr);
    [self.delegate selectDate: arr type:_type];
    [self hide];
}

-(void)show:(NSString *)type {
    _type = type;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.alpha = 0;
    _bgView.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
        _bgView.frame = CGRectMake(0, self.bounds.size.height - 276, SCREEN_WIDTH, 276);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hide {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
        _bgView.alpha = 1;
        _bgView.frame = CGRectMake(0, self.bounds.size.height, SCREEN_WIDTH, 216);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void) dateChanged:(UIDatePicker *) picker {
    DDLogDebug(@"date--%@", picker.date);
    if (picker.tag == 100) {
        _startDate = picker.date;
    }
    else
    {
        _endDate = picker.date;
    }
    
    if (_endDate && _endDate.timeIntervalSince1970 < _startDate.timeIntervalSince1970) {
        UIDatePicker *endPicker = (UIDatePicker *)[_bgView viewWithTag:101];
        [endPicker setDate:_startDate animated:YES];
        _endDate = endPicker.date;
    }
}


@end
