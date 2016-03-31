//
//  ActivityViewController.h
//  SnapDub
//
//  Created by Poland on 06/05/15.
//  Copyright (c) 2015 Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFLoadingView.h"

@interface ActivityViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray* activities;
    int pageNum;
    BOOL shouldStopLoadMore;
    BOOL initialized;
    UIRefreshControl* refreshController;
}
@property (weak, nonatomic) IBOutlet UITableView *tvActivity;
@property (nonatomic, strong) PFLoadingView *loadingView;

@end
