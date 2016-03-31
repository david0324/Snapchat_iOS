//
//  DMVideoShareViewController.h
//  Dubsmash
//
//  Created by Altair on 4/29/15.
//  Copyright (c) 2015 Altair. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "DubAudioPlayer.h"
//#import <InstagramKit/InstagramKit.h>

@class DubSound;
@class DubVideo;

@interface DMVideoShareViewController : UIViewController<UIAlertViewDelegate, MFMessageComposeViewControllerDelegate, UIWebViewDelegate, UIDocumentInteractionControllerDelegate>
{
    UIBarButtonItem *doneButton;
}

- (void) whatsappshare;
- (void) facebookshare;
- (void) FacebookMessenger;


@property (weak, nonatomic) IBOutlet UIButton *fbMessengerButton;
@property (weak, nonatomic) IBOutlet UIButton *whatsappButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *fbButton;
@property (weak, nonatomic) IBOutlet UIButton *instagramButton;

@property (nonatomic,strong) DubVideo *sharedVideo;
@property (nonatomic,strong) DubSound *sharedSound;


@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UISwitch *postingSwitch;

@end

