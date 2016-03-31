//
//  LatestTableViewCell.h
//  SnapDub
//
//  Created by Moin' on 07/05/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DubAudioPlayer.h"
#import "MMPopLabel.h"
#import "AMPopTip.h"
#import <MessageUI/MessageUI.h>

@class DubSound, MPCoachMarks, DGActivityIndicatorView;
enum audioState {PAUSE, LOADING, PLAYING};

@interface SoundTableViewCell : UITableViewCell <DubAudioPlayerDelegate, UIActionSheetDelegate, AVAudioPlayerDelegate, MFMessageComposeViewControllerDelegate>
{
     enum audioState currentState;
    DGActivityIndicatorView *activityIndicatorView;
    DGActivityIndicatorView *videoIndicatorView;
    
    int colorInt;
    BOOL stopChangingColor;
    
    BOOL isTutorialCell;
    int theIndex;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIButton *userButton;

@property (weak, nonatomic) IBOutlet UIButton *btnStar;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;
@property (strong, nonatomic) DubSound* connectedDubSound;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AMPopTip *popTip;
@property (weak, nonatomic) IBOutlet UIView *hiddenView;
@property (weak, nonatomic) UITableView* theTableView;
@property (nonatomic, assign)BOOL isTutorialCell;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *backgroundLabel;
@property (strong, nonatomic) UINavigationController* navController;

-(void) setCellUIAtIndex:(NSInteger*) index name: (NSString*) name favorited:(BOOL) fav moreText: (NSString*) more;

- (IBAction)starClicked:(id)sender;
-(void) setConnectedDubSound: (DubSound*) sound;
-(void) cellIsSelected;
-(void) showTutorialIndicator;
-(void) showTutorial;

-(void) dismissPlaySoundIndicator;
-(void) showPlaySoundIndicator;
-(void) showVideoIndicator;
-(void) dismissVideoIndicator;

-(void) changingColor;
-(void) setIndex: (int) index;
@end
