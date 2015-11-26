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
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 216)];
    _datePicker.backgroundColor = [UIColor WY_ColorWithHex:0xffffff alpha:1];
    _datePicker.minimumDate = [NSDate date];
    _datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 365 * 2];
    _datePicker.datePickerMode = UIDatePickerModeDate;

    
    _startDate = _endDate = _datePicker.date;
    
//    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [_bgView addSubview:_datePicker];
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, _bgView.bounds.size.height - 60, SCREEN_WIDTH, 60)];
    barView.backgroundColor = [UIColor WY_ColorWithHex:0xffffff alpha:1];
    [_bgView addSubview:barView];
    
    CGFloat btnWidth = (SCREEN_WIDTH - 30) / 2;
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, btnWidth, 40)];
    [cancelBtn WY_SetBgColor:0xfe8c2b title:@"取消" titleColor:0xffffff corn:2 fontSize:18];
    [barView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    
    _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - btnWidth, 10, btnWidth, 40)];
    
    NSString *btnTitle = pickerCount > 1 ? @"开始时间" : @"确定";
    [_confirmBtn WY_SetBgColor:0x28b3ec title:btnTitle titleColor:0xffffff corn:2 fontSize:18];
    [barView addSubview:_confirmBtn];
    [_confirmBtn addTarget:self action:@selector(clickConfirm:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) clickCancel {
    [self hide];
}

-(void) clickConfirm:(UIButton *) btn {
    if ([btn.titleLabel.text isEqualToString:@"开始时间"]) {
        [btn setTitle:@"结束时间" forState:UIControlStateNormal];
        _startDate = _datePicker.date;
        _datePicker.minimumDate = _startDate;
    }
    else if ([btn.titleLabel.text isEqualToString:@"结束时间"])
    {
        _endDate = _datePicker.date;
        [self.delegate selectDate: @[_startDate, _endDate] type:_type];
        [self hide];
        [btn setTitle:@"开始时间" forState:UIControlStateNormal];
        _datePicker.minimumDate = [NSDate date];
    }
    else
    {
        [self.delegate selectDate:@[_datePicker.date] type:_type];
        [self hide];
    }
    
    
}

-(void)show:(NSString *)type {
    _type = type;
    if ([type isEqualToString:@"install"]) {
        _datePicker.minimumDate = [NSDate date];
    }else if ([type isEqualToString:@"arrive"]){
        if (_startDate) {
            _datePicker.minimumDate = _startDate;
        }
    }
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
        
        _datePicker.minimumDate = [NSDate date];
        NSString *btnTitle = _pickerCount > 1 ? @"开始时间" : @"确定";
        [_confirmBtn setTitle:btnTitle forState:UIControlStateNormal];
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
