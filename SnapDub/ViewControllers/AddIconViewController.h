//
//  AddIconViewController.h
//  SnapDub
//
//  Created by Poland on 07/05/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFLoadingView.h"

@interface AddIconViewController : UIViewController
<UICollectionViewDelegate,UICollectionViewDataSource>
{
    BOOL timeOut;
    PFLoadingView* loadingView;
}

    @property NSIndexPath * selectedItemIndexPath;
    @property NSArray * images;

@property (nonatomic, strong) NSString* soundBoardName;
@end
