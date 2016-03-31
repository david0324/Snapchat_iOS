//
//  SingleUserCell.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-07-06.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "SingleUserCell.h"
#import "DubUser.h"
#import "DubUserActivityParseHelper.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "GeneralUtility.h"

@implementation SingleUserCell
@synthesize followButton, userImage, userName, connectedUser, isFollowing;

- (void)awakeFromNib {
    // Initialization code
}

-(void) setIsFollowing:(BOOL)isFollowing2
{
    isFollowing = isFollowing2;
    
    if(isFollowing)
    {
        [followButton setImage:[UIImage imageNamed:@"Following"] forState:UIControlStateNormal];

    }else
    {
        [followButton setImage:[UIImage imageNamed:@"Follow"] forState:UIControlStateNormal];
 
    }
}

- (IBAction)followClicked:(id)sender {
    self.isFollowing = !isFollowing;
    
    if(isFollowing)
    {
        [self.connectedUser follow];
    }else
    {
       [self.connectedUser unfollow];
    }
}

-(void) setConnectedUser:(DubUser *)connectedUser2
{
    connectedUser = connectedUser2;
    
    if([connectedUser isTheSameUser: [DubUser CurrentDubUser]])
    {
        followButton.hidden = YES;
    }else
    {
        followButton.hidden = NO;
    }
    
    self.userName.text = connectedUser.profileName;
    
    self.userImage.file = connectedUser.profileImagePFFile;
    
    self.userImage.hidden = YES;
    
    self.isFollowing = [connectedUser isFollowedByCurrentUser];
    
    [self.userImage loadInBackground:^(UIImage *image, NSError *error) {
        if(!error)
        {
            self.userImage.hidden = NO;
            
            [GeneralUtility processUserImage: self.userImage];
        }
    }];
}

-(void) cellIsSelected
{
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    ProfileViewController *controller = [delegate.navi.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    
    [controller setConnectedDubUser: self.connectedUser];
    controller.hidesBottomBarWhenPushed = YES;
    
    [GeneralUtility pushViewController: controller animated: YES];
    
    self.selected = NO;
}

@end
