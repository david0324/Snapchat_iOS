//
//  FollowTableViewCell.m
//  SnapDub
//
//  Created by Infinidy_jiawei on 2015-06-22.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "FollowTableViewCell.h"
#import "UserActivity.h"
#import "DubUser.h"
#import "GeneralUtility.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"

@implementation FollowTableViewCell

@synthesize imgUser,imgFollower,lblTime,lblName, connectedActivity;

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
    
    UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectFollower)];
    singleTap3.numberOfTapsRequired = 1;
    [self.imgFollower setUserInteractionEnabled:YES];
    [self.imgFollower addGestureRecognizer:singleTap3];
    
    UITapGestureRecognizer *singleTap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectFollower)];
    singleTap4.numberOfTapsRequired = 1;
    [self.followerName setUserInteractionEnabled:YES];
    [self.followerName addGestureRecognizer:singleTap4];
}

-(void)selectUser{

    if(!connectedActivity.fromUserRef.connectedParseObject)
    {
        return;
    }
    
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    ProfileViewController *controller = [delegate.navi.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    
    [controller setConnectedDubUser: connectedActivity.fromUserRef];
    controller.hidesBottomBarWhenPushed = YES;
    
    [GeneralUtility pushViewController: controller animated: YES];
    
    self.selected = NO;
}

-(void)selectFollower{

    if(!connectedActivity.toUserRef.connectedParseObject)
    {
        return;
    }
    
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    ProfileViewController *controller = [delegate.navi.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    
    [controller setConnectedDubUser: connectedActivity.toUserRef];
    controller.hidesBottomBarWhenPushed = YES;
    
    [GeneralUtility pushViewController: controller animated: YES];
    
    self.selected = NO;
}

-(void) cellIsSelected
{
    [self selectFollower];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setConnectedActivity:(UserActivity *)connectedActivity2
{
    connectedActivity = connectedActivity2;
    
    DubUser* fromUser = connectedActivity.fromUserRef;
    DubUser* toUser = connectedActivity.toUserRef;
    
    self.imgUser.file = fromUser.profileImagePFFile;
    self.imgFollower.file = toUser.profileImagePFFile;
    
    [self.imgUser setHidden: YES];
    [self.imgFollower setHidden: YES];
    self.lblName.text = fromUser.profileName;
    self.followerName.text = toUser.profileName;
    self.lblTime.text = [GeneralUtility getDateDiffString: connectedActivity.createdAt];
    
    [self.imgUser loadInBackground:^(UIImage *image, NSError *error) {
        if(!error)
        {
            [self.imgUser setHidden: NO];
            
            [GeneralUtility processUserImage: self.imgUser];
        }
    }];
    
    [self.imgFollower loadInBackground:^(UIImage *image, NSError *error) {
        if(!error)
        {
            [self.imgFollower setHidden: NO];
            
            [GeneralUtility processUserImage: self.imgFollower];
        }
    }];
}
//Add by Cassandra
- (IBAction)buttonClicked:(id)sender {
    
}
//Add end

/*-(IBAction)toggleFollowClicked:(id)sender
{
    self.followed = !self.followed;
    if(self.followed)
    {
        [followButton setImage:[UIImage imageNamed:@"FollowedButton"] forState:UIControlStateNormal];
    } else
    {
        [followButton setImage:[UIImage imageNamed:@"FollowButton"] forState:UIControlStateNormal];
    }
    
}*/

@end
