//
//  AppDelegate.h
//  SnapDub
//
//  Created by Poland on 07/05/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "NGTabBarController.h"
#import "UserInfoStruct.h"
#import "NaviViewController.h"

#import "DMVideoRecordingViewController.h"
#import "DMVideoPreviewViewController.h"

//AdSetting
#import <VungleSDK/VungleSDK.h>
#import "AdConstants.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate,VungleSDKDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UserInfoStruct *userinfo;
@property (strong, nonatomic) NGTabBarController *tabBarController;
@property (strong, nonatomic) NaviViewController *navi;
@property (strong, nonatomic) NaviViewController *navi2;
+ (AppDelegate *) sharedInstance;
+ (void)showMessage:(NSString *)text withTitle:(NSString *)title;
+ (BOOL)isConnectedToInternet;
-(NSString*)storyboardName;


// Dubsmash
@property (nonatomic, retain) DMVideoRecordingViewController *recordingVC;
@property (nonatomic, retain) DMVideoPreviewViewController *previewVC;



@property (nonatomic, readonly) int networkStatus;

- (BOOL)isParseReachable;
@end
