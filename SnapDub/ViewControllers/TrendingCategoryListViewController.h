//
//  TrendingCategoryLisTiewController.h
//  SnapDub
//
//  Created by Moin' Victor on 5/21/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFLoadingView.h"

#define SOUNDS_IN_SOUNDBOARD_MODE 0
#define CATEGORY_FEATURE_MODE 1
#define USER_CREATED_SOUNDS_MODE 2
#define USER_FAV_SOUNDS_MODE 3
#define LIST_OF_SOUNDBOARD_MODE 4

@class DubSoundBoard, DubCategory, DubUser;

@interface TrendingCategoryListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
{
    DubSoundBoard* connectedSoundBoard;
    DubCategory* connectedDubCategory;
    DubUser* dubUser;
    NSMutableArray* soundList;
    NSArray* soundboardList;
    int pageNum;
    BOOL shouldStopLoadMore;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) DubCategory* connectedDubCategory;
@property (nonatomic, strong) DubSoundBoard* connectedSoundBoard;
@property (nonatomic, strong) DubUser* dubUser;
@property (nonatomic, strong) PFLoadingView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *theTitle;
@property (nonatomic, assign) int mode;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;



- (IBAction)backButtonClicked:(id)sender;

- (IBAction)clickedMoreButtonInCell:(id)sender;

@end
