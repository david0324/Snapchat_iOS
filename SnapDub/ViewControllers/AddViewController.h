//
//  AddViewController.h
//  SnapDub
//
//  Created by admin on 10/8/15.
//  Copyright © 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickSoundViewController.h"
#import "ShootFirstViewController.h"
#import "ImportViewController.h"
#import "AppDelegate.h"
#import "GeneralUtility.h"

@interface AddViewController : UIViewController
{
    
}

@property (weak, nonatomic) IBOutlet UIButton *btn_picksound;
@property (weak, nonatomic) IBOutlet UIButton *btn_shootfirst;
@property (weak, nonatomic) IBOutlet UIButton *btn_import;

@end
