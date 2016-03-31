//
//  FollowTableViewCell.h
//  SnapDub
//
//  Created by Infinidy_jiawei on 2015-06-22.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserActivity;
@interface FollowTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *follow_followed_CellButton;

@property (strong, nonatomic) IBOutlet PFImageView *imgUser;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet PFImageView *imgFollower;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerName;

@property (nonatomic, strong) UserActivity* connectedActivity;

-(void) cellIsSelected;

@end
