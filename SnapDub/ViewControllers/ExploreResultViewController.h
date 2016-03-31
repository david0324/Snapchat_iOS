//
//  ResultViewController.h
//  SnapDub
//
//  Created by Poland on 08/05/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFLoadingView.h"

#define FEATURED_MODE 0
#define LATEST_MODE 1

@class DubCategory;
@interface ExploreResultViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
{
    int pageNum;
    BOOL shouldStopLoadMore;
    NSMutableArray* videosList;
    
    UIRefreshControl* refreshController;
}

@property (nonatomic, strong) PFLoadingView *loadingView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *usExplore;
@property (weak, nonatomic) IBOutlet UIView *uvTable;
@property (weak, nonatomic) IBOutlet UITableView *tvExplore;
@property (weak, nonatomic) IBOutlet UIView *uvCollection;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UILabel *theTitle;
@property (strong, nonatomic) DubCategory* category;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;

@property (assign, nonatomic) BOOL needToRefresh;


- (IBAction)commentClicked:(id)sender;

@end
