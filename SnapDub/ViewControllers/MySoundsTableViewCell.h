//
//  MySoundsTableViewCell.h
//  SnapDub
//
//  Created by Moin' Victor on 5/30/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DubSoundBoard.h"
#import "PFImageLoadingView.h"

@interface MySoundsTableViewCell : UITableViewCell
    @property (weak, nonatomic) IBOutlet UILabel *lblName;
    @property (weak, nonatomic) IBOutlet UIButton *btnInfo;
    @property (weak, nonatomic) IBOutlet UILabel *creatorLabel;
    @property (weak, nonatomic) IBOutlet PFImageLoadingView *iconImage;
@property (weak, nonatomic) UIViewController* uiController;
@property (strong, nonatomic) DubSoundBoard* connectedDubSoundboard;

-(void) setConnectedDubSoundboard:(DubSoundBoard*) board;
-(void) setIconImageFileName: (NSString*) name;
-(void) cellIsSelected;
@end
