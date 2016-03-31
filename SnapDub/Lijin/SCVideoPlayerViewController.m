//
//  SCVideoPlayerViewController.m
//  SCAudioVideoRecorder
//
//  Created by Simon CORSIN on 8/30/13.
//  Copyright (c) 2013 rFlex. All rights reserved.
//

#import "SCVideoPlayerViewController.h"
//#import "SCEditVideoViewController.h"
#import "SCAssetExportSession.h"

@interface SCVideoPlayerViewController () {
    SCPlayer *_player;
    AVPlayer *player;
    AVPlayerLayer *videoPlayingLayer;
}

@end

@implementation SCVideoPlayerViewController
@synthesize txt_videotitle,filter_scroll,time_scroll;
@synthesize videoPlayingView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
    if (self) {
        // Custom initialization
    }
	
    return self;
}

- (void)dealloc {
//    self.filterSwitcherView = nil;
    [_player pause];
    _player = nil;
}

- (void)viewDidLoad
{
    txt_videotitle.delegate = self;

// filterview is open or not
    [self.videoPlayingView addSubview:filter_scroll];
    [self.videoPlayingView addSubview:time_scroll];
    isshown = NO;
    istimeshown = NO;
    self.lbl_title.hidden = YES;
    self.btn_confirm.hidden = YES;
    
    [self.view addSubview:self.videoPlayingView];
}

- (void)viewWillAppear:(BOOL)animated {

    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    NSString* path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"final.m4v"];
    NSURL *videoURL = [NSURL fileURLWithPath:path];
    
    player = [AVPlayer playerWithURL:videoURL];
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[player currentItem]];
    
    videoPlayingLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    
    [videoPlayingLayer setFrame:CGRectMake(0, 0, self.videoPlayingView.frame.size.width, self.videoPlayingView.frame.size.height)];
    
    [videoPlayingLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];//AVLayerVideoGravityResizeAspectFill
    
    [videoPlayingView.layer insertSublayer:videoPlayingLayer atIndex:0];
    [player play];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController  setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_player pause];
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo {
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];

    if (error == nil) {
        [[[UIAlertView alloc] initWithTitle:@"Saved to camera roll" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Failed to save" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

-(IBAction)onCloseButtonClicked:(id)sender
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: nil
                                                                        message: nil
                                                                 preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle: @"delete this musical"
                                                        style: UIAlertActionStyleDestructive
                                                      handler: ^(UIAlertAction *action) {
                                                          [self onDeleteButtonClicked];
                                                      }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle: @"re-shoot"
                                                       style: UIAlertActionStyleDefault
                                                     handler: ^(UIAlertAction *action) {
                                                         [self onReshootButtonClicked];
                                                     }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 [controller dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    [controller addAction: yesAction];
    [controller addAction: noAction];
    [controller addAction: cancel];
    [self presentViewController: controller animated: YES completion: nil];
}

- (void) onDeleteButtonClicked {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void) onReshootButtonClicked {
    ShootFirstViewController *v_view = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShootFirstViewController"];
    [self.navigationController pushViewController:v_view animated:NO];
}

-(IBAction)onSaveButtonClicked:(id)sender
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.txt_videotitle resignFirstResponder];//becomeFirstResponder
    return YES;
}

- (IBAction)onFilterButttonClicked:(id)sender{
    if (!isshown && !istimeshown) {
        self.lbl_title.hidden = NO;
        self.lbl_title.text = @"color filters";
//        [self.filterSwitcherView addSubview:self.lbl_title];
        [self.videoPlayingView addSubview:self.lbl_title];

        self.btn_confirm.hidden = NO;
        [self.btn_confirm addTarget:self action:@selector(FilterConfirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self.filterSwitcherView addSubview:self.btn_confirm];
        [self.videoPlayingView addSubview:self.btn_confirm];
        
        [self setupFilterScrollView];
    }
}

- (IBAction)onTimeMachineButttonClicked:(id)sender{
    if (!istimeshown && !isshown) {
        self.lbl_title.hidden = NO;
        self.lbl_title.text = @"time machine";
//        [self.filterSwitcherView addSubview:self.lbl_title];
        [self.videoPlayingView addSubview:self.lbl_title];
        
        self.btn_confirm.hidden = NO;
        [self.btn_confirm addTarget:self action:@selector(TimeConfirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self.filterSwitcherView addSubview:self.btn_confirm];
        [self.videoPlayingView addSubview:self.btn_confirm];

        [self setupTimeScrollView];
    }
}

- (void)setupFilterScrollView {
    
    if ([[SoundManager sharedManager].currentMusic isPlaying]) {
        return;
    }else{
        isshown = YES;
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSArray *filternames = [NSArray arrayWithObjects:@"filter_none",@"filter_blues", @"filter_piano", @"filter_pop", @"filter_rock",@"filter_country",nil];
        NSArray *selectedFilternames = [NSArray arrayWithObjects:@"filter_none",@"filter_blues", @"filter_piano", @"filter_pop", @"filter_rock",@"filter_country" ,nil];
        for (int i = 1; i < [filternames count]+1; i++)
        {
            //Item working with blocks
            ACPItem *item = [[ACPItem alloc] initACPItem:[UIImage imageNamed:[filternames objectAtIndex:i-1]]
                                               iconImage:nil
                                                   label:nil
                                               andAction: ^(ACPItem *item) {
                                                   
//                                                   [self savefiltermethod:i];
//                                                   [self previewCamera:i];
                                                   
                                               }];
            
            //Set highlighted behaviour
            [item setHighlightedBackground:[UIImage imageNamed:[selectedFilternames objectAtIndex:i-1]] iconHighlighted:nil textColorHighlighted:nil];
            
            
            if(i==2)
            {
                //  [[SDTutorialManager ShareManager] generateUIViewAnimation: item];
                theFilterItem = item;
            }
            
            
            [array addObject:item];
        }
        
        self.scrollView = [[ACPScrollMenu alloc] initACPScrollMenuWithFrame:CGRectMake(0, filter_scroll.frame.origin.y, filter_scroll.frame.size.width, 60)
                           
                                                        withBackgroundColor:[UIColor clearColor]
                                                                  menuItems:array];
        //We choose an animation when the user touch the item (you can create your own animation)
        [self.scrollView setAnimationType:ACPZoomOut];
        self.scrollView.delegate = self;
        
        //////swj
        [self.view addSubview:self.scrollView];
        
    }
}

- (void)setupTimeScrollView {
    
    if ([[SoundManager sharedManager].currentMusic isPlaying]) {
        return;
    }else{
        istimeshown = YES;
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSArray *filternames = [NSArray arrayWithObjects:@"time_normal",@"time_reverse", @"time_timetrap", @"time_relativity",nil];
        NSArray *selectedFilternames = [NSArray arrayWithObjects:@"time_normal",@"time_reverse", @"time_timetrap", @"time_relativity",nil];
        for (int i = 1; i < [filternames count]+1; i++)
        {
            //Item working with blocks
            ACPItem *item = [[ACPItem alloc] initACPItem:[UIImage imageNamed:[filternames objectAtIndex:i-1]]
                                               iconImage:nil
                                                   label:nil
                                               andAction: ^(ACPItem *item) {
                                                   
                                               }];
            
            //Set highlighted behaviour
            [item setHighlightedBackground:[UIImage imageNamed:[selectedFilternames objectAtIndex:i-1]] iconHighlighted:nil textColorHighlighted:nil];
            
            
            if(i==2)
            {
                //  [[SDTutorialManager ShareManager] generateUIViewAnimation: item];
                theFilterItem = item;
            }
            
            
            [array addObject:item];
        }
        
        self.scrollView = [[ACPScrollMenu alloc] initACPScrollMenuWithFrame:CGRectMake(0, time_scroll.frame.origin.y, time_scroll.frame.size.width, 60)
                           
                                                        withBackgroundColor:[UIColor clearColor]
                                                                  menuItems:array];
        //We choose an animation when the user touch the item (you can create your own animation)
        [self.scrollView setAnimationType:ACPZoomOut];
        self.scrollView.delegate = self;
        
        //////swj
        [self.view addSubview:self.scrollView];
        
    }
}

- (void) FilterConfirmButtonClicked:(id) sender {
    isshown = NO;
    istimeshown = NO;
    self.lbl_title.hidden = YES;
    self.btn_confirm.hidden = YES;
    self.scrollView.hidden = YES;
}

- (void) TimeConfirmButtonClicked:(id) sender {
    isshown = NO;
    istimeshown = NO;
    self.lbl_title.hidden = YES;
    self.btn_confirm.hidden = YES;
    self.scrollView.hidden = YES;
}

@end