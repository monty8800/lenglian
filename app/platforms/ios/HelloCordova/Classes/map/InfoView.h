//
//  InfoView.h
//  HelloCordova
//
//  Created by ywen on 15/10/2.
//
//

#import <UIKit/UIKit.h>

@interface InfoView : UIView<UITableViewDataSource, UITableViewDelegate>
{
}

@property (strong, nonatomic) NSArray *dataList;
@property (strong, nonatomic) UITableView *tabView;

@end
