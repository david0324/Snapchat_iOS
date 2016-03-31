//
//  AdManager.h
//  AdSetting
//
//  Created by Jeet on 17/07/15.
//  Copyright (c) 2015 monarknest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "AdsSettingsModel.h"
#import "AdConstants.h"
#import <Parse/Parse.h>

#import "DubsViewController.h"

@interface AdManager : NSObject

@property  DubsViewController *objViewController;
@property (readwrite,setter=setIsVungleReady:) BOOL isVungleReady;
@property (nonatomic, assign) BOOL disabled;
@property (nonatomic, assign) BOOL disableVideoCreationEndAds;
@property (nonatomic, assign) int bannerFrequency;

+(AdManager*)sharedAppManager;
-(void)checkAndShowCrossPromoAds;
-(void)getDataFromParseDotCom;
-(void)appDidEnterBGHandle;
-(void)showVungle;
-(void) showGoogleInterstitial;
@end
