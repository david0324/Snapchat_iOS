//
//  ProfileTableViewCell.h
//  SnapDub
//
//  Created by Poland on 08/05/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MessageUI.h>

@class DubVideo, DubUser, DubSound;
@interface DubsTableViewCell : UITableViewCell <UIActionSheetDelegate, MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *imgprofile;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblViews;
@property (weak, nonatomic) IBOutlet UIImageView *imgPost;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;

@property (weak, nonatomic) IBOutlet UILabel *lblLikes;
@property (weak, nonatomic) IBOutlet UILabel *lblComment;
@property (weak, nonatomic) IBOutlet UILabel *lblShare;
@property (weak, nonatomic) IBOutlet UIButton *btnDub;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet UILabel *viewWord;


@property (weak,nonatomic) AVPlayerLayer *celLayer;
@property (weak,nonatomic) AVPlayer *celPlayer;

@property (strong, nonatomic) DubVideo* connectedDubVideo;
@property (strong, nonatomic) DubUser* connectedDubUser;
@property (strong, nonatomic) DubSound* connectedDubSound;
@property (weak, nonatomic) UITableView* tableView;
@property (strong, nonatomic) UINavigationController* navController;
//@property (weak, nonatomic) UIViewController* uiController;


//@property (strong, nonatomic) IBOutlet UIView *uvVideo;

@property (weak, nonatomic) IBOutlet UIImageView *imgLike;
@property BOOL liked;
@property BOOL Paused;

-(void) cellIsSelected;
-(void) updateLikeButton;
- (IBAction)likeUnlikeClicked:(id)sender;

-(void) setConnectedDubVideo:(DubVideo *)connectedDubVideo2;
-(void) updatePosition;

-(void) playVideoIfNotBeingPlayed;
-(void) stopPlaying;
-(void) manualPausePlaying;
@end
