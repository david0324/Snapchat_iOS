//
//  TrendingCollectionViewCell.h
//  SnapDub
//
//  Created by Moin' Victor on 5/20/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFImageLoadingView.h"

@class DubSoundBoard;
@interface TrendCategoryCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelView;
@property (weak, nonatomic) IBOutlet PFImageLoadingView *iconView;
@property (strong, nonatomic) DubSoundBoard* soundBoard;

-(void) setConnectedSoundBoard: (DubSoundBoard*) board;
@end
