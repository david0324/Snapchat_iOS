//
//  AdManager.m
//  AdSetting
//
//  Created by Jeet on 17/07/15.
//  Copyright (c) 2015 monarknest. All rights reserved.
//

#import "AdManager.h"
#import "SDTutorialManager.h"
#import "AnalyticsManager.h"

@implementation AdManager{
    NSMutableArray *adSettingModelsArray;
    NSInteger successfulClicksCount;
    NSInteger cancelClicksCount;
    NSInteger adLastDisplayed;
    NSInteger indexOfCrossPromoAd;
    UIButton *buttonFullScreenAd;
    UIAlertView *alertAds;
    BOOL isVungleSelected;
}
@synthesize objViewController, disabled, bannerFrequency, disableVideoCreationEndAds;
@synthesize isVungleReady;

+(AdManager*)sharedAppManager
{
    static AdManager *sharedAppManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAppManager = [[self alloc] init];
    });
    return sharedAppManager;
}
//
//- (id)init {
//    if (self = [super init]) {
//
//    }
//    return self;
//}
//


-(void) initializeVariables{
    AdsSettingsModel *model =  [adSettingModelsArray objectAtIndex:indexOfCrossPromoAd];
    NSString *adID = [model adID];
    
    if ([USER_DEFAULT objectForKey:[NSString stringWithFormat:@"successfulClicksCountOf%@",adID]]==nil) {
        [USER_DEFAULT setInteger:0 forKey:[NSString stringWithFormat:@"successfulClicksCountOf%@",adID]];
        [USER_DEFAULT setInteger:0 forKey:[NSString stringWithFormat:@"cancelClicksCountOf%@",adID]];
    }
    
    successfulClicksCount = [USER_DEFAULT integerForKey:[NSString stringWithFormat:@"successfulClicksCountOf%@",adID]];
    cancelClicksCount = [USER_DEFAULT integerForKey:[NSString stringWithFormat:@"cancelClicksCountOf%@",adID]];
    
    // this logic checks 4 conditions:
    // 1.successfulclicks do not exceed successfulclickscount
    // 2.cancelclicks do not exceed cancelclickscount
    // 3.is the ad actually enabled at the server
    // 4.if the bool "showOverAds" is enabled, then do not include it in probablity. but show it later for sure.
    //NSLog(@"[tempModelObject successfulClicks] is %ld successfulClickCount is %ld [tempModelObject cancelClicks] is %ld and cancel Count is %ld",[model successfulClicks], successfulClicksCount, [model cancelClicks], (long)cancelClicksCount );
    if((([model successfulClicks]>successfulClicksCount) && ([model cancelClicks]>cancelClicksCount)) &&  [model isEnabled] && (![model showOverAds])){
        model.isEnabled = YES;
    }else{
        model.isEnabled = NO;
    }
}

-(void)getDataFromParseDotCom
{
    //NSLog(@"Getting the latest config...");
    [PFConfig getConfigInBackgroundWithBlock:^(PFConfig *config, NSError *error) {
        if (!error) {
            //NSLog(@"Yay! Config was fetched from the server.");
        } else {
            //NSLog(@"Failed to fetch. Using Cached Config.");
            config = [PFConfig currentConfig];
        }
        NSDictionary *adsSettingsDict = config[@"Ad_Settings"];
        bannerFrequency = [[adsSettingsDict valueForKey: @"bannerFrequency"] intValue];
        disableVideoCreationEndAds = [[adsSettingsDict valueForKey: @"disableVideoCreationEndAds"] boolValue];
        NSArray *adsSettingsArray = [adsSettingsDict valueForKey:@"adSettings"];
        //NSLog(@"fetchedArray = %@", adsSettingsArray);
        [self processTheFethcedArray:adsSettingsArray];
        
    }];
}
-(void)processTheFethcedArray:(NSArray*)adsSettingsArray{
    adSettingModelsArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[adsSettingsArray count]; i++) {
        NSDictionary *tempAdsObjDict = [adsSettingsArray objectAtIndex:i];
        AdsSettingsModel *tempModelObject = [[AdsSettingsModel alloc] initWithIndex:i withAdType:[tempAdsObjDict objectForKey:@"adType"] showFrequency:[[tempAdsObjDict objectForKey:@"showFrequency"] integerValue] isEnabled:[[tempAdsObjDict objectForKey:@"isEnabled"] boolValue]];
        
        //NSLog(@"[tempModelObject adType] is %@", [tempModelObject adType]);
        if ([[tempModelObject adType]isEqualToString:@"CrossPromotionAd"]) {
            indexOfCrossPromoAd = i;
            tempModelObject.adID = [tempAdsObjDict objectForKey:@"adID"];
            tempModelObject.alertAdSettingsDict = [tempAdsObjDict objectForKey:@"alertAdSettings"];
            tempModelObject.fullPageAdSettingsDict = [tempAdsObjDict objectForKey:@"fullPageAdSettings"];
            tempModelObject.link = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[tempAdsObjDict objectForKey:@"link"]] ];
            tempModelObject.showOverAds = [[tempAdsObjDict objectForKey:@"showOverAds"] boolValue];
            tempModelObject.successfulClicks = [[tempAdsObjDict objectForKey:@"successfulClicks"] integerValue];
            tempModelObject.cancelClicks = [[tempAdsObjDict objectForKey:@"cancelClicks"] integerValue];
            
         }
        [adSettingModelsArray addObject: tempModelObject];
    }
    
    [self initializeVariables];
    [self displayAdsAccordingToFetchedData];
}
-(void)displayAdsAccordingToFetchedData{
    //show ads only if the following tut step is done
    if(![[SDTutorialManager ShareManager] isTutorialStepDone: ANALYTICS_MANAGER_TUTORIAL_STEP_3_Recording_start_pressed]){
        return;
    }
    
    if(disabled)
        return;
    
    NSInteger totalProbablity=[self getAdsTotalProbablity];
    if (totalProbablity==0) {
        return;
    }
    
    NSInteger winningAd = arc4random_uniform((int)totalProbablity);
    
    NSInteger winningAdIndex = [self getWinningAdIndex:winningAd];
    //NSLog(@"winningAdIndex %ld",(long)winningAdIndex);
    // winningAdIndex = 1; // test jeet
    
    switch (winningAdIndex) {
        case 0:
            [self showGoogleInterstitial];
            adLastDisplayed = 0;
            break;
        case 1:
            isVungleSelected = YES;
            [self showVungle];
            adLastDisplayed = 1;
            break;
        case 2:
            [self showCrossPromotionAd];
            break;
        default:
            break;
    }
}
-(NSInteger) getWinningAdIndex:(NSInteger)winningAd{
    NSInteger winningAdIndex =0;
    for (AdsSettingsModel *model in adSettingModelsArray) {
        if ([model isEnabled]) {
            winningAd -= [model showFrequency];
            if (winningAd<=0) {
                winningAdIndex = [model adIndex];
                break;
            }
        }
    }
    return winningAdIndex;
}
-(void) showGoogleInterstitial{
    if(disabled)
        return;
    
    [objViewController showAdMobInterstitial];
}
-(void) showVungleInterstitial{
    [[VungleSDK sharedSDK] playAd:objViewController error:nil];
}
-(void)checkAndShowCrossPromoAds
{
    AdsSettingsModel *model =  [adSettingModelsArray objectAtIndex:indexOfCrossPromoAd];
    if ([model showOverAds]) {
        
        if((([model successfulClicks]>successfulClicksCount) && ([model cancelClicks]>cancelClicksCount)) ){
            [self showCrossPromotionAd];
        }
        
    }
}

-(void) showCrossPromotionAd{
    AdsSettingsModel *model =  [adSettingModelsArray objectAtIndex:indexOfCrossPromoAd];
    NSInteger ratioOfAlertAd =[[[model alertAdSettingsDict] objectForKey:@"showFrequency"] integerValue];
    NSInteger ratioOfFullPageAd = [[[model fullPageAdSettingsDict] objectForKey:@"showFrequency"] integerValue];
    NSInteger totalAdsProbablity =  ratioOfAlertAd + ratioOfFullPageAd;
    if (totalAdsProbablity==0) {
        return;
    }
    NSInteger randomNumber = arc4random_uniform((int) totalAdsProbablity);
    // randomNumber = 8; // test jeet
    if (randomNumber<ratioOfAlertAd) {
        [self showAlertAd];
        adLastDisplayed = 2;
    }else{
        [self showFullScreenAd];
        adLastDisplayed = 3;
    }
    
    
}
-(void) showAlertAd{
    AdsSettingsModel *model =  [adSettingModelsArray objectAtIndex:indexOfCrossPromoAd];
    NSDictionary *alertDict = [model alertAdSettingsDict];
    
    alertAds = [[UIAlertView alloc] initWithTitle:[alertDict objectForKey:@"titleTxt"]
                                          message:[alertDict objectForKey:@"messageTxt"]
                                         delegate:self
                                cancelButtonTitle:[alertDict objectForKey:@"cancelTxt"]
                                otherButtonTitles:[alertDict objectForKey:@"okTxt"],nil];
    alertAds.tag = 5001;
    [alertAds show];
    
}
-(void) showFullScreenAd{
    AdsSettingsModel *model =  [adSettingModelsArray objectAtIndex:indexOfCrossPromoAd];
    NSDictionary *fullScreenDict = [model fullPageAdSettingsDict];
    
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    CGRect rect =  [window frame];
    
    NSURL *imageURL = [NSURL URLWithString:[fullScreenDict objectForKey:@"imgURL"]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImageView *adImageView = [[UIImageView alloc] init];
    adImageView.image = [UIImage imageWithData:imageData];
    buttonFullScreenAd = [[UIButton alloc] initWithFrame:rect];
    [buttonFullScreenAd setBackgroundImage:adImageView.image forState:UIControlStateNormal];
    [window addSubview:buttonFullScreenAd];
    
    [buttonFullScreenAd addTarget:self
                           action:@selector(imageButtonAdClicked:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImage * closeImage = [UIImage imageNamed:@"close.png"];
    UIButton *closeFullScreenAd = [[UIButton alloc] initWithFrame:CGRectMake(rect.size.width-closeImage.size.width-20, 20, closeImage.size.width, closeImage.size.height)];
    [closeFullScreenAd setBackgroundImage:closeImage forState:UIControlStateNormal];
    [buttonFullScreenAd addSubview:closeFullScreenAd];
    
    [closeFullScreenAd addTarget:self
                          action:@selector(closeButtonAdClicked:)
                forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 5001) {
        
        if (buttonIndex==0) {
            [self increaseCancelClickNSave];
        }else if(buttonIndex==1) {
            [self increaseSuccessFulClickNSave];
        }else{
            // this is cahhed when user presses home on dialog box
            // in current context no handling is required here
        }
        alertAds = nil;
    }
    
}

-(IBAction)closeButtonAdClicked:(id)sender{
    [self increaseCancelClickNSave];
    [self removeCustomAdView];
}
-(IBAction)imageButtonAdClicked:(id)sender
{
    [self increaseSuccessFulClickNSave];
    [self removeCustomAdView];
}

-(void)removeCustomAdView{
    [buttonFullScreenAd removeFromSuperview];
    buttonFullScreenAd = nil;
}


-(void) increaseSuccessFulClickNSave{
    AdsSettingsModel *model =  [adSettingModelsArray objectAtIndex:indexOfCrossPromoAd];
    successfulClicksCount++;
    [USER_DEFAULT setInteger:successfulClicksCount forKey:[NSString stringWithFormat:@"successfulClicksCountOf%@",[model adID]]];
    [[UIApplication sharedApplication] openURL: [model link]];
    
}
-(void) increaseCancelClickNSave{
    AdsSettingsModel *model =  [adSettingModelsArray objectAtIndex:indexOfCrossPromoAd];
    
    cancelClicksCount++;
    [USER_DEFAULT setInteger:cancelClicksCount forKey:[NSString stringWithFormat:@"cancelClicksCountOf%@",[model adID]]];
}



-(NSInteger) getAdsTotalProbablity{
    NSInteger totalProbablity=0;
    for (AdsSettingsModel *model in adSettingModelsArray) {
        if ([model isEnabled]) {
            totalProbablity += [model showFrequency];
        }
    }
    return totalProbablity;
}

-(void)showVungle{
    if (isVungleReady && isVungleSelected) {
        isVungleSelected = NO;
        isVungleReady = NO;
        [self showVungleInterstitial];
    }
}
-(void)appDidEnterBGHandle{
    if (alertAds!=nil) {
        [alertAds dismissWithClickedButtonIndex:2 animated:NO];
    }
    if (buttonFullScreenAd!=nil) {
        [self removeCustomAdView];
    }

}
@end
