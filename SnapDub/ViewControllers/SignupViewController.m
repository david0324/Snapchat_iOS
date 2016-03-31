//
//  SignupViewController.m
//  SnapDub
//
//  Created by Poland on 06/05/15.
//  Copyright (c) 2015 Yuan. All rights reserved.
//

#import "SignupViewController.h"

#import "AppDelegate.h"
#import "DubsViewController.h"
#import "ExploreViewController.h"
#import "ActivityViewController.h"
#import "ProfileViewController.h"
#import "FuzzITTabBarController.h"
#import "GeneralUtility.h"
#import "DubUser.h"

#import "camera.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "Utils.h"
#import "Global.h"
#import "SVProgressHUD.h"
#import <Parse/Parse.h>
#import "AppConstants.h"
#import "AFNetworking.h"
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#ifdef __IPHONE_8_0
#import <LocalAuthentication/LocalAuthentication.h>
#endif

@interface SignupViewController ()
@end

@implementation SignupViewController
@synthesize  txtEmail, txtPassword, txtConfirmPass;
@synthesize  imgPhoto, btnAddPhoto;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.imgPhoto setContentMode:UIViewContentModeScaleAspectFill];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//*****************************************************************//

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)processSignupFB:(id)sender {
    //NSLog(@"Current User Before Facebook Login %@",[PFUser currentUser].username);
    
    NSArray *Permissions = @[@"email",@"public_profile",@"user_friends",@"user_about_me", @"user_birthday"];
    [PFFacebookUtils logInInBackgroundWithReadPermissions:Permissions block:^(PFUser *user, NSError *error) {
        //NSLog(@"Current User After Facebook Login %@ permissions %@",[PFUser currentUser].username,[FBSDKAccessToken currentAccessToken].permissions);
        if (!user) {
            //NSLog(@"ERROR: Facebook Login user nil %@",error.description);
        }
        else{
            
            [self loadFaceBookData];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }];
}

-(void) loadFaceBookData{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters: @{@"fields" : @"email,name,id,picture"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             //NSLog(@"fetched user:%@", result);
             [PFUser currentUser].username = result[@"name"];
             [PFUser currentUser][@"profileName"] = result[@"name"];
             [PFUser currentUser].email = result[@"email"];
             
             
             NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", result[@"id"]]];
             NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
             
             // Run network request asynchronously
             [NSURLConnection sendAsynchronousRequest:urlRequest
                                                queue:[NSOperationQueue mainQueue]
                                    completionHandler:
              ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                  if (connectionError == nil && data != nil) {
                      PFFile *photo=[PFFile fileWithName:@"photo.jpg" data:data];
                      [PFUser currentUser][PF_USER_PICTURE]  = photo;
                      [PFUser currentUser][@"profileImage"] = photo;
                      
                      [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                          //NSLog(@"Save current User Image Result %d ERROR: %@",succeeded,error.description);
                      }];
                      
                      [DubUser loadCurrentUserInBackgroundWithBlock:(kPFCachePolicyCacheThenNetwork) block:^(BOOL result, NSError *error) {
                          //NSLog(@"After Facebook current DubUser %@",[DubUser CurrentDubUser].connectedParseObject.username);
                      }];
                  }
              }];
             
             [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                 // We need a saved user to do stuff.
                 //NSLog(@"Saving Current User result %@", error);
             }];
             [DubUser loadCurrentUserInBackgroundWithBlock:(kPFCachePolicyCacheThenNetwork) block:^(BOOL result, NSError *error) {
                 //NSLog(@"After Facebook current DubUser %@",[DubUser CurrentDubUser].connectedParseObject.username);
             }];
         }
     }];
}

- (IBAction)goPolicy:(id)sender {
}

- (IBAction)processUploadPhoto:(id)sender {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take",@"Load", nil];
    [action showInView:self.view];
}

- (IBAction)processSignup:(id)sender {
//    [self hideKeyboard];
    
    if (![AppDelegate isConnectedToInternet])
    {
        [AppDelegate showMessage:@"Please connect to internet.!" withTitle:@"Error"];
        return;
    }
        
    NSString *strName = txtConfirmPass.text;
    if (strName.length < 1)
    {
        [AppDelegate showMessage:@"Please enter name!" withTitle:@"Warning"];
        return;
    }
    
    NSString *strEmail = [Utils trim:txtEmail.text];
    if (strEmail.length)
        if (![Utils isEmailAddress:strEmail])
        {
            [AppDelegate showMessage:@"Invalid Email Address!" withTitle:@"Warning"];
            return;
        }

    NSString *strPassword = txtPassword.text;
    if (strPassword.length < 1)
    {
        [AppDelegate showMessage:@"Please set Password!" withTitle:@"Warning"];
        return;
    }
    
    if ( self.imgPhoto.image == nil )
    {
        [AppDelegate showMessage:@"Please enter your Photo!" withTitle:@"Warning"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeBlack];

    
    PFUser *userObj = [PFUser user];
    
    NSData *imgData;
    if (self.imgPhoto.image.size.width>140) {
        UIImage *tmpImg = ResizeImage(self.imgPhoto.image, 140, 140);
        imgData= UIImageJPEGRepresentation(tmpImg, 0.9);
    }
    PFFile *photo=[PFFile fileWithName:@"photo.jpg" data:imgData];
    userObj.username = strEmail;
    userObj.email    = strEmail;
    userObj.password = strPassword;
    userObj[PF_USER_PICTURE]  = photo;
    userObj[@"profileImage"]  = photo;
    userObj[@"profileName"] = strName;
    
    if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
        [PFUser logOut];
    }
    
    
    [userObj signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error==nil)
        {
            [DubUser loadCurrentUserInBackgroundWithBlock:(kPFCachePolicyCacheThenNetwork) block:^(BOOL result, NSError *error) {
                //NSLog(@"Error: %@ current Dub User %@",error.description,[DubUser CurrentDubUser].connectedParseObject.username);
            }];
            
            [SVProgressHUD showSuccessWithStatus:@"Success"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            
            //NSLog(@"ERROR: %@",[error userInfo]);
            [PFUser logOut];
            [SVProgressHUD showErrorWithStatus:error.userInfo[@"error"]];
            
            [GeneralUtility popupMessage:@"Error" message:[NSString stringWithFormat: @"Error Message: %@",[error userInfo] ]];
        }
    }];

    return;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
        ShouldStartCamera(self, YES);
    else if (buttonIndex == 1)
        ShouldStartPhotoLibrary(self, YES);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.btnAddPhoto.hidden = YES;
    self.imgPhoto.hidden = NO;
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [self processUserImage:self.imgPhoto];
    self.imgPhoto.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void) processUserImage:(UIImageView *)imageview
{
    imageview.layer.cornerRadius = imageview.frame.size.height / 2;
    imageview.layer.masksToBounds = YES;
    imageview.layer.borderWidth = 0;
    [imageview.layer setBorderColor:[[UIColor colorWithRed:0.0 / 255.0 green:191.0 / 255.0 blue:142.0 / 255.0 alpha:1.0] CGColor]];
    float fBorderWidth = imageview.frame.size.height / 50;
    [imageview.layer setBorderWidth:fBorderWidth];
}

-(void)openMainWindow{
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    appdelegate.window.rootViewController = [[UIStoryboard storyboardWithName:@"mainTabBar" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
}

#pragma mark - NGTabBarControllerDelegate

- (CGSize)tabBarController:(NGTabBarController *)tabBarController
sizeOfItemForViewController:(UIViewController *)viewController
                   atIndex:(NSUInteger)index
                  position:(NGTabBarPosition)position
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        return CGSizeMake(80,60);
    }
    else
    {
        return CGSizeMake(192,64);
    }
}

@end