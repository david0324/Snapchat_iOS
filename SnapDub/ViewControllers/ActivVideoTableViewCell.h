//
//  ActivVideoTableViewCell.h
//  SnapDub
//
//  Created by Infinidy_jiawei on 2015-06-23.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserActivity;
@interface ActivVideoTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet PFImageView *imgUser;

@property (strong, nonatomic) IBOutlet PFImageView *imgVideo;

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblComment;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;

@property (strong, nonatomic) UserActivity* connectedActivity;

-(void) cellIsSelected;
@end
