//
//  ProfileViewController.h
//  SnapDub
//
//  Created by Poland on 06/05/15.
//  Copyright (c) 2015 Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFLoadingView.h"

@class DubUser, BDBSpinKitRefreshControl;
@interface ProfileViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray* recentSounds;
    
    NSMutableArray* videoList;
    int pageNum;
    BOOL shouldStopLoadingMore;
    BOOL initialized;
    
    BDBSpinKitRefreshControl* spinControler;
    UIRefreshControl* refreshController;
    
    int theNumFollowing;
    int theNumFollower;
}

@property (nonatomic, strong) PFLoadingView *loadingView;
@property (weak, nonatomic) IBOutlet UITableView *tvProfile;
@property (weak, nonatomic) IBOutlet PFImageView *imgBackground;
@property (weak, nonatomic) IBOutlet PFImageView *imgprofile;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowers;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowing;
@property (weak, nonatomic) IBOutlet UILabel *lblname;

@property (weak, nonatomic) IBOutlet UILabel *lblPosts;
@property (weak, nonatomic) IBOutlet UILabel *lblLikes;
@property (strong, nonatomic) DubUser* connectedDubUser;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

@property (strong, nonatomic) NSMutableArray* objects;
@property (weak, nonatomic) IBOutlet UIButton *followerButton;
@property (weak, nonatomic) IBOutlet UIButton *followingButton;

- (IBAction)toggleFollowClicked:(id)sender;
//- (IBAction)commentClicked:(id)sender;
@property BOOL followed;

-(void) updateFollowButton;
@end
