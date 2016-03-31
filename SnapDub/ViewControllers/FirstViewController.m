//
//  FirstViewController.m
//  SnapDub
//
//  Created by Poland on 06/05/15.
//  Copyright (c) 2015 Yuan. All rights reserved.
//

#import "FirstViewController.h"
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

#import "DubUser.h"

//#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#ifdef __IPHONE_8_0
#import <LocalAuthentication/LocalAuthentication.h>
#endif

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize backButton;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]])
    [self.navigationController popToRootViewControllerAnimated:NO];
}



- (IBAction)processLoginFB:(id)sender{
    
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
                 //NSLog(@"Saving Current User result %d", succeeded);
             }];
             [DubUser loadCurrentUserInBackgroundWithBlock:(kPFCachePolicyCacheThenNetwork) block:^(BOOL result, NSError *error) {
                 //NSLog(@"After Facebook current DubUser %@",[DubUser CurrentDubUser].connectedParseObject.username);
             }];
         }
     }];
}


//*****************************************************************//

- (void)requestFacebook:(PFUser *)user
{

}

- (void)processFacebook:(PFUser *)user UserData:(NSDictionary *)userData
{

}

//*****************************************************************//

-(void)openMainWindow{
    UIStoryboard *storyBoard;
    
    storyBoard = [UIStoryboard storyboardWithName:[[AppDelegate sharedInstance] storyboardName] bundle:nil];
    UINavigationController *nav1 = [storyBoard instantiateViewControllerWithIdentifier:@"dubsnavi"];
    UINavigationController *nav2 = [storyBoard instantiateViewControllerWithIdentifier:@"explorenavi"];
    UINavigationController *nav3 = [storyBoard instantiateViewControllerWithIdentifier:@"activitynavi"];
    UINavigationController *nav4 = [storyBoard instantiateViewControllerWithIdentifier:@"profilenavi"];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        nav1.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"" image:[UIImage imageNamed:@"Dubs.png"] ];
        nav2.ng_tabBarItem = [NGTabBarItem itemWithTitle:nil image:[UIImage imageNamed:@"Explore.png"]];
        nav3.ng_tabBarItem = [NGTabBarItem itemWithTitle:nil image:[UIImage imageNamed:@"Activity.png"]];
        nav4.ng_tabBarItem = [NGTabBarItem itemWithTitle:nil image:[UIImage imageNamed:@"Profile.png"]];
    }
    else
    {
        nav1.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"" image:[UIImage imageNamed:@"Dubs.png"] ];
        nav2.ng_tabBarItem = [NGTabBarItem itemWithTitle:nil image:[UIImage imageNamed:@"Explore.png"]];
        nav3.ng_tabBarItem = [NGTabBarItem itemWithTitle:nil image:[UIImage imageNamed:@"Activity.png"]];
        nav4.ng_tabBarItem = [NGTabBarItem itemWithTitle:nil image:[UIImage imageNamed:@"Profile.png"]];
    }
    
    
    
    NSArray *viewController = [NSArray arrayWithObjects:nav1, nav2, nav3, nav4 ,nil];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    appDelegate.tabBarController = [[FuzzITTabBarController alloc] initWithDelegate:self];
    appDelegate.tabBarController.viewControllers = viewController;
    appDelegate.tabBarController.selectedIndex = 0;
    
    [self.navigationController pushViewController:appDelegate.tabBarController animated:YES];

}

#pragma mark - NGTabBarControllerDelegate

- (CGSize)tabBarController:(NGTabBarController *)tabBarController
sizeOfItemForViewController:(UIViewController *)viewController
                   atIndex:(NSUInteger)index
                  position:(NGTabBarPosition)position
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        //Change by Cassandra
        //return CGSizeMake(80,60);
        return CGSizeMake(30, 30);
    }
    else
    {
        //return CGSizeMake(192,60);
        return CGSizeMake(30, 30);
    }
    
}
- (IBAction)goLogin:(id)sender
{
    [self performSegueWithIdentifier:@"gosign" sender:nil];    
}
- (IBAction)goSignup:(id)sender
{
    [self performSegueWithIdentifier:@"gosignup" sender:nil];
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated: YES];
}


@end
