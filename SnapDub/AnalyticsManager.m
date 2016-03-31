//
//  AnalyticsManager.m
//  SnapDub
//
//  Created by Infinidy on 2015-07-22.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "AnalyticsManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

static AnalyticsManager* analyticsManager;

@implementation AnalyticsManager


+(AnalyticsManager*) getAnalyticsManager
{
    if(!analyticsManager)
    {
        analyticsManager = [[AnalyticsManager alloc] init];
    }
    return analyticsManager;
}

+(void) logTutorialStep:(NSString*)step{
    ////NSLog(@"------> Tutorial step: %@ ", step);
    
    NSDictionary *dimensions = dimensions = @{
                                              @"step":step
                                              };
    [PFAnalytics trackEvent:@"tutorial" dimensions:dimensions];
    
    //loggin this activity on facebook analytics
    [FBSDKAppEvents logEvent:FBSDKAppEventNameCompletedTutorial
                  parameters:@{ FBSDKAppEventParameterNameDescription    : step } ];
    

}


/*
 Usage: send these events:
 
 appOpen, adClose, adOpen,cpPopup_shown,cpPopup_no,cpPopup_yes,videoPage_featured,videoPage_latest,activityPage,userPage
 soundLiked,videoLiked, commentPosted, soundBoardCreated
 
 recordingUi_back_recordingPage
 recordingUi_filter_[name]
 recordingUi_star
 recordingUi_videoReplayPage_back
 recordingUi_videoReplayPage_next
 recordingUi_selectCatagoryPage_[catagory]
 recordingUi_selectCatagoryPage_back
 recordingUi_share_messenger
 recordingUi_share_whatsapp
 recordingUi_share_message
 recordingUi_share_instagram
 recordingUi_share_fbPost
 recordingUi_share_cameraRoll
 recordingUi_share_postOn
 recordingUi_share_back
 recordingUi_share_done

 */
+(void) logUIEvent:(NSString*)event{
    ////NSLog(@"------> UI Event: %@ ", step);
    
    NSDictionary *dimensions = dimensions = @{
                                              @"step":event
                                              };
    [PFAnalytics trackEvent:@"UIEvent" dimensions:dimensions];
    
    //loggin this activity on facebook analytics
    [FBSDKAppEvents logEvent:@"UIEvent"
                  parameters:@{ FBSDKAppEventParameterNameDescription: event } ];
    
    
}


@end
