//
//  ForgotViewController.h
//  SnapDub
//
//  Created by Poland on 06/05/15.
//  Copyright (c) 2015 Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
- (IBAction)goBack:(id)sender;
- (IBAction)processSend:(id)sender;

@end
