//
//  TrendingCollectionViewCell.m
//  SnapDub
//
//  Created by Moin' Victor on 5/20/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "TrendCategoryCollectionViewCell.h"
#import "DubSoundBoard.h"

@implementation TrendCategoryCollectionViewCell

@synthesize iconView,labelView;


- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    // Configure the view for the selected state
}

-(void) setConnectedSoundBoard: (DubSoundBoard*) board
{
    self.soundBoard = board;
    self.labelView.text = board.soundBoardName;
    self.iconView.file = board.coverImageFile;
}


@end
