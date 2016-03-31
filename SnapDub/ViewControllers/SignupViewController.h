//
//  SignupViewController.h
//  SnapDub
//
//  Created by Poland on 06/05/15.
//  Copyright (c) 2015 Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UIImagePickerController *imagepicker;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnAddPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPass;

- (IBAction)goBack:(id)sender;
- (IBAction)processSignupFB:(id)sender;
- (IBAction)goPolicy:(id)sender;
- (IBAction)processUploadPhoto:(id)sender;
- (IBAction)processSignup:(id)sender;

@end
