//
//  CommentViewController.h
//  SnapDub
//
//  Created by Poland on 08/05/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFLoadingView.h"

@interface CommentViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    int pageNum;
    BOOL shouldStopLoadMore;
    NSMutableArray* commentsList;
    
    CGSize theKBSize;
    BOOL hasScrolled;
    BOOL hasInitial;
    
    int tempIndex;
    int numNewCell;
}

@property (strong, nonatomic) IBOutlet UITextField *txtComment;
@property (strong, nonatomic) IBOutlet UITableView *tvComment;
@property (strong, nonatomic) IBOutlet UIButton *btnSend;

@property (strong, nonatomic) IBOutlet UIView *uvComment;

@property (strong, nonatomic) PFObject* connectedDubVideo;
@property (nonatomic, strong) PFLoadingView *loadingView;
@end
