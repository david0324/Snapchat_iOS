//
//  TrendingCategoryLisTiewController.m
//  SnapDub
//
//  Created by Moin' Victor on 5/21/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "TrendingCategoryListViewController.h"
#include "SoundTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "AVFoundation/AVFoundation.h"
#import "SDConstants.h"
#import "DubSoundBoardParseHelper.h"
#import "DubSound.h"
#import "DubSoundBoard.h"
#import "DubCategory.h"
#import "DubFeaturedContentsParseHelper.h"
#import "DubSoundBoardParseHelper.h"
#import "GeneralUtility.h"
#import "DubUser.h"
#import "DubSoundParseHelper.h"
#import "DubSoundBoardCollectionManager.h"
#import "DubCategoryTableViewCell.h"
#import "SDTutorialManager.h"
#import "MySoundsTableViewCell.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "AdManager.h"

#define ADMOB_BANNER_ID                 @"ca-app-pub-7086884589684486/1654028652"

#define PARSE_LIMIT 4

@interface TrendingCategoryListViewController ()

@end
 
@implementation TrendingCategoryListViewController

@synthesize tableView, theTitle, connectedSoundBoard, mode, connectedDubCategory, dubUser;

-(void) resetData
{
    pageNum = 0;
    [soundList removeAllObjects];
}

- (IBAction)segmentValueChanged:(id)sender {
    [self resetData];
    
    [self loadMoreContents];
}

-(void) setConnectedSoundBoard:(DubSoundBoard *) theconnectedSoundBoard
{
    connectedSoundBoard = theconnectedSoundBoard;
    self.theTitle.text = connectedSoundBoard.soundBoardName;
}

-(void) setConnectedDubCategory:(DubCategory *)theconnectedDubCategory
{
    connectedDubCategory = theconnectedDubCategory;
    self.theTitle.text = [NSString stringWithFormat: @"%@ ⌵",connectedDubCategory.categoryName];
}

-(void) loadMoreContents
{
    if(self.mode == CATEGORY_FEATURE_MODE)
    {
        if(self.segment.selectedSegmentIndex<1)
        {
        
            [self getCategoryFeaturedSounds];
        }else
        {
            [self getCategoryRecentSounds];
        }
    }else if(self.mode == USER_CREATED_SOUNDS_MODE)
    {
        [self getUserCreatedSounds];
    }
    else if(self.mode == USER_FAV_SOUNDS_MODE)
    {
        [self getUserLikedSounds];
    }
}

-(void) getUserCreatedSounds
{
    self.theTitle.text = @"Sounds List";//[dubUser.profileName stringByAppendingString: @"'s Sounds"];
    
    if(mode== USER_CREATED_SOUNDS_MODE)
    {
        self.theTitle.text = @"Uploaded Sounds";
    }
    
    [ self.loadingView setHidden: NO];
    
    __block int tempPageNum = pageNum;
    __block int loadCount = 0;
    __block NSArray* tempResults;
    
    [DubSoundParseHelper GetAllDubSoundsCreatedByAUserInBackground:dubUser.connectedParseObject cachePolicy:kPFCachePolicyCacheThenNetwork limitPerPage:PARSE_LIMIT pageNum:tempPageNum block:^(NSArray *results, NSError *error) {
        
        //NSLog(@"GetUserCreatedSounds tempPageNum %d loadCount %d tempResults count %d and result count %d", tempPageNum, loadCount, (int)[tempResults count], (int)[results count]);
        
        if(error || [results count]<1)
        {
            shouldStopLoadMore = YES;
        }else
        {
            shouldStopLoadMore = NO;
        }
        
        if(!error)
        {
            if(loadCount<1)
            {
                tempResults = results;
            }else
            {
                [soundList removeObjectsInArray: tempResults];
            }
            
            [ soundList addObjectsFromArray: results];
        }
        
        
        [self.tableView reloadData];
        [ self.loadingView setHidden: YES];
        
        if(loadCount<1)
        {
            pageNum++;
        }
        
        loadCount++;
    }];
}

-(void) getUserSoundboards
{
    self.theTitle.text = @"Soundboards";
    [ self.loadingView setHidden: NO];
    
    [self.dubUser.dubSoundboardCollectionManager loadOwnerCreatedSoundBoardsFromParseInBackground:kPFCachePolicyCacheThenNetwork block:^(NSArray * results, NSError *error) {
        
        //NSLog(@"getUserSoundboards result count %d", (int)[results count]);
        
        if(!error)
        {
            soundboardList = [NSArray arrayWithArray: results];
        }else
        {
            soundboardList = [NSArray array];
        }
        
        [self.tableView reloadData];
        [ self.loadingView setHidden: YES];
    }];
     
}

-(void) getUserLikedSounds
{
    self.theTitle.text = @"Liked Sounds";
    [ self.loadingView setHidden: NO];
    
    __block int tempPageNum = pageNum;
    __block int loadCount = 0;
    __block NSArray* tempResults;
    
    [DubSoundParseHelper GetAllDubSoundsLikedByAUserInBackground:dubUser.connectedParseObject cachePolicy:kPFCachePolicyCacheThenNetwork limitPerPage:PARSE_LIMIT pageNum:tempPageNum block:^(NSArray *results, NSError *error) {
        
        //NSLog(@"getUserLikedSounds tempPageNum %d loadCount %d tempResults count %d results count %d", tempPageNum, loadCount, (int)[tempResults count], (int)[results count]);
        
        if(error || [results count]<1)
        {
            shouldStopLoadMore = YES;
        }else
        {
            shouldStopLoadMore = NO;
        }
        
        if(!error)
        {
            if(loadCount<1)
            {
                tempResults = results;
            }else
            {
                [soundList removeObjectsInArray: tempResults];
            }
            
            [ soundList addObjectsFromArray: results];
        }
        
        
        [self.tableView reloadData];
        [ self.loadingView setHidden: YES];
        
        if(loadCount<1)
        {
            pageNum++;
        }
        
        loadCount++;
    }];
}

-(void) getCategoryRecentSounds
{
    self.theTitle.text = connectedDubCategory.categoryName;
    [ self.loadingView setHidden: NO];
    
    PFCachePolicy policy = kPFCachePolicyNetworkOnly;
    
    if( ![GeneralUtility isParseReachable] )
    {
        policy = kPFCachePolicyCacheOnly;
    }
    
    [DubFeaturedContentsParseHelper GetRecentDubSoundsFromACategory:connectedDubCategory.connectedPFObject limit:PARSE_LIMIT pageNum:pageNum cachePolicy:policy block:^(NSArray *results, NSError *error) {
        
        if(error || [results count]<1)
        {
            shouldStopLoadMore = YES;
        }
        
        if(!error)
        {
           [ soundList addObjectsFromArray: results];
        }
        
        
        [self.tableView reloadData];
        [ self.loadingView setHidden: YES];
        pageNum++;
    }];
}

-(void) getCategoryFeaturedSounds
{
    self.theTitle.text = connectedDubCategory.categoryName;
    [ self.loadingView setHidden: NO];
    
    PFCachePolicy policy = kPFCachePolicyNetworkOnly;
    
    if( ![GeneralUtility isParseReachable] )
    {
        policy = kPFCachePolicyCacheOnly;
    }

    [DubFeaturedContentsParseHelper GetTopDubSoundsFromACategory:connectedDubCategory.connectedPFObject limit:PARSE_LIMIT pageNum:pageNum cachePolicy:policy block:^(NSArray *results, NSError *error) {
       
        if(error || [results count]<1)
        {
            shouldStopLoadMore = YES;
        }
        
        if(!error)
        {
            [ soundList addObjectsFromArray: results];
        }
        
        [self.tableView reloadData];
        [ self.loadingView setHidden: YES];
        pageNum++;
    }];
}

-(void) getSoundsFromTheSoundboard
{
    self.theTitle.text = connectedSoundBoard.soundBoardName;
    
    [DubSoundBoardParseHelper GetAllDubSoundsInADubSoundBoardInBackground: connectedSoundBoard.connectedParseObject cachePolicy:kPFCachePolicyCacheThenNetwork block:^(NSArray *results, NSError *error) {
        if(!error)
        {
          //  soundList = [NSArray arrayWithArray: results];
            //NSLog(@"getSoundsFromTheSoundboard result count %d", (int)[results count]);
            
            NSMutableArray* temp = [NSMutableArray array];
            
            for(PFObject* object in results)
            {
                if(object)
                {
                DubSound* sound = [[DubSound alloc] init];
                [sound setConnectedParseObject: object];
                    
                    if(!sound)
                        //NSLog(@"DubSound* sound is NULL ");
                    
                [temp addObject: sound];
                }
            }
            
            soundList =  [DubSound sortDubSoundArray: temp];// [NSMutableArray arrayWithArray: temp];
            
        }else
        {
            soundList = [NSMutableArray array];
        }
        
        [self.tableView reloadData];
        [ self.loadingView setHidden: YES];
        
    }];
}

-(void) viewWillDisappear:(BOOL)animated {
    [SDTutorialManager hideAllTutorialMessages];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: EVENT_STOP_PLAYING object:nil];
}

- (void)loadView {
    [super loadView];
    
    
    self.loadingView = [[PFLoadingView alloc] initWithFrame:CGRectZero];
    self.loadingView.frame = self.view.bounds;
    [self.view addSubview:self.loadingView];
    
    [self resetData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    soundList = [NSMutableArray array];
    [self.segment setHidden: YES];
    
    if(mode== SOUNDS_IN_SOUNDBOARD_MODE)
    {
        shouldStopLoadMore = YES;
        [self getSoundsFromTheSoundboard];
        
        if(![[SDTutorialManager ShareManager] isTutorialStepDone: SELECT_SOUND_TO_RECORD_REMINDER2])
        {
            [SDTutorialManager showTutorialBarMessageWithTitle:@"Create a DubVideo" message:@"Select a sound and create a funny Dubvideo Now :D" isOnTop:NO];

            [[SDTutorialManager ShareManager] setTutorialStepFinish: SELECT_SOUND_TO_RECORD_REMINDER2];
        }
        
    }else if(mode== CATEGORY_FEATURE_MODE){
        [self.segment setHidden: NO];
        [self getCategoryFeaturedSounds];
        
        if(![[SDTutorialManager ShareManager] isTutorialStepDone: SELECT_SOUND_TO_RECORD_REMINDER3])
        {
            [SDTutorialManager showTutorialBarMessageWithTitle:@"Create a DubVideo" message:@"Select a sound and create a funny Dubvideo Now :D" isOnTop:NO];
            
            [[SDTutorialManager ShareManager] setTutorialStepFinish: SELECT_SOUND_TO_RECORD_REMINDER3];
    }
    }
    else if(mode == USER_CREATED_SOUNDS_MODE)
    {
        [self getUserCreatedSounds];
        
        if(![[SDTutorialManager ShareManager] isTutorialStepDone: SELECT_SOUND_TO_RECORD_REMINDER1])
        {
            [SDTutorialManager showTutorialBarMessageWithTitle:@"Create a DubVideo" message:@"Select a sound and create a funny Dubvideo Now :D" isOnTop:NO];
            
            [[SDTutorialManager ShareManager] setTutorialStepFinish: SELECT_SOUND_TO_RECORD_REMINDER1];
    }
    }
    else if(mode == USER_FAV_SOUNDS_MODE)
    {
        [self getUserLikedSounds];
        
        if(![[SDTutorialManager ShareManager] isTutorialStepDone: SHOW_FAV_SOUND_REMINDER])
        {
            [SDTutorialManager showTutorialBarMessageWithTitle:@"Create a DubVideo" message:@"Select a sound and create a funny Dubvideo Now :D" isOnTop:NO];
            
            [[SDTutorialManager ShareManager] setTutorialStepFinish: SHOW_FAV_SOUND_REMINDER];
    }
    }
    else if(mode == LIST_OF_SOUNDBOARD_MODE)
    {
        [self getUserSoundboards];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)playSound:(UIButton *)sender
{
    /*
    NSString *path = [[NSBundle mainBundle] pathForResource:@"simple-drum-beat" ofType:@"wav"];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    // Create audio player object and initialize with URL to sound
    AVPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [player play];
     */
    //NSLog(@"Playing Sound");
}

-(UIView*)getGoogleBannerView{
    GADBannerView* googleBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    googleBannerView.adUnitID = @"ca-app-pub-7086884589684486/1654028652";
    googleBannerView.delegate = self;
    
    googleBannerView.rootViewController = self;
    [self.view bringSubviewToFront:googleBannerView];
    
    googleBannerView.backgroundColor= [UIColor whiteColor];
    
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ kGADSimulatorID ];
    [googleBannerView loadRequest:request];
    googleBannerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
    return googleBannerView;
}

#pragma UITableView
- (UITableViewCell *) getLoadMoreCell
{
    
    static NSString *CellIdentifier = @"loadMoreCell";
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (!cell)
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"LoadMoreCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell =[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)thetableView numberOfRowsInSection:(NSInteger)section
{
    if(self.mode == LIST_OF_SOUNDBOARD_MODE)
    {
        return [soundboardList count];
    }
    
    if([soundList count]<1)
    {
        return 0;
    }
    
    if(!shouldStopLoadMore)
    {
        return [soundList count]+1;
    }
    
    return [soundList count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.mode == LIST_OF_SOUNDBOARD_MODE)
    {
        static NSString *CellIdentifier = @"boardCell";
        MySoundsTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        if (!cell)
        {
            [self.tableView registerNib:[UINib nibWithNibName:@"MySoundsTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell =[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        DubSoundBoard* soundboard = soundboardList[indexPath.row];
        [cell setConnectedDubSoundboard: soundboard];
        cell.uiController = self;
        return cell;
    }
    
    
    if(indexPath.row< [soundList count] )
    {
        static NSString *CellIdentifier = @"soundCell";
    
        SoundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        cell.navController = self.navigationController;
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"SoundTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
    
        DubSound* sound = [soundList objectAtIndex: indexPath.row];
        [cell setConnectedDubSound: sound];
        [cell setIndex: (int)indexPath.row];
        return cell;
    }else
    {
        [self performSelector:@selector(loadMoreContents) withObject:nil afterDelay:0.4];
        return [self getLoadMoreCell];
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
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
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
            /* In this case the device is an iPad.
            [actionSheet showFromRect:[(UIButton *)sender frame] inView:self.view animated:YES];*/
             [actionSheet showInView:self.view];
        }
        else{
            // In this case the device is an iPhone/iPod Touch.
            [actionSheet showInView:self.view];
        }
    }
    
}


- (IBAction)backButtonClicked:(id)sender {
    if(self.hidesBottomBarWhenPushed)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
    [self.navigationController popViewControllerAnimated:YES];
}
}

@end
