//
//  ActivVideoTableViewCell.m
//  SnapDub
//
//  Created by Infinidy_jiawei on 2015-06-23.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "ActivVideoTableViewCell.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "UserActivity.h"
#import "DubUser.h"
#import "SDConstants.h"
#import "GeneralUtility.h"
#import "DubVideoViewController.h"

@implementation ActivVideoTableViewCell

@synthesize imgUser,imgVideo,lblName,lblTime,lblComment, connectedActivity;


- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectUser)];
    singleTap.numberOfTapsRequired = 1;
    [self.imgUser setUserInteractionEnabled:YES];
    [self.imgUser addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectUser)];
    singleTap2.numberOfTapsRequired = 1;
    [self.lblName setUserInteractionEnabled:YES];
    [self.lblName addGestureRecognizer:singleTap2];
    
    UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectVideo)];
    singleTap3.numberOfTapsRequired = 1;
    [self.imgVideo setUserInteractionEnabled:YES];
    [self.imgVideo addGestureRecognizer:singleTap3];

}

-(void) setConnectedActivity:(UserActivity *)connectedActivity2
{
    connectedActivity = connectedActivity2;
    
    DubUser* fromUser = connectedActivity.fromUserRef;
    
    
    self.imgUser.file = fromUser.profileImagePFFile;
    [self.imgUser setHidden: YES];
    
    self.lblName.text = fromUser.profileName;
    self.lblTime.text = [GeneralUtility getDateDiffString: connectedActivity.createdAt];
    
    if( [connectedActivity.activityType isEqualToString: kSDUserActivityActivityTypePostADubVideoValue] )
    {
        self.lblComment.text = @"posted a dubVideo.";
    }else
    {
        self.lblComment.text = @"liked a dubSound.";
    }
    
    [self.imgUser loadInBackground:^(UIImage *image, NSError *error) {
        if(!error)
        {
            [self.imgUser setHidden: NO];
            
            [GeneralUtility processUserImage: self.imgUser];
        }
    }];
}

-(void) cellIsSelected
{
    [self selectVideo];
}

-(void)selectVideo{
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    DubVideoViewController *controller = [delegate.navi.storyboard instantiateViewControllerWithIdentifier:@"DubVideoViewController"];
    
    [controller setConnectedDubVideo: self.connectedActivity.videoRef];
    controller.hidesBottomBarWhenPushed = YES;
    
    [GeneralUtility pushViewController: controller animated: YES];
    
    self.selected = NO;
}

-(void)selectUser{
    
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    ProfileViewController *controller = [delegate.navi.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    
    [controller setConnectedDubUser: connectedActivity.fromUserRef];
    controller.hidesBottomBarWhenPushed = YES;
    
    [GeneralUtility pushViewController: controller animated: YES];
    
    self.selected = NO;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
