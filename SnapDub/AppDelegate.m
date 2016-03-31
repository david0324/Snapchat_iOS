//
//  AppDelegate.m
//  SnapDub
//
//  Created by Poland on 07/05/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "AppDelegate.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <ifaddrs.h>
#import "AppConstants.h"
#import "AppConstants.h"
#import "DubSoundParseHelper.h"
#import "SoundTableViewCell.h"
#import "DubSound.h"
#import "DubUser.h"
#import "SDConstants.h"
#import "AppDelegate.h"
#import "DMVideoRecordingViewController.h"
#import "DubVideoCreator.h"
#import "DubSoundboardSelectionViewController.h"
#import "GeneralUtility.h"
#import "ProfileViewController.h"
#import "SDTutorialManager.h"
#import "MPCoachMarks.h"
#import "DGActivityIndicatorView.h"
#import "DMVideoShareViewController.h"
#import "SDTutorialManager.h"
#import "ExploreResultViewController.h"
#import "DubSoundParseHelper.h"
#import "DubCategory.h"

#import <Parse/Parse.h>
#import <AVFoundation/AVFoundation.h>
#import "Reachability.h"
#import "DubSoundParseHelper.h"

#import "SDTutorialManager.h"
//New FrameWork
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

//AdSetting
#import <GoogleMobileAds/GoogleMobileAds.h>


@implementation AppDelegate
@synthesize userinfo, navi, navi2;
static AppDelegate* sharedDelegate = nil;

- (void)monitorReachability {
    Reachability *hostReach = [Reachability reachabilityWithHostname:@"api.parse.com"];
    
    hostReach.reachableBlock = ^(Reachability*reach) {
        _networkStatus = [reach currentReachabilityStatus];
        //NSLog(@"Internet is back!");
    };
    
    hostReach.unreachableBlock = ^(Reachability*reach) {
        _networkStatus = [reach currentReachabilityStatus];
        //NSLog(@"Someone just broke the internet!");
    };
    
    [hostReach startNotifier];
}

- (BOOL)isParseReachable {
    return self.networkStatus != NotReachable;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([UITableViewCell instancesRespondToSelector:@selector(setLayoutMargins:)]) {
        [[UITableViewCell appearance]setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [[SDTutorialManager ShareManager] loadData];
    
    [PFImageView class];
    [self monitorReachability];
    
    [Parse setApplicationId:@"bLHZiEkQYasMpeWneRaYBUWEv2b41v5DiGrO6qp8" clientKey:@"GYZyQjuunNS0NUC1nBSBQNItde8leY7pN96xVe6j"];

    //AdSetting
    [[VungleSDK sharedSDK] startWithAppId:VUNGLE_ID];
    [[VungleSDK sharedSDK] setDelegate:self];
    APP_MANAGER_SINGLEON;
    
    
    //adding for invalide token
    [PFUser enableRevocableSessionInBackground];
    
    //New FaceBook Framework
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    [PFUser enableAutomaticUser];
    
    // Track app open.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
        [[PFInstallation currentInstallation] saveInBackground];
    }
    
    PFACL *defaultACL = [PFACL ACL];
    // Enable public read access by default, with any newly created PFObjects belonging to the current user
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    
    [PFImageView class];
    
    
    
    
   // [PFFacebookUtils initializeFacebook];
    application.statusBarHidden = NO;
    
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSString *tch = [standardDefaults objectForKey:@"touchId"];
    if ([tch isEqualToString:@"yes"]) {
        
    } else{
        [standardDefaults setObject:@"no" forKey:@"touchId"];
        [standardDefaults synchronize];        
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = NULL;
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];
    if( err ){
        //NSLog(@"There was an error creating the audio session");
    }
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:NULL];
    if( err ){
        //NSLog(@"There was an error sending the audio to the speakers");
    }
    
    
    //*************************************************************************************//
    //CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    
    UIStoryboard *Storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.navi = [Storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
    
    self.navi2 = [Storyboard instantiateViewControllerWithIdentifier:@"NaviViewController"];
    

    
        // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        // Set the initial view controller to be the root view controller of the window object
    self.window.rootViewController  = self.navi;
        
        // Set the window object to be the key window and show it
    [self.window makeKeyAndVisible];
    
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
    
    
    //PUSH: registerting for push notifications using parse.com
    //Todo: Eventually move this code to a different location where users will be more likely to give us notification access.
    //      Also, use a custom more convinvicing ui before getting this permission
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes  categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    if (application.applicationState != UIApplicationStateBackground) {
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced
        // in iOS 7). In that case, we skip tracking here to avoid double
        // counting the app-open.
        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }
    
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                            didFinishLaunchingWithOptions:launchOptions];;
}
							
//Parse.com push notifcation registration process
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current Installation and save it to Parse
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

//Push: Tracking app opens with push notifcation
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (application.applicationState == UIApplicationStateInactive) {
        // The application was just brought from the background to the foreground,
        // so we consider the app as having been "opened by a push notification."
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //Dubsmash
    [[SDTutorialManager ShareManager] saveData];
    
    if(self.recordingVC)
        [self.recordingVC stopAutoRecording];
    if(self.previewVC) {
        [self.previewVC stopMedia];
    }
    //AdSetting
    [APP_MANAGER_SINGLEON appDidEnterBGHandle];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



/* Begin Add for FaceBook Login*/
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    //NSLog(@"object id from deeplink: %@", [url scheme]);
    if ([[url scheme] isEqualToString:@"snapdub"]){
        NSString *query = [url host];
        //NSLog(@"object id from deeplink: %@", query);
        [DubSoundParseHelper GetDubSoundFromObjectId:query policy:kPFCachePolicyNetworkOnly block:^(DubSound *sound, NSError *error) {
            
            [sound saveFileToTempFolderInBackground:^(BOOL result, NSString *filePath) {
                
                if(result)
                {
                    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
                    
                    DMVideoRecordingViewController *controller = [delegate.navi.storyboard instantiateViewControllerWithIdentifier:@"DMVideoRecordingViewController"];
                    [DubVideoCreator resetData];
                    [DubVideoCreator setDubSoundRef: sound];
                    //NSLog(@"filePath for recording view controller: %@", filePath);
                    
                    controller.soundFilePath = filePath;
                    
                    [GeneralUtility pushViewController: controller animated: YES];
                }else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                                    message:@"Cannot connect to the server. Can't play the sound and create a dubVideo."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                }
            }];
        }];
        return true;
    }
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
            
                                                       annotation:annotation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
    [FBSDKAppEvents activateApp];
    
    //AdSetting
    [APP_MANAGER_SINGLEON getDataFromParseDotCom];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

+ (AppDelegate *) sharedInstance
{
    if (sharedDelegate == nil)
        sharedDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    return sharedDelegate;
}

+ (BOOL)isConnectedToInternet
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&zeroAddress);
    
    if (reachability) {
        SCNetworkReachabilityFlags flags;
        BOOL worked = SCNetworkReachabilityGetFlags(reachability, &flags);
        CFRelease(reachability);
        
        if (worked) {
            
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
                return YES;
            }
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand) != 0) || (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
                return YES;
            }
        }
        
    }
    return NO;
}


//AdSetting
- (void)vungleSDKAdPlayableChanged:(BOOL)isAdPlayable{
    [APP_MANAGER_SINGLEON setIsVungleReady :isAdPlayable];
    [APP_MANAGER_SINGLEON showVungle];
}
- (void)vungleSDKwillShowAd{
}
- (void)vungleSDKwillCloseAdWithViewInfo:(NSDictionary*)viewInfo willPresentProductSheet:(BOOL)willPresentProductSheet{
    [APP_MANAGER_SINGLEON checkAndShowCrossPromoAds];
}
- (void)vungleSDKwillCloseProductSheet:(id)productSheet{
}

@end
