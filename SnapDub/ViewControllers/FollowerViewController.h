//
//  FollowerViewController.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-07-06.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFLoadingView.h"

#define FOLLOWERS_MODE 0
#define FOLLOWINGS_MODE 1

@class DubUser;
@interface FollowerViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray* usersList;
    int pageNum;
    BOOL shouldStopLoadMore;
    BOOL initialized;
}


@property (weak, nonatomic) IBOutlet UITableView *userTable;
@property (nonatomic, strong) PFLoadingView *loadingView;
@property (nonatomic, assign) int mode;
@property (nonatomic, strong) DubUser* connectedUser;

@end
