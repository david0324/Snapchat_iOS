//
//  ActivityTableViewCell.m
//  SnapDub
//
//  Created by Poland on 08/05/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "ActivityTableViewCell.h"
#import "UserActivity.h"
#import "DubUser.h"
#import "DubSound.h"
#import "AppDelegate.h"
#import "GeneralUtility.h"
#import "DubSoundboardSelectionViewController.h"
#import "DubVideoCreator.h"
#import "DMVideoRecordingViewController.h"
#import "SDConstants.h"
#import "ProfileViewController.h"

@implementation ActivityTableViewCell
@synthesize imgUser,lblComment,lblName,lblTime,btnFav,btnMore,btnPlay, connectedActivity, sound;

- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectUser)];
    singleTap.numberOfTapsRequired = 1;
    [self.imgUser setUserInteractionEnabled:YES];
    [self.imgUser addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectUser)];
    singleTap2.numberOfTapsRequired = 1;
    [self.lblName setUserInteractionEnabled:YES];
    [self.lblName addGestureRecognizer:singleTap2];
   // [self.lblName setUserInteractionEnabled:YES];
   // [self.lblName addGestureRecognizer:singleTap];
}

-(void)selectUser{
    //NSLog(@"Select User");
    
    if(!connectedActivity.fromUserRef.connectedParseObject)
    {
        return;
    }
    
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    ProfileViewController *controller = [delegate.navi.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    
    [controller setConnectedDubUser: connectedActivity.fromUserRef];
  //  controller.hidesBottomBarWhenPushed = YES;
    
    [GeneralUtility pushViewController: controller animated: YES];
    
    self.selected = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setConnectedActivity:(UserActivity *)connectedActivity2
{
    connectedActivity = connectedActivity2;
    
    DubUser* fromUser = connectedActivity.fromUserRef;

    
    self.imgUser.file = fromUser.profileImagePFFile;
    self.sound = connectedActivity.soundRef;
    
    [self.imgUser setHidden: YES];

    self.lblName.text = fromUser.profileName;
    
    self.lblTime.text = [GeneralUtility getDateDiffString: connectedActivity.createdAt];
    
    if( [connectedActivity.activityType isEqualToString: kSDUserActivityActivityTypePostADubSoundValue] )
    {
        self.lblComment.text = @"posted a dubSound.";
    }else
    {
        self.lblComment.text = @"liked a dubSound.";
    }
    
    [self.imgUser loadInBackground:^(UIImage *image, NSError *error) {
        if(!error)
        {
            [self.imgUser setHidden: NO];
            
            [GeneralUtility processUserImage: self.imgUser];
        }
    }];
    
    if([self.sound isLikedByCurrentUser])
    {
        [btnFav setImage:[UIImage imageNamed:@"smileYellow.png"] forState:UIControlStateNormal];
    }else
    {
        [btnFav setImage:[UIImage imageNamed:@"Smiley"] forState:UIControlStateNormal];
    }
    
    [self.sound loadSoundDataInBackgournd:^(NSData *data, NSError *error) {
        
    }];
    
}

-(void) audioPaused:(AVAudioPlayer *)player
{
    //NSLog(@"Audio being audioPaused");
    currentState = PAUSE;
    //change back to pause button
}

-(void) audioBeingPlayed:(AVAudioPlayer *)player
{
    //NSLog(@"Audio being audioBeingPlayed");
    currentState = PLAYING;
    
    //change to pause button image
}

-(void) audioBeingLoaded:(AVAudioPlayer *)player
{
    //NSLog(@"Audio being Loaded");
    currentState = LOADING;
    //show indicator
}

- (IBAction)playSoundClicked:(UIButton *)sender {
    //play audiofile streaming
    if(currentState==PLAYING && [DubAudioPlayer ShareInstance].delegate == self)
    {
        [[DubAudioPlayer ShareInstance] pauseAudio];
    }
    else if(currentState!=PLAYING && [DubAudioPlayer ShareInstance].delegate == self)
    {
        [[DubAudioPlayer ShareInstance] playAudioFromAPFFile:self.sound.soundPFFile];
    }
    else
    {
        [DubAudioPlayer ShareInstance].delegate = self;
        
        [[DubAudioPlayer ShareInstance] playAudioFromAPFFile:self.sound.soundPFFile];
    }
}

- (IBAction)starClicked:(id)sender {
    
    //NSLog(@"Clicked fav button");
    
    if([self.sound isLikedByCurrentUser]) {
        [btnFav setImage:[UIImage imageNamed:@"Smiley"] forState:UIControlStateNormal];
        
        [self.sound unlike];
    } else {
        [btnFav setImage:[UIImage imageNamed:@"smileYellow.png"] forState:UIControlStateNormal];
        
        [self.sound like];
    }
    
}

- (IBAction)moreButtonClicked:(id)sender {
    
    NSString *actionSheetTitle = @"Action";

    NSString *other1 = @"Add To Soundboard";
    NSString *other2 = @"Share";
    
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other1, other2, nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        /* In this case the device is an iPad.
         [actionSheet showFromRect:[(UIButton *)sender frame] inView:self.view animated:YES];*/
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
    
    
    if ([buttonTitle isEqualToString:@"Share"]) {
        //NSLog(@"Share pressed");
    }
    if ([buttonTitle isEqualToString:@"Report"]) {
        //NSLog(@"Report pressed");
    }
    if ([buttonTitle isEqualToString:@"Add To Soundboard"]) {
        //NSLog(@"Add To Soundboard");
        
        AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
        
        DubSoundboardSelectionViewController *controller = [delegate.navi.storyboard instantiateViewControllerWithIdentifier:@"DubSoundboardSelectionViewController"];
        controller.connectedSound = self.sound;
        controller.hidesBottomBarWhenPushed = YES;
        [GeneralUtility pushViewController: controller animated:YES];
        
    }
    if ([buttonTitle isEqualToString:@"Cancel"]) {
        //NSLog(@"Cancel pressed --> Cancel ActionSheet");
    }
}

-(void) cellIsSelected
{
    [self.sound saveFileToTempFolderInBackground:^(BOOL result, NSString *filePath) {
        
        if(result)
        {
            AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
            
            DMVideoRecordingViewController *controller = [delegate.navi.storyboard instantiateViewControllerWithIdentifier:@"DMVideoRecordingViewController"];
            [DubVideoCreator resetData];
            [DubVideoCreator setDubSoundRef: self.sound];
            
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



@end
