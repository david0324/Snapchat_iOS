//
//  CommentTableViewCell.h
//  SnapDub
//
//  Created by Moin' Victor on 5/23/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFImageLoadingView.h"
@class DubUser;

@interface CommentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *commentField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet PFImageLoadingView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (nonatomic, strong) DubUser* connectedUser;
@end
