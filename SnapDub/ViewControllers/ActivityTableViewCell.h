//
//  ActivityTableViewCell.h
//  SnapDub
//
//  Created by Poland on 08/05/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DubAudioPlayer.h"

@class DubSound, UserActivity;
enum audioState {PAUSE, LOADING, PLAYING};

@interface ActivityTableViewCell : UITableViewCell<DubAudioPlayerDelegate, UIActionSheetDelegate>
{
    enum audioState currentState;
}

@property (strong, nonatomic) IBOutlet PFImageView *imgUser;
@property (strong, nonatomic) IBOutlet UILabel *lblName;

@property (strong, nonatomic) IBOutlet UILabel *lblComment;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UIButton *btnFav;
@property (strong, nonatomic) IBOutlet UIButton *btnMore;
@property (strong, nonatomic) IBOutlet UIButton *btnPlay;

@property (strong, nonatomic) UserActivity* connectedActivity;
@property (strong, nonatomic) DubSound* sound;

-(void) setConnectedActivity:(UserActivity *)connectedActivity2;
-(void) cellIsSelected;
@end
