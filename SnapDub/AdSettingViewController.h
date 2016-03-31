//
//  ViewController.h
//  AdSetting
//
//  Created by Jeet on 15/07/15.
//  Copyright (c) 2015 monarknest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>



@interface ViewController : UIViewController<GADInterstitialDelegate>

@property(nonatomic, strong) GADInterstitial *interstitial;
-(void)showAdMobInterstitial;

@end

