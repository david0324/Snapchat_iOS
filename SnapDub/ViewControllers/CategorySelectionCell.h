//
//  CategorySelectionCell.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-07-08.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategorySelectionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedLabel;

-(void) setCategoryIsSelected: (BOOL) m;
@end
