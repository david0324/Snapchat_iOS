

//
//  ExploreViewController.h
//  SnapDub
//
//  Created by Poland on 06/05/15.
//  Copyright (c) 2015 Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFLoadingView.h"

@interface ExploreViewController : UIViewController
<UITableViewDataSource ,UITableViewDelegate,UIGestureRecognizerDelegate>
{
     NSArray* categoryList;
}

@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (strong, nonatomic) IBOutlet UITableView *thetableView;
@property (strong, nonatomic) IBOutlet UIButton * popularButton;
@property (strong, nonatomic) IBOutlet UIButton * onTheRiseButton;
@property (strong, nonatomic) IBOutlet UIButton * animalsButton;
@property (strong, nonatomic) IBOutlet UIButton * cartoonButton;
@property (nonatomic, strong) PFLoadingView *loadingView;
@end
