//
//  DubCategoryTableViewCell.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-06-03.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFImageLoadingView.h"
#define SHOW_VIDEO_MODE 1
@class DubSoundBoard, DubCategory;
@interface DubCategoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet PFImageLoadingView *iconImage;

@property (strong, nonatomic) DubSoundBoard* connectedSoundboard;
@property (strong, nonatomic) DubCategory* connectedCategory;
@property (weak, nonatomic) UIViewController* uiController;
@property (assign, nonatomic) int mode;

-(void) cellIsSelected;
@end
