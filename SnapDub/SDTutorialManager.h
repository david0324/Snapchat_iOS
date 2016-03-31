//
//  SDTutorialManager.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-07-16.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWMessageBarManager.h"
#import "StringConstants.h"
#import "AnalyticsManager.h"

@class MMPopLabel;
@interface SDTutorialManager : NSObject
{
    /*
    BOOL playSoundStepFinished;
    BOOL clickOnSoundCellStepFinished;
    BOOL clickOnVideoFilterStepFinished;
    BOOL clickOnVideoStartRecordingStepFinished;
    BOOL clikcOnVideoPreviewNextButtonStepFinished;
    
    BOOL shareDubVideoStepFinished;
    
    BOOL showHowToUseSoundEditingStepFinished;
    
    BOOL showSelectSoundToMakeVideoReminder1Finished;
    BOOL showSelectSoundToMakeVideoReminder2Finished;
    BOOL showSelectSoundToMakeVideoReminder3Finished;
    
    BOOL showFavoriteSoundReminderFinished;
    
    BOOL createVideoStepFinished;
    BOOL videoCLickNextStepFinished;
    */
    NSMutableDictionary* stepDictionary;
}

/*
@property (nonatomic, assign) BOOL playSoundStepFinished;
@property (nonatomic, assign) BOOL createVideoStepFinished;
@property (nonatomic, assign) BOOL videoCLickNextStepFinished;
@property (nonatomic, assign) BOOL shareDubVideoStepFinished;

@property (nonatomic, assign) BOOL clickOnSoundCellStepFinished;
@property (nonatomic, assign) BOOL clickOnVideoFilterStepFinished;
@property (nonatomic, assign) BOOL clickOnVideoStartRecordingStepFinished;
@property (nonatomic, assign) BOOL clikcOnVideoPreviewNextButtonStepFinished;

@property (nonatomic, assign) BOOL showHowToUseSoundEditingStepFinished;
@property (nonatomic, assign) BOOL showSelectSoundToMakeVideoReminder1Finished;
@property (nonatomic, assign) BOOL showSelectSoundToMakeVideoReminder2Finished;
@property (nonatomic, assign) BOOL showSelectSoundToMakeVideoReminder3Finished;
@property (nonatomic, assign) BOOL showFavoriteSoundReminderFinished;
*/

+(SDTutorialManager*) ShareManager;
-(void) saveData;
-(void) loadData;
+(void) showTutorialBarMessageWithTitle:(NSString*) title message: (NSString*) msg isOnTop:(BOOL) m clickToDismiss: (BOOL) dismiss;
+(void) showTutorialBarMessageWithTitle:(NSString*) title message: (NSString*) msg isOnTop:(BOOL) m;
-(void) generateUIViewAnimation: (UIView*) view;
+(SDTutorialManager*) ShareSDTutorialManager;
+(MMPopLabel*) GetGeneralMMPopLabel:(NSString*) msg;
+(void) showTutorialBarMessage: (NSString*) msg;

+(void) grandCameraAccess: (void(^) (BOOL granted)) completeBlock;

-(void) generateListOfButtonAnimation: (NSArray*) buttonList;
+(void) hideAllTutorialMessages;
-(void) stopUIViewAnimation: (UIView*)view;

-(void) setTutorialStepFinish: (NSString*) stepName;
-(BOOL) isTutorialStepDone: (NSString*) stepName;
@end
