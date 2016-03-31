//
//  FirstViewController.h
//  SnapDub
//
//  Created by Poland on 06/05/15.
//  Copyright (c) 2015 Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *backButton;


- (IBAction)processLoginFB:(id)sender;
- (IBAction)goLogin:(id)sender;
- (IBAction)goSignup:(id)sender;

@end
