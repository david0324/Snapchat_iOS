//
//  CategorySelectionViewController.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-07-08.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFLoadingView.h"

#define SOUND_CATEGORY_SELECTION_MODE 0
#define EXPLORE_CATEGORY_SELECTION_MODE 1
#define VIDEO_CATEGORY_SELECTION_MODE 2

@class ExploreResultViewController;
@interface CategorySelectionViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray* categoryArray;
    BOOL initialized;
    PFLoadingView* loadingView;
    BOOL timeOut;
}



@property (weak, nonatomic) IBOutlet UILabel *theTitle;
@property (weak, nonatomic) IBOutlet UITableView *categoryList;
@property (assign, nonatomic) int mode;
@property (assign, nonatomic) int selectedIndex;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) ExploreResultViewController* exploreResultViewController;

@end
