//
//  DubsViewController.m
//  SnapDub
//
//  Created by Poland on 06/05/15.
//  Copyright (c) 2015 Yuan. All rights reserved.
//

#import "DubsViewController.h"
#import "SoundTableViewCell.h"
#import "MySoundsTableViewCell.h"
#import "TrendCategoryCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "AVFoundation/AVFoundation.h"
#import "TrendingCategoryListViewController.h"
#import "AddSoundHeader.h"
#import "SDConstants.h"
#import "TrendCategoryCollectionViewCell.h"
#import "DubFeaturedContentsParseHelper.h"
#import "FeaturedContentsManager.h"
#import "DubSoundBoard.h"
#import "DubSound.h"
#import "DubCategoryTableViewCell.h"
#import "DubCategory.h"
#import "DubUser.h"
#import "DubMain.h"
#import "DubSoundBoardCollectionManager.h"
#import "FirstViewController.h"
#import "TWMessageBarManager.h"
#import "SDTutorialManager.h"
#import "AppDelegate.h"
#import "DubSoundParseHelper.h"

#define TOP_SOUNDS_PER_PAGE 30

@interface DubsViewController ()
{
    NSMutableArray *aryLatest;
    NSMutableArray *arySoundboard;
}

@end

@implementation DubsViewController
@synthesize usDub;
@synthesize tvLatest , uvLatest;
@synthesize tvTrending , uvTrending;
@synthesize  uvSound, tvSoundboard;

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [SDTutorialManager hideAllTutorialMessages];
    [soundCell dismissVideoIndicator];
    soundCell = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName: EVENT_STOP_PLAYING object:nil];
}

- (void)loadView {
    [super loadView];
    
    static NSString *CellIdentifier = @"dubCategoryCell";
    [tvTrending registerNib:[UINib nibWithNibName:@"DubCategoryTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    self.loadingView = [[PFLoadingView alloc] initWithFrame:CGRectZero];
    self.loadingView.frame = self.view.bounds;
    [self.view addSubview:self.loadingView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserSoundBoardsInBackground) name:EVENT_SOUNDBOARD_CREATED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(soundFinishPlaying) name:EVENT_SOUND_FINISH_PLAYING object:nil];
    
    usDub.enabled = NO;
  }

-(void) showVideoIndicator
{
    [SDTutorialManager showTutorialBarMessageWithTitle:@"Make your dub video" message:@"Select a sound to create a funny video :D" isOnTop:YES];
    
    [soundCell showVideoIndicator];
}

-(void) soundFinishPlaying
{
    [SDTutorialManager hideAllTutorialMessages];
    [soundCell dismissPlaySoundIndicator];
    
    [[SDTutorialManager ShareManager] setTutorialStepFinish: ANALYTICS_MANAGER_TUTORIAL_STEP_0_PreviewSound];
    
    if(![[SDTutorialManager ShareManager] isTutorialStepDone:ANALYTICS_MANAGER_TUTORIAL_STEP_0_1_ClickOnSoundCell])
    {
        [self performSelector:@selector(showVideoIndicator) withObject:nil afterDelay: 1.0f];
    }
}

-(void) getCategoryContents
{
    [self.loadingView setHidden: NO];
    [FeaturedContentsManager GetAllCategories:^(NSArray * categories, NSError * error) {
        if (!error) {
            categoryList = [NSArray arrayWithArray: categories];
        }
        
        [self.tvLatest reloadData];
        [self.loadingView setHidden: YES];
    }];
}

-(void) getTopSounds
{
    if(!topSoundsList)
        topSoundsList = [NSMutableArray array];
    
    [self.loadingView setHidden: NO];
    
    [DubSoundParseHelper GetAllDubSoundsOrderByScoreInBackground:kPFCachePolicyNetworkElseCache limitPerPage:TOP_SOUNDS_PER_PAGE pageNum:topSoundsPageNum block:^(NSArray *results, NSError *error) {
        
        if (!error) {
            //NSLog(@"getTopSounds num results %d", (int)[results count] );
            
           // categoryList = [NSArray arrayWithArray: categories];
            [topSoundsList addObjectsFromArray: results];
            
            //NSLog(@"topSoundsList count is %lu", (unsigned long)[topSoundsList count]);
            topSoundsPageNum ++;
            
            [self.tvLatest reloadData];
        }

        
        [self.loadingView setHidden: YES];
    }];
}

-(void) getContents
{
    [FeaturedContentsManager GetFeaturedSoundsForFrontPageInBackground:^(NSArray * sounds, NSError *error) {
//        //NSLog(@"FeaturedSound is %@", sounds);
        if (!error) {
            featuredSounds = [NSArray arrayWithArray: sounds];
        }
        
        [FeaturedContentsManager GetFeatureSoundBoardsForFrontPageInBackground:^(NSArray *boards, NSError *error2) {
//            //NSLog(@"FeaturedsoundBoards is %@", boards);
            if (!error2) {
                featuredSoundBoards = [NSArray arrayWithArray: boards];
            }
            [self.tvTrending reloadData];
            [self.loadingView setHidden: YES];
        }];
    }];
    
}

-(void) showTutorial
{
    [SDTutorialManager showTutorialBarMessageWithTitle:@"Play Sound" message:@"Click Play!" isOnTop:YES];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
//    [SDTutorialManager showTutorialBarMessage: @"Click Play Button to Preview the Sound"];
    if(! [[SDTutorialManager ShareManager] isTutorialStepDone: ANALYTICS_MANAGER_TUTORIAL_STEP_0_PreviewSound])
    {
        [self performSelector:@selector(showTutorial) withObject:nil afterDelay:1.0];
    }
    
    if([[SDTutorialManager ShareManager] isTutorialStepDone: ANALYTICS_MANAGER_TUTORIAL_STEP_0_1_ClickOnSoundCell])
    {
        self.usDub.enabled = YES;
        
        AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
        ((UITabBarController*)delegate.navi).tabBar.userInteractionEnabled = YES;
        _searchButton.hidden = NO;
    }else
    {
        self.usDub.enabled = NO;
        
        AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
        ((UITabBarController*)delegate.navi).tabBar.userInteractionEnabled = NO;
        _searchButton.hidden = YES;
    }
    
    
     
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //AdSetting
    APP_MANAGER_SINGLEON.objViewController = self;
    // Do any additional setup after loading the view.
    usDub.selectedSegmentIndex = 0;
    uvLatest.hidden = YES;
    uvSound.hidden = YES;
  
    __block BOOL done = false;
    [DubMain LoadInitialDataWithBlock:^(BOOL result, NSError *error){
        
        if(!done)
        {
            done = YES;
        if ([PFUser currentUser] == nil) {
            //NSLog(@"current User is nil");
        }
        else{
            //NSLog(@"current User name %@  id %@",[PFUser currentUser].username,[PFUser currentUser].objectId);
        }
        
        AddSoundHeader *firstViewUIView = [[[NSBundle mainBundle] loadNibNamed:@"AddSoundHeader" owner:self options:nil] firstObject];
        [firstViewUIView.addSound addTarget:self action:@selector(goAddSound:) forControlEvents:UIControlEventTouchUpInside];
        [firstViewUIView.addSoundBoard addTarget:self action:@selector(goAddSoundBoard:) forControlEvents:UIControlEventTouchUpInside];
        tvSoundboard.tableHeaderView = firstViewUIView;
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:swipeLeft];
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(didSwipe:)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:swipeRight];
        
        [self getContents];
        }
    }];

    
}


//AdSetting
-(void)showAdMobInterstitial
{
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:ADMOB_ID];
    self.interstitial.delegate =self;
    [self performSelector:@selector(loadinter) withObject:nil afterDelay:0.1];
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
    //NSLog(@"interstitialDidReceiveAd");
    [self.interstitial presentFromRootViewController:self];
}



#pragma UIGestureView
- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        //NSLog(@"Swipe Left");
        if (usDub.selectedSegmentIndex == 2) {
            return;
        }
        else
        {
            [usDub setSelectedSegmentIndex:usDub.selectedSegmentIndex+1];
            [self segmentScanController:usDub];
        }
        
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        //NSLog(@"Swipe Right");
        if (usDub.selectedSegmentIndex == 0) {
            return;
        }
        else
        {
            [usDub setSelectedSegmentIndex:usDub.selectedSegmentIndex-1];
            [self segmentScanController:usDub];
        }
        
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        //NSLog(@"Swipe Up");
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        //NSLog(@"Swipe Down");
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName: EVENT_STOP_PLAYING object:nil];
}



#pragma UICollectionView

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)processSearch:(id)sender {
}

- (IBAction)segmentScanController:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName: EVENT_STOP_PLAYING object:nil];
    if (usDub.selectedSegmentIndex == 0) {
        uvLatest.hidden  = YES;
        uvSound.hidden = YES;
        
        
    }
    else if ( usDub.selectedSegmentIndex == 1)
    {
        uvLatest.hidden = NO;
        uvSound.hidden = YES;
        [self getTopSounds];
    }
    else
    {
        uvLatest.hidden  = YES;
        uvSound.hidden = NO;
        
        [self getUserSoundBoardsInBackground];
    }
}

#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    if( ! [[SDTutorialManager ShareManager] isTutorialStepDone:ANALYTICS_MANAGER_TUTORIAL_STEP_0_PreviewSound] )
    {
        return;
    }
    
    if(![[SDTutorialManager ShareManager] isTutorialStepDone:ANALYTICS_MANAGER_TUTORIAL_STEP_0_1_ClickOnSoundCell])
    {
        if([cell isKindOfClass: [SoundTableViewCell class]])
        {
            [[SDTutorialManager ShareManager] setTutorialStepFinish: ANALYTICS_MANAGER_TUTORIAL_STEP_0_1_ClickOnSoundCell];
            [(SoundTableViewCell*) cell cellIsSelected];
        }
        return;
    }

    if([cell isKindOfClass: [DubCategoryTableViewCell class]])
    {
        [(DubCategoryTableViewCell*)cell cellIsSelected];
        return;
    }
    
    if([cell isKindOfClass: [SoundTableViewCell class]])
    {
        [(SoundTableViewCell*) cell cellIsSelected];
        return;
    }
        
    
    if(tableView == tvLatest ){
        DubCategory* category = categoryList[indexPath.row];
    
        TrendingCategoryListViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"trendingCategoryList"];
    
        controller.connectedDubCategory = category;
        controller.mode = CATEGORY_FEATURE_MODE;
    
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    else if(tableView == tvTrending)
    {
        if(indexPath.row<[featuredSounds count])
        {
            [self performSegueWithIdentifier:@"goAddVideo" sender:nil];
        }

    }else if(tableView==tvSoundboard)
    {
        if(indexPath.row == 0)
        {
            TrendingCategoryListViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"trendingCategoryList"];
            
            controller.dubUser = [DubUser CurrentDubUser];
            controller.mode = USER_CREATED_SOUNDS_MODE;
            
            [self.navigationController pushViewController:controller animated:YES];
        }
        else if(indexPath.row == 1)
        {
            //Load user's fav sounds
            TrendingCategoryListViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"trendingCategoryList"];
            
            controller.dubUser = [DubUser CurrentDubUser];
            controller.mode = USER_FAV_SOUNDS_MODE;
            
            [self.navigationController pushViewController:controller animated:YES];
        }else
        {
            //Load corresponding list of sound of soundboard
            
            DubSoundBoard* soundboard = [[DubUser CurrentDubUser].dubSoundboardCollectionManager.userCreatedDubSoundboards objectAtIndex: indexPath.row-2];
            
            TrendingCategoryListViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"trendingCategoryList"];
            
            controller.connectedSoundBoard = soundboard;
            controller.mode = SOUNDS_IN_SOUNDBOARD_MODE;
            
            [self.navigationController pushViewController:controller animated:YES];
             
             
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tvLatest)
    {
        if(!topSoundsList)
            return 0;
        
        return shouldStopLoadingMoreTopSound?[topSoundsList count] : [topSoundsList count]+1;
    }
    if (tableView == tvTrending)
    {
        
        //NSLog(@"Rows in trending table set to 3");
        //        return [aryLatest count];
        
        return [featuredSounds count] +  [featuredSoundBoards count];
    }
    else
    {
//        return [aryListPeo count];
         //NSLog(@"Done number of rows in section tvSoundboard");
        return 2 + [[DubUser CurrentDubUser].dubSoundboardCollectionManager.userCreatedDubSoundboards count];
    }
    
   
   
}

-(void) getUserSoundBoardsInBackground
{
    [self.loadingView setHidden: NO];
    [[DubUser CurrentDubUser].dubSoundboardCollectionManager loadOwnerCreatedSoundBoardsFromParseInBackground:kPFCachePolicyCacheThenNetwork block:^(NSArray *result, NSError *error) {
        if(!error)
        {
            [self.tvSoundboard reloadData];
            [self.loadingView setHidden: YES];
        }
    }];
}

- (UITableViewCell *) getLoadMoreCell
{
    
    static NSString *CellIdentifier = @"loadMoreCell";
    UITableViewCell* cell = [self.tvLatest dequeueReusableCellWithIdentifier: CellIdentifier];
    if (!cell)
    {
        [self.tvLatest registerNib:[UINib nibWithNibName:@"LoadMoreCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell =[self.tvLatest dequeueReusableCellWithIdentifier:CellIdentifier];
    }

    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tvTrending )
    {
        if(indexPath.row<[featuredSounds count])
        {
            //NSLog(@"Setting cell in trending table for index %ld", indexPath.row);
            static NSString *CellIdentifier = @"soundCell";
        
            SoundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            cell.navController = self.navigationController;
            if (!cell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"SoundTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
                cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            }
        
            DubSound* sound = [featuredSounds objectAtIndex: indexPath.row];
            [cell setConnectedDubSound: sound];
            cell.theTableView = tableView;
            
            int tutorialIndex = 0;
            if([featuredSounds count]>1)
            {
                tutorialIndex = 1;
            }

            if(indexPath.row == tutorialIndex)
            {
                if(![[SDTutorialManager ShareManager] isTutorialStepDone:ANALYTICS_MANAGER_TUTORIAL_STEP_0_PreviewSound] )
                {
                    cell.isTutorialCell = YES;
                    [cell showPlaySoundIndicator];
                    soundCell = cell;
                }
            }else
            {
                [cell dismissPlaySoundIndicator];
            }
            
            [cell setIndex: (int)indexPath.row];
            return cell;
        
        }else
        {
            int featuredIndex = (int)indexPath.row - (int)[featuredSounds count];
            static NSString *CellIdentifier = @"dubCategoryCell";
            DubCategoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            if (!cell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"DubCategoryTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
                cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            }
            
            DubSoundBoard* soundboard = featuredSoundBoards[featuredIndex];
            [cell setConnectedSoundboard: soundboard];
            
            cell.uiController = self;
            return cell;
        }
    }
    else if( tableView == tvLatest)
    {
        if(topSoundsList && indexPath.row == [topSoundsList count])
        {
            [self getTopSounds];
            
            return [self getLoadMoreCell];
        }else
        {
            static NSString *CellIdentifier = @"soundCell";
            SoundTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            if (!cell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"SoundTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
                cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            }
            
            DubSound* sound = [topSoundsList objectAtIndex: indexPath.row];
            [cell setConnectedDubSound: sound];
            cell.theTableView = tableView;
            [cell setIndex: (int)indexPath.row];
            return cell;
        }
    }
    else if( tableView == tvSoundboard)
    {
        if(indexPath.row<2)
        {
            static NSString *CellIdentifier = @"boardCell";
            MySoundsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            if (!cell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"MySoundsTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            }
        
            NSArray *titles = @[@"Uploaded Sounds", @"My Favourites"];
            if(indexPath.row ==1)
            {
                [cell setIconImageFileName: @"smileYellow.png"];
            }else
            {
                [cell setIconImageFileName: @"cloudUpload.png"];
            }
            
            cell.lblName.text = titles[indexPath.row];
            cell.btnInfo.tag = 3000 + indexPath.row;
            [cell.btnInfo addTarget:self action:@selector(showinfo:) forControlEvents:UIControlEventTouchUpInside];

            [cell setBackgroundColor:[UIColor clearColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else
        {
            static NSString *CellIdentifier = @"boardCell";
            MySoundsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            if (!cell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"MySoundsTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            }
            
            cell.lblName.text = ((DubSoundBoard*)[ [DubUser CurrentDubUser].dubSoundboardCollectionManager.userCreatedDubSoundboards objectAtIndex: indexPath.row-2 ]).soundBoardName;

            [cell.btnInfo addTarget:self action:@selector(showinfo:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell setConnectedDubSoundboard: ((DubSoundBoard*)[ [DubUser CurrentDubUser].dubSoundboardCollectionManager.userCreatedDubSoundboards objectAtIndex: indexPath.row-2 ])];
            
            
            
            return cell;
            
        }
    }else
    {
        return nil;
    }
}

-(void)playSound:(UIButton *)sender
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"simple-drum-beat" ofType:@"wav"];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    // Create audio player object and initialize with URL to sound
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [player play];
}


-(void)showinfo:(UIButton *)sender
{
    
}


- (IBAction)goAddSoundBoard:(id)sender {
    if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
        
        FirstViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.backButton.hidden = NO;
        [self.navigationController pushViewController:vc animated:YES];
        //[self performSegueWithIdentifier:@"goFirstView" sender:nil];
    }
    else
    {
        [self performSegueWithIdentifier:@"goAddBoard" sender:nil];
    }
}


- (IBAction)goAddSound:(id)sender {
    if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
        
        FirstViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.backButton.hidden = NO;
        [self.navigationController pushViewController:vc animated:YES];
        //[self performSegueWithIdentifier:@"goFirstView" sender:nil];
    }
    else
    {
        [self performSegueWithIdentifier:@"goAddSound" sender:nil];
    }
}

#pragma UIActionSheet Delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
   
    if ([buttonTitle isEqualToString:@"Share"]) {
        //NSLog(@"Share pressed");
    }
    if ([buttonTitle isEqualToString:@"Report"]) {
        //NSLog(@"Report pressed");
    }
    if ([buttonTitle isEqualToString:@"Add To Soundboard"]) {
        //NSLog(@"Add To Soundboard");
    }
    if ([buttonTitle isEqualToString:@"Cancel"]) {
        //NSLog(@"Cancel pressed --> Cancel ActionSheet");
    }
}

#pragma sound table view cell items
- (IBAction)clickedMoreButtonInCell:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tvLatest];
    NSIndexPath *indexPath = [self.tvLatest indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        int currentIndex = indexPath.row;
        //NSLog(@"%ld",(long)currentIndex);
    // retive the item object to perform actions
    
    NSString *actionSheetTitle = @"Action";
        //Action Sheet Title
    NSString *destructiveTitle = @"Destructive Button"; //Action Sheet Button Titles
    NSString *other1 = @"Add To Soundboard";
    NSString *other2 = @"Share";
    NSString *other3 = @"Report";
    NSString *other4 = @"Challenge Friends!!!";
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  
                                initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other1, other2, other3, other4, nil];
    
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // In this case the device is an iPad.
            /*[actionSheet showFromRect:[(UIButton *)sender frame] inView:self.tvLatest animated:YES];
             */ [actionSheet showInView:self.view];
        }
        else{
            // In this case the device is an iPhone/iPod Touch.
            [actionSheet showInView:self.view];
        }
    }
    
}

- (IBAction)trendClickedMoreButton:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tvTrending];
    NSIndexPath *indexPath = [self.tvTrending indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        int currentIndex = indexPath.row;
        //NSLog(@"%ld",(long)currentIndex);
        // retive the item object to perform actions
        
        NSString *actionSheetTitle = @"Action";
        //Action Sheet Title
        NSString *destructiveTitle = @"Destructive Button"; //Action Sheet Button Titles
        NSString *other1 = @"Add To Soundboard";
        NSString *other2 = @"Share";
        NSString *other3 = @"Report";
        NSString *cancelTitle = @"Cancel";
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      
                                      initWithTitle:actionSheetTitle
                                      delegate:self
                                      cancelButtonTitle:cancelTitle
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:other1, other2, other3, nil];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // In this case the device is an iPad.
            /*[actionSheet showFromRect:[(UIButton *)sender frame] inView:self.tvTrending animated:YES];*/
             [actionSheet showInView:self.view];
        }
        else{
            // In this case the device is an iPhone/iPod Touch.
            [actionSheet showInView:self.view];
        }

    }

}
@end
