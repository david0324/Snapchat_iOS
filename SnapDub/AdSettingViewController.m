//
//  ViewController.m
//  AdSetting
//
//  Created by Jeet on 15/07/15.
//  Copyright (c) 2015 monarknest. All rights reserved.
//

#import "AdSettingViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    APP_MANAGER_SINGLEON.objViewController = self;
}
-(void)showAdMobInterstitial
{
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:ADMOB_ID];
    self.interstitial.delegate =self;
    [self performSelector:@selector(loadinter) withObject:nil afterDelay:4];
}

-(void)loadinter
{
    GADRequest *request = [GADRequest request];
    // Requests test ads on test devices.
    request.testDevices = @[ kGADSimulatorID ];
    [self.interstitial loadRequest:request];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    //NSLog(@"interstitialDidDismissScreen");
    [APP_MANAGER_SINGLEON checkAndShowCrossPromoAds];
}

- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error {
    //NSLog(@"interstitialDidFailToReceiveAdWithError: %@", [error localizedDescription]);
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    [self.interstitial presentFromRootViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
