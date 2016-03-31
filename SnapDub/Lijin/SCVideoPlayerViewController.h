//
//  SCVideoPlayerViewController.h
//  SCAudioVideoRecorder
//
//  Created by Simon CORSIN on 8/30/13.
//  Copyright (c) 2013 rFlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCVideoPlayerView.h"
#import "SCRecorder.h"
#import "DubsViewController.h"
#import "ShootFirstViewController.h"
#import "ACPScrollMenu.h"
@interface SCVideoPlayerViewController : UIViewController<SCPlayerDelegate,UITextFieldDelegate,ACPScrollDelegate>
{
    ACPItem *theFilterItem;
    BOOL isshown;
    BOOL istimeshown;
}
@property (nonatomic, retain) IBOutlet UIView *videoPlayingView;

@property (strong, nonatomic) SCRecordSession *recordSession;
@property (weak, nonatomic) IBOutlet SCSwipeableFilterView *filterSwitcherView;
@property (weak, nonatomic) IBOutlet UITextField *txt_videotitle;

@property (strong, nonatomic) ACPScrollMenu *scrollView;
@property (strong, nonatomic) IBOutlet UIView *filter_scroll;

@property (strong, nonatomic) IBOutlet UIView *time_scroll;

@property (strong, nonatomic) IBOutlet UILabel *lbl_title;
@property (strong, nonatomic) IBOutlet UIButton *btn_confirm;


@end
