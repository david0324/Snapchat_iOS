//
//  SigninViewController.h
//  SnapDub
//
//  Created by Poland on 06/05/15.
//  Copyright (c) 2015 Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SigninViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *svSignin;
@property (weak, nonatomic) IBOutlet UITextField *txtMail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

- (IBAction)goBack:(id)sender;
- (IBAction)processLoginFB:(id)sender;
- (IBAction)goPolicy:(id)sender;
- (IBAction)processSignin:(id)sender;
- (IBAction)goForgot:(id)sender;

@end
