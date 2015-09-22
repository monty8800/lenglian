//
//  SelectTab.m
//  HelloCordova
//
//  Created by ywen on 15/9/22.
//
//

#import "SelectTab.h"
#import "Global.h"

@implementation SelectTab

-(void)setTabs:(NSArray *)tabs {
    
    _tabs = tabs;
    [self createUI];
}


-(void) createUI {
    self.backgroundColor = [UIColor whiteColor];
    self.translatesAutoresizingMaskIntoConstraints = YES;
    
    CGFloat tabWidth = self.bounds.size.width / _tabs.count;
    
    UIView *border = [[UIView alloc] init];
    border.backgroundColor = [UIColor WY_ColorWithHex:0xe6e6e6];
    border.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:border];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[border]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(border)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[border(0.5)]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(border)]];
    
    for (int i=0; i<_tabs.count; i++) {
        NSString *tab = _tabs[i];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor WY_ColorWithHex:0xe6e6e6];
        line.translatesAutoresizingMaskIntoConstraints = NO;
        
        if (i < _tabs.count - 1) {
            [self addSubview:line];
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(left)-[line(0.5)]"
                                                                         options:0
                                                                         metrics:@{@"left": @(tabWidth * (i+1))}
                                                                           views:NSDictionaryOfVariableBindings(line)]];
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[line]-8-|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:NSDictionaryOfVariableBindings(line)]];
        }
        
        UIButton *btn = [UIButton new];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        [btn setTitle:tab forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor WY_ColorWithHex:0x2e2e2e] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor WY_ColorWithHex:0x28b3ec] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor WY_ColorWithHex:0x28b3ec] forState:UIControlStateHighlighted];
        btn.tag = 100 + i;
        btn.titleLabel.font = [UIFont systemFontOfSize:ceilf(14 * REALSCREEN_MULTIPBY)];
        [btn addTarget:self action:@selector(clickTab:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(left)-[btn(width)]"
                                                                    options:0
                                                                    metrics:@{@"left": @(tabWidth * i), @"width": @(tabWidth)}
                                                                      views:NSDictionaryOfVariableBindings(btn)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[btn]-0-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(btn)]];
        
        if (i == 0) {
            _selectTab = btn;
            _selectTab.selected = YES;
        }
        
    }
    
    _tabLine = [[UIView alloc] init];
    _tabLine.translatesAutoresizingMaskIntoConstraints = NO;
    _tabLine.backgroundColor = [UIColor WY_ColorWithHex:0x28b3ec];
    [self addSubview:_tabLine];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_tabLine(2)]-0-|"
                                                                options:0
                                                                metrics:@{}
                                                                   views:NSDictionaryOfVariableBindings(_tabLine)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_tabLine(width)]"
                                                                 options:0
                                                                 metrics:@{@"width": @(ceilf(74 * REALSCREEN_MULTIPBY))}
                                                                   views:NSDictionaryOfVariableBindings(_tabLine)]];
    _linePosition = [NSLayoutConstraint constraintWithItem:_tabLine
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_selectTab
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0];
    [self addConstraint:_linePosition];
    
}

-(void) clickTab:(UIButton *) btn {
    if (btn != _selectTab) {
        _selectTab.selected = NO;
        _selectTab = btn;
        _selectTab.selected = YES;
        CGFloat tabWidth = self.bounds.size.width / _tabs.count;
        _linePosition.constant = ceilf(tabWidth * (btn.tag - 100));
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
        }];
        
    }
    [self.delegate selectTab:btn.tag - 100];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
