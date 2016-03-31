//
//  SDTutorialManager.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-07-16.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "SDTutorialManager.h"
#import "MMPopLabel.h"
#import <AVFoundation/AVFoundation.h>
#import "GeneralUtility.h"


static SDTutorialManager* shareManager;
@implementation SDTutorialManager
/*
@synthesize playSoundStepFinished, createVideoStepFinished, videoCLickNextStepFinished, shareDubVideoStepFinished, clickOnSoundCellStepFinished, clickOnVideoFilterStepFinished, clickOnVideoStartRecordingStepFinished,  clikcOnVideoPreviewNextButtonStepFinished, showHowToUseSoundEditingStepFinished, showSelectSoundToMakeVideoReminder1Finished, showSelectSoundToMakeVideoReminder2Finished, showSelectSoundToMakeVideoReminder3Finished, showFavoriteSoundReminderFinished;
*/

+(SDTutorialManager*) ShareManager
{
    if(!shareManager)
    {
        shareManager = [[SDTutorialManager alloc] init];
    }
    return shareManager;
}

-(id) init
{
    if(self == [super init])
    {
        stepDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

+(void) hideAllTutorialMessages
{
 
}

+(void) showTutorialBarMessageWithTitle:(NSString*) title message: (NSString*) msg isOnTop:(BOOL) m clickToDismiss: (BOOL) dismiss
{

}

+(void) showTutorialBarMessageWithTitle:(NSString*) title message: (NSString*) msg isOnTop:(BOOL) m
{

}

+(void) showTutorialBarMessage: (NSString*) msg
{

}

+(MMPopLabel*) GetGeneralMMPopLabel:(NSString*) msg
{
    return nil;
}

+(SDTutorialManager*) ShareSDTutorialManager
{
    if(!shareManager)
    {
        shareManager = [[SDTutorialManager alloc] init];
    }
    return shareManager;
}


+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 99)
    {
        
    }
}

+(void) grandCameraAccess: (void(^) (BOOL granted)) completeBlock
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status == AVAuthorizationStatusAuthorized) {
        //NSLog(@"AVAuthorizationStatusAuthorized");
        // authorized
        if(completeBlock)
        {
            completeBlock(YES);
        }
        
    } else
    {// not determined
      //  [GeneralUtility popupMessage:@"Grant Access" message:@"We will ask for permission to use the camera to record DubVideos. Please grant us the access permission :)"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Grant Access"
                                                        message:@"We will ask for permission to use the camera to record DubVideos. Please grant us the access permission :)"
                                                       delegate: self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        alert.tag = 99;
        [alert show];

    }
}

-(void) generateListOfButtonAnimation: (NSArray*) buttonList
{
    for(int i=0; i<[buttonList count]; i++)
    {
        __block BOOL isFinal = i==[buttonList count]-1;
        UIButton* button = [buttonList objectAtIndex: i];
        
        [UIView animateKeyframesWithDuration:0.2 delay:(0.25f)*(float)i options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.60 animations:^{
                button.transform = CGAffineTransformMakeScale(1.4, 1.2);
            }];
            [UIView addKeyframeWithRelativeStartTime:0.60 relativeDuration:0.40 animations:^{
                button.transform = CGAffineTransformIdentity;
            }];
        } completion:^(BOOL finished) {
            
            if(isFinal)
            {
                //NSLog(@"Completed");
            
                [self performSelector:@selector(generateListOfButtonAnimation:) withObject: buttonList afterDelay:2.0];
            }
        }];
        
    }
    
}

-(void) stopUIViewAnimation: (UIView*)view
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(generateUIViewAnimation:) object: view];
}

-(void) generateUIViewAnimation: (UIView*) view
{
    [UIView animateKeyframesWithDuration:0.4 delay:0 options: UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.60 animations:^{
            view.transform = CGAffineTransformMakeScale(1.3, 3.6);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.60 relativeDuration:0.40 animations:^{
            view.transform = CGAffineTransformIdentity;
        }];
    } completion:^(BOOL finished) {
        
        [self performSelector:@selector(generateUIViewAnimation:) withObject: view afterDelay:0.1];
    
    }];
}

-(void) setTutorialStepFinish: (NSString*) stepName
{
    if( ![[stepDictionary valueForKey: stepName] boolValue] )
    {
        [stepDictionary setObject:[NSNumber numberWithBool:YES] forKey: stepName ];

        //NSLog(@"%@ TUTORial name %@ value %d",stepDictionary, stepName, [(NSNumber*)[stepDictionary objectForKey: stepName] boolValue]);
        
        [AnalyticsManager logTutorialStep: stepName];
    }
}

-(BOOL) isTutorialStepDone: (NSString*) stepName
{
    return YES;
}

-(void) saveData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject: stepDictionary forKey: @"stepDictionary"];
    
    /*
    [defaults setBool: playSoundStepFinished forKey:@"playSoundStepFinished"];
    [defaults setBool: clickOnSoundCellStepFinished forKey:@"clickOnSoundCellStepFinished"];
    [defaults setBool: clickOnVideoFilterStepFinished forKey:@"clickOnVideoFilterStepFinished"];
    [defaults setBool: clickOnVideoStartRecordingStepFinished forKey:@"clickOnVideoStartRecordingStepFinished"];
    
    [defaults setBool: clikcOnVideoPreviewNextButtonStepFinished forKey:@"clikcOnVideoPreviewNextButtonStepFinished"];
    [defaults setBool: shareDubVideoStepFinished forKey:@"shareDubVideoStepFinished"];
    [defaults setBool: showHowToUseSoundEditingStepFinished forKey:@"showHowToUseSoundEditingStepFinished"];
    [defaults setBool: showSelectSoundToMakeVideoReminder1Finished forKey:@"showSelectSoundToMakeVideoReminder1Finished"];
    
    
    [defaults setBool: showSelectSoundToMakeVideoReminder2Finished forKey:@"showSelectSoundToMakeVideoReminder2Finished"];
    [defaults setBool: showSelectSoundToMakeVideoReminder3Finished forKey:@"showSelectSoundToMakeVideoReminder3Finished"];
    [defaults setBool: showFavoriteSoundReminderFinished forKey:@"showFavoriteSoundReminderFinished"];
    [defaults setBool: createVideoStepFinished forKey:@"createVideoStepFinished"];
    
    [defaults setBool: videoCLickNextStepFinished forKey:@"videoCLickNextStepFinished"];
     */
}

-(void) loadData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    stepDictionary =  [NSMutableDictionary dictionaryWithDictionary: (NSDictionary*)[defaults objectForKey: @"stepDictionary"]] ;
    
    if (!stepDictionary) {
        stepDictionary= [NSMutableDictionary dictionary];
    }
    
}

@end
