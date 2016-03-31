//
//  CommentTableViewCell.m
//  SnapDub
//
//  Created by Moin' Victor on 5/23/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "DubUser.h"

@implementation CommentTableViewCell
@synthesize imageView, commentField, dateLabel, connectedUser;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setConnectedUser:(DubUser *)connectedUser2
{
    connectedUser = connectedUser2;
    _userName.text = @"User";
    _userIcon.image = [UIImage imageNamed: @"defaultUser.png"];
    
     _userIcon.image = [UIImage imageNamed: @"defaultUser.png"];
    if(connectedUser2.profileImagePFFile.url)
    {
        _userIcon.file = connectedUser2.profileImagePFFile;
        [_userIcon loadInBackground];
    }else
    {
        //NSLog(@"comment cell: USER has NO image! - %@", connectedUser2.profileName);
        _userIcon.image = [UIImage imageNamed: @"defaultUser.png"];
    }
    
    if(connectedUser2.profileName && connectedUser2.profileName.length>0)
    {
        _userName.text = connectedUser2.profileName;
    }else
    {
        _userName.text = @"User";
    }
}

@end
