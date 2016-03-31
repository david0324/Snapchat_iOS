//
//  CategorySelectionCell.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-07-08.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "CategorySelectionCell.h"

@implementation CategorySelectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) setCategoryIsSelected: (BOOL) m
{
    if(m)
    {
        _selectedLabel.hidden = NO;
        _categoryLabel.textColor = [UIColor redColor];
    }else
    {
        _selectedLabel.hidden = YES;
        _categoryLabel.textColor = [UIColor blackColor];
    }
}
@end
