//
//  DubsViewController.h
//  SnapDub
//
//  Created by Poland on 06/05/15.
//  Copyright (c) 2015 Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFLoadingView.h"


//AdSetting
#import <GoogleMobileAds/GoogleMobileAds.h>

@class SoundTableViewCell;
@interface DubsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,
UICollectionViewDelegate, UIActionSheetDelegate,GADInterstitialDelegate>
{
    //===============From Cai=====================//
    BOOL shouldReloadOnAppear;
    BOOL _hasLoaded;
    BOOL _hasCategoryLoaded;
    NSArray* trendingData;
    
    NSArray* featuredSounds;
    NSArray* featuredSoundBoards;
    
    NSArray* categoryList;
    
    NSMutableArray* topSoundsList;
    // NSArray* trendingImages;
    
    UIRefreshControl* refreshController;
    UIRefreshControl* refreshController2;
    
    SoundTableViewCell* soundCell;
    
    int topSoundsPageNum;
    BOOL shouldStopLoadingMoreTopSound;
}
//Adsetting
@property(nonatomic, strong) GADInterstitial *interstitial;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (nonatomic, strong) PFLoadingView *loadingView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *usDub;

@property (weak, nonatomic) IBOutlet UIView *uvLatest;
@property (weak, nonatomic) IBOutlet UITableView *tvLatest;

@property (weak, nonatomic) IBOutlet UIView *uvTrending;
@property (weak, nonatomic) IBOutlet UITableView *tvTrending;

@property (weak, nonatomic) IBOutlet UIScrollView *uvSound;
@property (weak, nonatomic) IBOutlet UITableView *tvSoundboard;

@property NSArray *trendingCatTitles;
@property NSArray *trendingCatImages;

- (IBAction)clickedMoreButtonInCell:(id)sender;

- (IBAction)trendClickedMoreButton:(id)sender;

//AdSetting
-(void)showAdMobInterstitial;
@end
