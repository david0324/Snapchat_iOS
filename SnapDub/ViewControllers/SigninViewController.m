//
//  SigninViewController.m
//  SnapDub
//
//  Created by Poland on 06/05/15.
//  Copyright (c) 2015 Yuan. All rights reserved.
//

#import "SigninViewController.h"

#import "AppDelegate.h"
#import "DubsViewController.h"
#import "ExploreViewController.h"
#import "ActivityViewController.h"
#import "ProfileViewController.h"
#import "FuzzITTabBarController.h"
#import "DubUser.h"
#import "DubMain.h"
#import "GeneralUtility.h"

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

@interface SigninViewController ()

@end

@implementation SigninViewController
@synthesize svSignin, txtMail, txtPassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    txtMail.text = @"";
    txtPassword.text = @"";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goPolicy:(id)sender {
}

- (IBAction)processSignin:(id)sender {

     //NSLog(@"Before current DubUser %@",[DubUser CurrentDubUser].connectedParseObject.username);
    
    if ([PFUser currentUser] != nil) {
        //NSLog(@"Sign in current User is not nil User Name %@",[PFUser currentUser].username);
    }
    if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
        [PFUser logOut];
    }
    
    
    [PFUser logInWithUsernameInBackground:txtMail.text password:txtPassword.text block:^(PFUser *user, NSError *error)
     {
     if (error==nil)
     {
         [DubUser loadCurrentUserInBackgroundWithBlock:(kPFCachePolicyCacheThenNetwork) block:^(BOOL result, NSError *error) {
             //NSLog(@"After current DubUser %@",[DubUser CurrentDubUser].connectedParseObject.username);
         }];
         
         [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"Welcome!"]];
         [self.navigationController popToRootViewControllerAnimated:YES];
//     [[AppDelegate sharedInstance].userinfo initWithDataEmail: strEmail appuserid:user.objectId name:user[PF_USER_NICKNAME] photourl:user[PF_USER_PICTURE]];
//     [self openMainWindow];
     
     }
     else
     {
         [SVProgressHUD showErrorWithStatus:error.userInfo[@"error"]];
         [GeneralUtility popupMessage:@"Error" message: @"Please make sure you connect to the internet and enter the correct email and password and try again."];
     }
     }];
    
 
}

- (IBAction)goForgot:(id)sender {
    [self performSegueWithIdentifier:@"goforgot" sender:nil];
}

- (IBAction)processLoginFB:(id)sender {
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
                      //[PFUser currentUser][PF_USER_PICTURE]  = photo;
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
                 //NSLog(@"Saving Current User result %d", succeeded);
             }];
             [DubUser loadCurrentUserInBackgroundWithBlock:(kPFCachePolicyCacheThenNetwork) block:^(BOOL result, NSError *error) {
                 //NSLog(@"After Facebook current DubUser %@",[DubUser CurrentDubUser].connectedParseObject.username);
             }];
         }
     }];
}
//*****************************************************************//
/*
- (void)requestFacebook:(PFUser *)user
{
//    FBRequest *request = [FBRequest requestForMe];
//    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
//     {
//         if (error == nil)
//         {
//             NSDictionary *userData = (NSDictionary *)result;
//             [self processFacebook:user UserData:userData];
//         }
//         else
//         {
//             [PFUser logOut];
//             [SVProgressHUD showErrorWithStatus:@"Failed to fetch Facebook user data."];
//         }
//     }];
}

- (void)processFacebook:(PFUser *)user UserData:(NSDictionary *)userData

{
    NSString *link = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", userData[@"id"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:link]];
       AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
 
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         UIImage *image = (UIImage *)responseObject;

         if (image.size.width > 140) image = ResizeImage(image, 140, 140);

         PFFile *filePicture = [PFFile fileWithName:@"photo.jpg" data:UIImageJPEGRepresentation(image, 0.9)];
         [filePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
          {
              if (error != nil) [SVProgressHUD showErrorWithStatus:@"Network error."];
          }];

         if (image.size.width > 34) image = ResizeImage(image, 34, 34);
 
         PFFile *fileThumbnail = [PFFile fileWithName:@"thumbnail.jpg" data:UIImageJPEGRepresentation(image, 0.9)];
         [fileThumbnail saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
          {
              if (error != nil) [SVProgressHUD showErrorWithStatus:@"Network error."];
          }];

         //NSLog(@"UDATE - %@",userData);
         
         user.email = userData[@"email"];
         user.username = userData[@"email"];
         user[@"nickname"]=userData[@"name"];
         user[PF_USER_PICTURE] = filePicture;
         user[PF_USER_FACEBOOKID] = userData[@"id"];

         [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
          {
              if (error == nil)
              {
                  [SVProgressHUD dismiss];
                  [[AppDelegate sharedInstance].userinfo initWithFacebookSigninData:user.email appuserid:user[PF_USER_OBJECTID] name:user[PF_USER_NICKNAME] photourl:user[PF_USER_PICTURE]];
                 // [self openMainWindow];
              }
              else
              {
                  [PFUser logOut];
                  [SVProgressHUD showErrorWithStatus:error.userInfo[@"error"]];
              }
          }];
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [PFUser logOut];
         [SVProgressHUD showErrorWithStatus:@"Failed to fetch Facebook profile picture."];
     }];

    [[NSOperationQueue mainQueue] addOperation:operation];
}
*/
//*****************************************************************//


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
        return CGSizeMake(192,60);
    }
}

//*****************************************************************//
@end
