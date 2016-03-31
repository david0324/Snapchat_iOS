//
//  ForgotViewController.m
//  SnapDub
//
//  Created by Poland on 06/05/15.
//  Copyright (c) 2015 Yuan. All rights reserved.
//

#import "ForgotViewController.h"
#import "AppDelegate.h"
#import "DubsViewController.h"
#import "ExploreViewController.h"
#import "ActivityViewController.h"
#import "ProfileViewController.h"
#import "FuzzITTabBarController.h"

#import "TPKeyboardAvoidingScrollView.h"
#import "Utils.h"
#import "Global.h"
#import "SVProgressHUD.h"
#import <Parse/Parse.h>
#import "AppConstants.h"
#import "AFNetworking.h"
//#import <ParseFacebookUtils/PFFacebookUtils.h>
#ifdef __IPHONE_8_0
#import <LocalAuthentication/LocalAuthentication.h>
#endif

@interface ForgotViewController ()

@end

@implementation ForgotViewController
@synthesize txtEmail;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)processSend:(id)sender {
    if (![AppDelegate isConnectedToInternet])
    {
        [AppDelegate showMessage:@"Please connect to Internet.!" withTitle:@"Error"];
        return;
    }
    
    NSString *strEmail = [Utils trim:txtEmail.text];
    if (strEmail.length)
        if (![Utils isEmailAddress:strEmail])
        {
            [AppDelegate showMessage:@"Invalid Email address!" withTitle:@"Warning"];
            return;
        }
    
    [PFUser requestPasswordResetForEmailInBackground:strEmail block:^(BOOL succeeded, NSError *error)
    {
        if (!error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mail Sent" message:@"Please check your mail." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }else
        {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error" message:[NSString stringWithFormat:@"Password reset failed: %@",errorString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }];
    
}
@end
