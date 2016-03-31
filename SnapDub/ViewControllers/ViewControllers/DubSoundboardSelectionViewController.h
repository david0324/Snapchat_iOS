//
//  DubSoundboardSelectionViewController.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-06-29.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DubSound;
@interface DubSoundboardSelectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *dubSoundboardsTable;
@property (strong, nonatomic) DubSound* connectedSound;

@end
