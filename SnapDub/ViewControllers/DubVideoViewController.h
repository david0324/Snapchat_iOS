//
//  DubVideoViewController.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-07-06.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DubVideo;
@interface DubVideoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *videoTable;
@property (strong, nonatomic) DubVideo* connectedDubVideo;
@end
