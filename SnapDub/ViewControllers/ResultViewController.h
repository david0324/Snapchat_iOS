//
//  ResultViewController.h
//  SnapDub
//
//  Created by Poland on 08/05/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>

//@property (weak, nonatomic) IBOutlet UISegmentedControl *usExplore;
//@property (weak, nonatomic) IBOutlet UIView *uvTable;
@property (weak, nonatomic) IBOutlet UITableView *tvExplore;
//@property (weak, nonatomic) IBOutlet UIView *uvCollection;

- (IBAction)commentClicked:(id)sender;

@end
