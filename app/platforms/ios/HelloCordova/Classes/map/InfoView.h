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
    UITableView *_tabView;
}

@property (strong, nonatomic) NSArray *dataList;

@end
