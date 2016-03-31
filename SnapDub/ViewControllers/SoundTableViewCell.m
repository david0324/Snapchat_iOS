//
//  LatestTableViewCell.m
//  SnapDub
//
//  Created by Poland on 07/05/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

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

@implementation SoundTableViewCell
@synthesize btnPlay, lblName, userButton, btnStar, btnMore, audioPlayer, theTableView, isTutorialCell, navController;

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_SOUND_FINISH_PLAYING object:nil];
}
//
- (void)awakeFromNib {
    // Initialization code
    //NSLog(@"awakeFromNib");
    [[NSNotificationCenter defaultCenter] postNotificationName: kSDEventUserSoundsCollectionUpdated object:nil userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTestNotification:)  name:kSDEventUserSoundsCollectionUpdated object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeSoundsChnaged:)  name:EVENT_SOUND_FAV_CHANGED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlayingSound)  name:EVENT_STOP_PLAYING object:nil];
    
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    _loadingIndicator.hidden = YES;
    
    /*
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playSound  )];
    singleTap.numberOfTapsRequired = 1;
    [activityIndicatorView setUserInteractionEnabled:YES];
    [activityIndicatorView addGestureRecognizer:singleTap];
     */
    
    UIImage *image = [[UIImage imageNamed:@"playButton3.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIImage *image2 = [[UIImage imageNamed:@"Smiley"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIImage *image3 = [[UIImage imageNamed:@"moreButton.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [btnPlay setImage:image forState:UIControlStateNormal];
    btnPlay.frame = CGRectMake(self.btnPlay.frame.origin.x, self.btnPlay.frame.origin.y, self.btnPlay.frame.size.width*0.7f, btnPlay.frame.size.height *0.7f);
   // btnPlay.imageView.image. = 0.7;// transform = CGAffineTransformMakeScale(0.7, 0.7);
    [btnStar setImage:image2 forState:UIControlStateNormal];
    [btnMore setImage:image3 forState:UIControlStateNormal];
    
   // UIColor* color = [UIColor c]
  //  btnPlay.tintColor = [UIColor redColor];
 //   btnPlay.image = [btnPlay.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    [theImageView setTintColor:[UIColor redColor]];
   // [btnPlay setTintColor: [UIColor redColor]];
}

-(void) updateColor
{
    [self setIndex: theIndex];
}

-(void) setIndex: (int) index
{
    theIndex = index;
    btnPlay.tintColor = [GeneralUtility getColorByIndex: index];
    btnStar.tintColor = [GeneralUtility getColorByIndex: index];
    btnMore.tintColor = [GeneralUtility getColorByIndex: index];
    lblName.textColor = [GeneralUtility getColorByIndex: index];
    _colorLabel.backgroundColor = [GeneralUtility getColorByIndex: index];
    _backgroundLabel.backgroundColor = [GeneralUtility getColorByIndex: index];
  //  _backgroundLabel.alpha = 0.00f;
    //Don't need it now
    _backgroundLabel.hidden = YES;
}

-(void) cellIsSelected
{
    if(!isTutorialCell)
    {
        if(![[SDTutorialManager ShareManager] isTutorialStepDone:ANALYTICS_MANAGER_TUTORIAL_STEP_0_1_ClickOnSoundCell])
        {
            return;
        }
    }
    
    stopChangingColor = YES;
    
    [self.connectedDubSound saveFileToTempFolderInBackground:^(BOOL result, NSString *filePath) {
        
        if(result)
        {
            AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
        
            DMVideoRecordingViewController *controller = [delegate.navi.storyboard instantiateViewControllerWithIdentifier:@"DMVideoRecordingViewController"];
            [DubVideoCreator resetData];
            [DubVideoCreator setDubSoundRef: self.connectedDubSound];
            
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
    
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

-(void) likeSoundsChnaged:(NSNotification *) notification
{
    if([_connectedDubSound isLikedByCurrentUser])
    {
        [btnStar setImage:[UIImage imageNamed:@"smileYellow.png"] forState:UIControlStateNormal];
    }else
    {
        [btnStar setImage:[UIImage imageNamed:@"Smiley"] forState:UIControlStateNormal];
    }
}

-(void) receiveTestNotification:(NSNotification *) notification
{
//     //NSLog(@"receiveTestNotification");
    if( [notification.name isEqualToString:kSDEventUserSoundsCollectionUpdated] )
    {
        if([_connectedDubSound isLikedByCurrentUser])
        {
            [btnStar setImage:[UIImage imageNamed:@"smileYellow.png"] forState:UIControlStateNormal];
        }else
        {
            [btnStar setImage:[UIImage imageNamed:@"Smiley"] forState:UIControlStateNormal];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setCellUIAtIndex:(NSInteger *)index name:(NSString *)name favorited:(BOOL)fav_ moreText:(NSString *)more
{
    
    [lblName setText:name];
    [userButton setTitle:more forState:UIControlStateNormal];
   
    if(fav_)
    {
        [btnStar setImage:[UIImage imageNamed:@"smileYellow.png"] forState:UIControlStateNormal];
    } else
    {
        [btnStar setImage:[UIImage imageNamed:@"Smiley"] forState:UIControlStateNormal];
    }
    
    [self setIndex: (int)index];
}

-(void) audioPaused:(AVAudioPlayer *)player
{
    //NSLog(@"Audio being audioPaused");
    btnPlay.hidden = NO;
    _loadingIndicator.hidden = YES;
    currentState = PAUSE;
    //change back to pause button
    UIImage *image = [[UIImage imageNamed:@"playButton3.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [btnPlay setImage:image forState:UIControlStateNormal];
    [self updateColor];
}

-(void) audioBeingPlayed:(AVAudioPlayer *)player
{
     //NSLog(@"Audio being audioBeingPlayed");
    btnPlay.hidden = NO;
    _loadingIndicator.hidden = YES;
    
    currentState = PLAYING;
    [btnPlay setImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateNormal];
    [self updateColor];
}

-(void) audioBeingLoaded:(AVAudioPlayer *)player
{
    //NSLog(@"Audio being Loaded");
    currentState = LOADING;
    //show indicator
    //change to pause button image
    btnPlay.hidden = YES;
    _loadingIndicator.hidden = NO;
    [_loadingIndicator startAnimating];
}

-(void) stopPlayingSound
{
    if(currentState==PLAYING && [DubAudioPlayer ShareInstance].delegate == self)
    {
        [[DubAudioPlayer ShareInstance] pauseAudio];
    }
}

-(void) playSound
{
    //play audiofile streaming
    if(currentState==PLAYING && [DubAudioPlayer ShareInstance].delegate == self)
    {
        if(![[SDTutorialManager ShareManager] isTutorialStepDone:ANALYTICS_MANAGER_TUTORIAL_STEP_0_1_ClickOnSoundCell])
        {
            return;
        }
        [[DubAudioPlayer ShareInstance] pauseAudio];
    }
    else if(currentState!=PLAYING && [DubAudioPlayer ShareInstance].delegate == self)
    {
        [[DubAudioPlayer ShareInstance] playAudioFromAPFFile:self.connectedDubSound.soundPFFile];
        //NSLog(@"Call PlaySound CloudCode");
        [PFCloud callFunctionInBackground:@"playSound" withParameters:@{@"soundId": self.connectedDubSound.connectedParseObject.objectId}
                                    block:^(NSString *response, NSError *error) {
                                        if (!error) {
                                            
                                        }
                                    }];
    }
    else
    {
        [DubAudioPlayer ShareInstance].delegate = self;

        [[DubAudioPlayer ShareInstance] playAudioFromAPFFile:self.connectedDubSound.soundPFFile];
        
        //NSLog(@"Call PlaySound CloudCode");
        [PFCloud callFunctionInBackground:@"playSound" withParameters:@{@"soundId": self.connectedDubSound.connectedParseObject.objectId}
                                    block:^(NSString *response, NSError *error) {
                                        if (!error) {
                                            
                                        }
                                    }];

    }
    
    if(![[SDTutorialManager ShareManager] isTutorialStepDone:ANALYTICS_MANAGER_TUTORIAL_STEP_0_PreviewSound])
    {
        [SDTutorialManager hideAllTutorialMessages];
    }
}

- (IBAction)playSoundClicked:(UIButton *)sender {
    if(!isTutorialCell)
    {
        if(![[SDTutorialManager ShareManager] isTutorialStepDone:ANALYTICS_MANAGER_TUTORIAL_STEP_0_1_ClickOnSoundCell])
        {
            return;
        }
    }
    
    if([[SDTutorialManager ShareManager] isTutorialStepDone:ANALYTICS_MANAGER_TUTORIAL_STEP_0_PreviewSound] && ![[SDTutorialManager ShareManager] isTutorialStepDone:ANALYTICS_MANAGER_TUTORIAL_STEP_0_1_ClickOnSoundCell])
    {
        return;
    }

    [self playSound];
    
}

- (IBAction)starClicked:(id)sender {
    if(![[SDTutorialManager ShareManager] isTutorialStepDone:ANALYTICS_MANAGER_TUTORIAL_STEP_0_1_ClickOnSoundCell])
    {
        return;
    }
    
    //NSLog(@"Clicked fav button");
    
    if([_connectedDubSound isLikedByCurrentUser]) {
        [btnStar setImage:[UIImage imageNamed:@"smileYellow.png"] forState:UIControlStateNormal];
        
        [_connectedDubSound unlike];
    } else {
        [btnStar setImage:[UIImage imageNamed:@"Smiley"] forState:UIControlStateNormal];
        
        [_connectedDubSound like];
    }

}

- (UITableView *)tableView
{
    id view = [self superview];
    
    while (view && [view isKindOfClass:[UITableView class]] == NO) {
        view = [view superview];
    }
    
    UITableView *tableView = (UITableView *)view;
    return tableView;
}

-(void) setConnectedDubSound: (DubSound*) sound
{
    _connectedDubSound = sound;
    self.lblName.text = sound.soundName;
    
    if(sound.creator.profileName.length>0)
    {
        [userButton setTitle:[NSString stringWithFormat:@"Uploaded by: %@",sound.creator.profileName] forState:UIControlStateNormal];
    }else
    {
        //NSLog(@"Sound Cell Profile ID is %@ and name is %@", sound.creator.connectedParseObject.objectId, sound.creator.profileName);
    }
    
    if([sound isLikedByCurrentUser])
    {
        [btnStar setImage:[UIImage imageNamed:@"smileYellow.png"] forState:UIControlStateNormal];
    }else
    {
        [btnStar setImage:[UIImage imageNamed:@"Smiley"] forState:UIControlStateNormal];
    }
    
    [self.connectedDubSound.soundPFFile getDataInBackgroundWithBlock:^(NSData *soundData, NSError *error) {
    }];

    [activityIndicatorView removeFromSuperview];
    
    [self updateColor];
}

-(void) openCreatorProfile
{
    if(!_connectedDubSound.creator.connectedParseObject)
    {
        return;
    }
    
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    ProfileViewController *controller = [delegate.navi.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    
    [controller setConnectedDubUser: _connectedDubSound.creator];
    // controller.hidesBottomBarWhenPushed = YES;
    
    [GeneralUtility pushViewController: controller animated: YES];
}

- (IBAction)userButtonClicked:(id)sender {
    [self openCreatorProfile];
}

- (IBAction)moreButtonClicked:(id)sender {
    
    if(![[SDTutorialManager ShareManager] isTutorialStepDone: ANALYTICS_MANAGER_TUTORIAL_STEP_0_1_ClickOnSoundCell])
    {
        return;
    }
    NSString *actionSheetTitle = @"Share";
    //Action Sheet Title
    NSString *other1 = @"Facebook Messenger";
    NSString *other2 = @"WhatsApp";
    NSString *other4 = @"iMessage";
    NSString *other5 = @"Facebook Post";
    NSString *other6 = @"Copy link";
    NSString *other7 = @"Other Options";
        NSString *cancelTitle = @"Cancel";
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      
                                      initWithTitle:actionSheetTitle
                                      delegate:self
                                      cancelButtonTitle:cancelTitle
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:other1, other2, other4, other5, other6, other7, nil];
    
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // In this case the device is an iPad.
             [actionSheet showFromRect:[(UIButton *)sender frame] inView:self.superview animated:YES];
            [actionSheet showInView:self.superview];
        }
        else{
            // In this case the device is an iPhone/iPod Touch.
            [actionSheet showInView:self.superview];
        }
    
}

#pragma UIActionSheet Delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    DMVideoShareViewController *share = [[DMVideoShareViewController alloc] init];

    share.sharedSound = self.connectedDubSound;
    PFObject *objforcopy = self.connectedDubSound.connectedParseObject;
    NSString *stringforclipboard = objforcopy.objectId;
    NSString *soundtitle = self.connectedDubSound.soundName;
    NSString *finallinkforcopy = [NSString stringWithFormat:@"Snapdub this! %@ - https://deeplink.me/snapdub.com/%@",soundtitle,stringforclipboard];

    if ([buttonTitle isEqualToString:@"Other Options"]) {
        NSString *actionSheetTitle = @"Other Options";
        //Action Sheet Title
        NSString *destructiveTitle = @"Destructive Button"; //Action Sheet Button Titles
        NSString *other1 = @"Add To Soundboard";
        NSString *other2 = @"View Uploader Profile";
        NSString *other3 = @"Report";
        NSString *cancelTitle2 = @"Cancel";

        
        UIActionSheet *actionSheet2 = [[UIActionSheet alloc]
                                      
                                      initWithTitle:actionSheetTitle
                                      delegate:self
                                      cancelButtonTitle:cancelTitle2
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:other1, other2, other3, nil];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [actionSheet2 showInView:self.superview];
        }
        else{
            
            [actionSheet2 showInView:self.superview];
        }
    }

    if ([buttonTitle isEqualToString:@"Report"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sound reported" message:@"Sound reported for abusive content." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    if ([buttonTitle isEqualToString:@"View Uploader Profile"]) {
       [self openCreatorProfile];
    }
    
    if ([buttonTitle isEqualToString:@"Add To Soundboard"]) {
        //NSLog(@"Add To Soundboard");
        AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
        
        DubSoundboardSelectionViewController *controller = [delegate.navi.storyboard instantiateViewControllerWithIdentifier:@"DubSoundboardSelectionViewController"];
        controller.connectedSound = self.connectedDubSound;
        controller.hidesBottomBarWhenPushed = YES;
         [GeneralUtility pushViewController: controller animated:YES];
        
    }
    if ([buttonTitle isEqualToString:@"Cancel"]) {
        //NSLog(@"Cancel pressed --> Cancel ActionSheet");
    }
    //adding Action for Other Share Options
    if ([buttonTitle isEqualToString:@"Other Share Options"]) {
        AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
        
        DMVideoShareViewController *controller = [delegate.navi.storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
        
        //NSLog(@"Sound Table View Cell ConnectedDubSound %@",self.connectedDubSound);
        
        controller.sharedSound = self.connectedDubSound;
        
        [controller.sharedSound saveFileToTempFolderInBackground:^(BOOL result, NSString *filePath) {
            if (result) {
                 [GeneralUtility pushViewController: controller animated:YES];
            }
            else {
                //NSLog(@"ERROR: saveFiletoTempSound");
            }
        }];
    }
    
    if ([buttonTitle isEqualToString:@"Copy link"]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = finallinkforcopy;
        [self Alert:@"Link copied!" joiningArgument2:@"Your link has been copied. Now go share!"];
    }
    
    if ([buttonTitle isEqualToString:@"iMessage"]) {
        
        MFMessageComposeViewController *messageController1 = [[MFMessageComposeViewController alloc] init];
        
        messageController1.messageComposeDelegate = self;
        if([MFMessageComposeViewController canSendText]) {
            [messageController1 setBody:finallinkforcopy];
            [self.navController presentViewController:messageController1 animated:YES completion:nil];
            
        }
        
    }
    if ([buttonTitle isEqualToString:@"Facebook Post"]) {
        
        [share facebookshare];
    }
    
    if ([buttonTitle isEqualToString:@"WhatsApp"]) {
        
        [share whatsappshare];
        
    }
    
    if ([buttonTitle isEqualToString:@"Facebook Messenger"]) {
        
        [share FacebookMessenger];
        
    }
}

- (void) Alert:( NSString * )title
joiningArgument2:( NSString * )message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self.navController dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultCancelled:
        {
            //NSLog(@"Cancelled");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sharing Canceled" message:@"Sharing dubsound canceled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
            break;
        case MessageComposeResultFailed:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failed!" message:@"Message sending failed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
            break;
        case MessageComposeResultSent:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Snapdub audio has been sent!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
            break;
        default:
            break;
    }
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark - MMPopLabelDelegate
///////////////////////////////////////////////////////////////////////////////


- (void)dismissedPopLabel:(MMPopLabel *)popLabel
{
    //NSLog(@"disappeared");
}


- (void)didPressButtonForPopLabel:(MMPopLabel *)popLabel atIndex:(NSInteger)index
{
    //NSLog(@"pressed %li", (long)index);
}

-(void) dismissPlaySoundIndicator
{
    [activityIndicatorView removeFromSuperview];
}

-(void) dismissVideoIndicator
{
    [activityIndicatorView removeFromSuperview];
}

-(void) showVideoIndicator
{
    /*
    if(!videoIndicatorView)
        videoIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeTriplePulse tintColor:[UIColor blueColor] size: 30.0f ];
    
    
    
  //  activityIndicatorView.userInteractionEnabled = NO;
 //   activityIndicatorView.exclusiveTouch = NO;
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    videoIndicatorView.alpha = 0.7;
    videoIndicatorView.frame = CGRectMake(width/2.0-30.0, btnPlay.frame.origin.y, 60, 60);
    
    //NSLog(@"x %f y %f width %f height %f", btnPlay.frame.origin.x, btnPlay.frame.origin.y,width, height );
    
    //   activityIndicatorView.center = btnPlay.center;
    
    [videoIndicatorView removeFromSuperview];
    [self addSubview: videoIndicatorView];
    
    [videoIndicatorView startAnimating];
     */
    
    [self changingColor];
    
    /*
    [AMPopTip appearance].font = [UIFont fontWithName:@"Avenir-Medium" size:12];
    
    self.popTip = [AMPopTip popTip];
    self.popTip.shouldDismissOnTap = YES;
    self.popTip.edgeMargin = 5;
    self.popTip.offset = 2;
    self.popTip.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);

    self.popTip.popoverColor = [UIColor colorWithRed:0.31 green:0.57 blue:0.87 alpha:1];
    static int direction = 0;
    [self.popTip showText:@"Animated popover, great for subtle UI tips and onboarding" direction:direction maxWidth:200 inView: theTableView fromFrame: CGRectMake(_hiddenView.frame.origin.x, _hiddenView.frame.origin.y+ 1.1f*self.frame.size.height, _hiddenView.frame.size.width, _hiddenView.frame.size.height)   duration:0];
 //   direction = (direction + 1) % 4;
     */
}

-(void) showPlaySoundIndicator
{
    [self dismissPlaySoundIndicator];
    
    if(!activityIndicatorView)
    {
    activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeTripleRings tintColor:[UIColor blueColor] size: 60.0f ];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playSound  )];
    singleTap.numberOfTapsRequired = 1;
    [activityIndicatorView setUserInteractionEnabled:YES];
    [activityIndicatorView addGestureRecognizer:singleTap];
    }
    
    CGFloat width = btnPlay.layer.frame.size.width;
    CGFloat height = btnPlay.layer.frame.size.height;
    
    
    activityIndicatorView.frame = CGRectMake(btnPlay.layer.frame.origin.x+4, btnPlay.layer.frame.origin.y+5, btnPlay.layer.frame.size.width, btnPlay.layer.frame.size.height);
    
    //NSLog(@"btnPlay Frame x %f y %f width %f height %f", btnPlay.bounds.origin.x, btnPlay.bounds.origin.y,width, height );
    
 //   activityIndicatorView.center = btnPlay.center;
    
    [activityIndicatorView removeFromSuperview];
    [self addSubview: activityIndicatorView];
    [activityIndicatorView startAnimating];
}

-(void) changingColor
{
    if(stopChangingColor)
    {
        self.backgroundColor= [UIColor clearColor];
        return;
    }
    
    if(colorInt<1)
    {
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:205.0/255 alpha:0.3];
    }else
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    colorInt = (colorInt+1)%2;
    [self performSelector:@selector(changingColor) withObject:nil afterDelay: 0.4];
}

@end
