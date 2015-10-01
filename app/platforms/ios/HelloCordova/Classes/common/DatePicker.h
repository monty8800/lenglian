//
//  DatePicker.h
//  HelloCordova
//
//  Created by ywen on 15/9/30.
//
//

#import <UIKit/UIKit.h>

@protocol DatePickerDelegate <NSObject>

@required
-(void) selectDate:(NSArray *) dateList type:(NSString *) type;

@end


@interface DatePicker : UIView
{
    NSDate *_startDate;
    NSDate *_endDate;
    UIView *_bgView;
    NSString *_type;
}
@property (assign, nonatomic) NSInteger pickerCount;
@property (weak, nonatomic) id<DatePickerDelegate> delegate;

-(void) show:(NSString *) type;
-(void) hide;


@end
