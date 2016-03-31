//
//  SingleUserCell.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-07-06.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DubUser;
@interface SingleUserCell : UITableViewCell
{
    BOOL isFollowing;
}

@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet PFImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (nonatomic, strong) DubUser* connectedUser;
@property (nonatomic, assign) BOOL isFollowing;

-(void) cellIsSelected;
@end
