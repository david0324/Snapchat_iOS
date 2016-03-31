//
//  AddSoundTagsViewController.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-07-13.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TITokenField.h"

@interface AddSoundTagsViewController : UIViewController<TITokenFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *theField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIView *theUIView;
@property (weak, nonatomic) IBOutlet UILabel *warningMsg;

@end
