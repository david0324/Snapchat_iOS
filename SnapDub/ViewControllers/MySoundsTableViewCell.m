//
//  MySoundsTableViewCell.m
//  SnapDub
//
//  Created by Moin' Victor on 5/30/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "MySoundsTableViewCell.h"
#import "DubUser.h"
#import "TrendingCategoryListViewController.h"

@implementation MySoundsTableViewCell
@synthesize lblName,creatorLabel, iconImage, uiController, connectedDubSoundboard;

- (void)awakeFromNib {
    // Initialization code
    [self setBackgroundColor:[UIColor clearColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setIconImageFileName: (NSString*) name
{
    iconImage.image = [UIImage imageNamed: name];
}

-(void) setConnectedDubSoundboard:(DubSoundBoard*) board
{
    connectedDubSoundboard = board;
    self.lblName.text = board.soundBoardName;
    
    if(board.creator)
    {
        self.creatorLabel.text = [NSString stringWithFormat: @"created by %@",board.creator.profileName];
    }else
    {
        self.creatorLabel.text = @"";
    }
    
    if(board.chosenPresetImageName)
    {
        self.iconImage.image = [UIImage imageNamed: board.chosenPresetImageName];
    }
}

-(void) cellIsSelected
{
    if(connectedDubSoundboard)
    {
        TrendingCategoryListViewController *controller = [uiController.storyboard instantiateViewControllerWithIdentifier:@"trendingCategoryList"];
        
        controller.connectedSoundBoard = self.connectedDubSoundboard;
        controller.mode = SOUNDS_IN_SOUNDBOARD_MODE;
        
        [uiController.navigationController pushViewController:controller animated:YES];
    }

}

@end
