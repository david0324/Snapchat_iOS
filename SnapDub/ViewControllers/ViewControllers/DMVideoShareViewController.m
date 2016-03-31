//
//  DMVideoShareViewController.m
//  Dubsmash
//
//  Created by Altair on 4/29/15.
//  Copyright (c) 2015 Altair. All rights reserved.
//

#import "DMVideoShareViewController.h"
#import "MBProgressHUD.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DubVideo.h"
#import "DubSound.h"
#import "SDTutorialManager.h"
#import "DubVideoCreator.h"
#import "AdManager.h"
#import "DubsTableViewCell.h"

#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>
#import <FBSDKSharekit/FBSDKShareKit.h>

#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface DMVideoShareViewController ()
{
    NSString *outputFilePath;
    UIDocumentInteractionController *docController;
}
@end
#define INSTAGRAM_CLIENT_ID         @"4ecd49a784244ff9b135c37245bc5df0"
#define INSTAGRAM_CLIENT_SECRET     @"2f485677ad0b46c29264ed14abf313c6"
#define ALERT_MESSENGER_TAG         100
#define Delete_Video_TAG         200
@implementation DMVideoShareViewController
@synthesize sharedSound,sharedVideo, fbMessengerButton, whatsappButton, messageButton, cameraButton, fbButton, instagramButton;

- (void) whatsappshare{
    NSString *whatapppost = [NSString stringWithFormat:@"whatsapp://send?text=Snapdub this! %@ https://deeplink.me/snapdub.com/%@", self.sharedSound.soundName, self.sharedSound.connectedParseObject.objectId];
    
    NSURL *whatsappURL =   [NSURL URLWithString:[whatapppost stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
    else{

    }
}

-(void) goBackToMain
{
    //self.navigationItem
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
    [AdManager sharedAppManager].disabled = NO;
   
    if(![AdManager sharedAppManager].disableVideoCreationEndAds)
        [[AdManager sharedAppManager] showGoogleInterstitial];
}

- (void) facebookshare{
    if (![[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logInWithPublishPermissions:@[@"publish_actions"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (!error) {
                if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {

                }
                [self facebookPostcontent];
            }
            else{
            }
        }];
        
    }
    else {
        [self facebookPostcontent];
    }
    
    [self showDoneButton];
}

-(void) FacebookMessenger{
    if([FBSDKMessengerSharer messengerPlatformCapabilities]){
        NSString *messangerpost = [NSString stringWithFormat:@"http://snapdub.parseapp.com/?%@", self.sharedSound.connectedParseObject.objectId];
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentURL = [NSURL URLWithString:messangerpost ];
        content.contentTitle = @"snapdub";
        NSString *fbmessage = [NSString stringWithFormat:@"Snapdub this! %@", self.sharedSound.soundName];
        content.contentDescription = fbmessage;
        [FBSDKMessageDialog showWithContent:content delegate:self];
        [self Alert:@"Facebook Messenger" joiningArgument2:@"Message Sent"];
    }
    else{
        [self Alert:@"Messenger" joiningArgument2:@"Application not istalled"];
    }
}

-(void) uploadVideo
{
    if(!_postingSwitch.on)
    {
        return;
    }
    //new
    // code for get first frame of video(thumbnail)
    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:outputFilePath] options:nil];
    AVAssetImageGenerator* imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    NSError *eror = nil;
    UIImage* image = [UIImage imageWithCGImage:[imageGenerator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:&eror]];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    [DubVideoCreator setPreviewImageFile:[PFFile fileWithName:@"image.jpg" data:imageData]];
    
    [DubVideoCreator createADubVideoByCurrentUser];
}

-(void) showDoneButton
{
    self.navigationItem.rightBarButtonItem = doneButton;
}

-(void) videoDone
{
    [self uploadVideo];
    
    [self goBackToMain];
}

-(void) showButtonAnimation
{
    [[SDTutorialManager ShareManager] generateListOfButtonAnimation:@[fbMessengerButton, whatsappButton, messageButton, instagramButton , fbButton, cameraButton]];
    
    [SDTutorialManager showTutorialBarMessageWithTitle:@"Share" message:@"Share you funny dubvideo now." isOnTop:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done"
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(videoDone)];

    // Do any additional setup after loading the view.
    if  (sharedVideo != NULL) {
        // build temp file store video
        outputFilePath =[NSTemporaryDirectory() stringByAppendingPathComponent:@"tempVideo.mp4"];
    }
    else if (sharedSound != NULL){
        outputFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tempSound.mp4"];
    }
    else
    outputFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"final.m4v"];
    
    [self performSelector:@selector(showButtonAnimation) withObject:nil afterDelay:0.5f];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [SDTutorialManager hideAllTutorialMessages];
    
    [NSObject cancelPreviousPerformRequestsWithTarget: [SDTutorialManager ShareManager]];
    //[[SDTutorialManager ShareManager] stopListOfButtonAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onMessengerAction:(id)sender {
    if ([FBSDKMessengerSharer messengerPlatformCapabilities] & FBSDKMessengerPlatformCapabilityVideo) {
        NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:outputFilePath]];
        [FBSDKMessengerSharer shareVideo:videoData withOptions:nil];
    }
    [self showDoneButton];
}

- (IBAction)onMessageAction:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        if([MFMessageComposeViewController canSendText]) {
            NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:outputFilePath]];
            BOOL didAttachVideo = [messageController addAttachmentData:videoData typeIdentifier:@"public.movie"filename:outputFilePath];
            if (didAttachVideo) {
                
            } else {

            }
        }
        [self presentViewController:messageController animated:YES completion:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Send Message" message:@"Text messaging is not available without SIM." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    [self performSelector:@selector(hideIndicator) withObject:nil afterDelay:3.0f];
    
    [self showDoneButton];
}

- (IBAction)onInstagramAction:(id)sender {
    //NSURL *videoUrl = [NSURL URLWithString:outputFilePath];
    
    NSString *caption = @"Some Preloaded Caption";
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    //NSLog(@"Sharecontoller instagram :%@", outputFilePath);
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:outputFilePath] completionBlock:^(NSURL *assetURL, NSError *error) {
        NSString *instagramString =[NSString stringWithFormat:@"instagram://library?AssetPath=%@&InstagramCaption=%@",[assetURL absoluteString],caption];
        NSString* webStringURL = [instagramString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        //NSLog(@"%@",webStringURL);
        
        NSURL *instagramURL = [NSURL URLWithString:webStringURL];
        //NSLog(@"instagramURL %@ ",instagramURL);
        
        if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
            [[UIApplication sharedApplication] openURL:instagramURL];
        }
    }];
    
    [self showDoneButton];
}

- (IBAction)onWhatsappAction:(id)sender {

    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType isEqualToString:@"iPhone"]) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
        }else{
            
        }
    }else{
    }
    NSURL *filePathURL = [NSURL fileURLWithPath:outputFilePath isDirectory:NO];
    docController = [UIDocumentInteractionController interactionControllerWithURL:filePathURL];
    docController.UTI = @"net.whatsapp.movie";
    docController.delegate = self;
    [docController presentOpenInMenuFromRect:self.view.frame inView:self.view animated:YES];

    [self showDoneButton];
}


- (IBAction)onFacebookAction:(id)sender {
    

    
    if (![[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
        //NSLog(@"DO NOT HAVE PUBLISH PERMISSION");
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logInWithPublishPermissions:@[@"publish_actions"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (!error) {
                if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
                    //NSLog(@"HAS PERMISSION");
                }
                [self facebookPostVideo];
            }
            else{
                //NSLog(@"PUBLISH PERMISSION ERROR: %@",error.description);
            }
        }];
        
    }
    else {
        [self facebookPostVideo];
    }
    
    [self showDoneButton];
}







-(void)facebookPostVideo{
    //                FBSDKShareVideo *video = [[FBSDKShareVideo alloc] init];
    //                video.videoURL = [NSURL fileURLWithPath:outputFilePath];
    //                FBSDKShareVideoContent *content = [[FBSDKShareVideoContent alloc] init];
    //                content.video = video;
    
    
    NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:outputFilePath]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   videoData, @"video.mp4",
                                   @"video/mp4", @"contentType",
                                   sharedVideo.videoName, @"title",
                                   nil];
    
    
    [[[FBSDKGraphRequest alloc]
      initWithGraphPath:@"me/videos"
      parameters: params
      HTTPMethod:@"POST"]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             //NSLog(@"Post id:%@", result[@"id"]);
             [self Alert:@"Facebook" joiningArgument2:@"Video Posted"];
         }
         else{
             //NSLog(@"POST ERROR: %@",error.description);
             [self Alert:@"Facebook" joiningArgument2:@"Video post failed!"];
         }
     }];
}


-(void)facebookPostcontent{
    
    NSString *fbpost = [NSString stringWithFormat:@"Snapdub this! %@ -http://snapdub.parseapp.com/?%@", self.sharedSound.soundName, self.sharedSound.connectedParseObject.objectId];
    
    
    [[[FBSDKGraphRequest alloc]
      
      initWithGraphPath:@"me/feed"
      
      parameters: @{ @"message" : fbpost}
      
      HTTPMethod:@"POST"]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         
         if (!error) {
             
             //NSLog(@"Post id:%@", result[@"id"]);
             [self Alert:@"Shared on Facebook!" joiningArgument2:@"Your dubsound was posted on Facebook!"];
         }
         
         else{
             
             //NSLog(@"POST ERROR: %@",error.description);
             [self Alert:@"Facebook" joiningArgument2:@"FaceBook post failed!"];
         }
         
     }];
    
}



//MFMessageComposeViewController Delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultCancelled:
        {
            //NSLog(@"Cancelled");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cancelled Sending Video" message:@"You're cancelled sending video" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
            break;
        case MessageComposeResultFailed:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failed!" message:@"You can't send video" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
            break;
        case MessageComposeResultSent:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"The video file has sent." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
            break;
        default:
            break;
    }
}

- (IBAction)onCameraRollAction:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *video_outputFileUrl = [NSURL fileURLWithPath:outputFilePath];
    [self saveToCameraRoll:video_outputFileUrl];
    
    
    
    [self showDoneButton];
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    
    
    //[DubAudioPlayer ShareInstance].delegate = self.audioPlayer;
    
    [[DubAudioPlayer ShareInstance] playAudioFromAPFFile:self.sharedSound.soundPFFile];
    
    // webview
    //    [mWebView setHidden:NO];
    //    mWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //    mWebView.scrollView.bounces = NO;
    //    mWebView.contentMode = UIViewContentModeScaleAspectFit;
    //    mWebView.delegate = self;
    //
    //    NSDictionary *configuration = [InstagramEngine sharedEngineConfiguration];
    //    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=token", configuration[kInstagramKitAuthorizationUrlConfigurationKey], configuration[kInstagramKitAppClientIdConfigurationKey], configuration[kInstagramKitAppRedirectUrlConfigurationKey]]];
    //
    //    [mWebView loadRequest:[NSURLRequest requestWithURL:url]];
    //
    //    [[InstagramEngine sharedEngine] loginWithBlock:^(NSError *error) {
    //        NSLog(error);
    //    }];
    //    [self performSelector:@selector(hideIndicator) withObject:nil afterDelay:3.0f];
    
    
//    NSString *URLString = [request.URL absoluteString];
//    //NSLog(@"Redirect_URI %@", [[InstagramEngine sharedEngine] appRedirectURL]);
//    if ([URLString hasPrefix:[[InstagramEngine sharedEngine] appRedirectURL]]) {
//        NSString *delimiter = @"access_token=";
//        NSArray *components = [URLString componentsSeparatedByString:delimiter];
//        if (components.count > 1) {
//            NSString *accessToken = [components lastObject];
//            //NSLog(@"ACCESS TOKEN = %@",accessToken);
//            [[InstagramEngine sharedEngine] setAccessToken:accessToken];
//            [mWebView setHidden:YES];
//            [self uploadVideoToInstagram];
//        }
//        return NO;
//    }
    return YES;
}

- (void)uploadVideoToInstagram {
    NSURL *videoFilePath = [NSURL fileURLWithPath:outputFilePath isDirectory:NO]; // Your local path to the video
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:videoFilePath completionBlock:^(NSURL *assetURL, NSError *error) {
        NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://library?AssetPath=%@",[assetURL absoluteString]]];
        if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
            [[UIApplication sharedApplication] openURL:instagramURL];
        }
    }];

    [self showDoneButton];
}
- (IBAction)onDiscard:(id)sender {
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Delete Video" message:@"Are you sure what don't want to save this video?" delegate:nil cancelButtonTitle:@"Delete" otherButtonTitles:@"Cancel",nil ];
    alertView.tag = Delete_Video_TAG;
    alertView.delegate = self;
    [alertView show];

}

- (void) saveToCameraRoll:(NSURL *)srcURL
{
    
    
    //NSLog(@"srcURL: %@", srcURL);
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    ALAssetsLibraryWriteVideoCompletionBlock videoWriteCompletionBlock =
    ^(NSURL *newURL, NSError *error) {
        if (error) {
            NSLog( @"Error writing image with metadata to Photo Library: %@", error );
        } else {
            NSLog( @"Wrote image with metadata to Photo Library %@", newURL.absoluteString);
        }
    };
    
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:srcURL])
    {
        [library writeVideoAtPathToSavedPhotosAlbum:srcURL
                                    completionBlock:videoWriteCompletionBlock];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your Dub has been successfully saved to your Camera Roll!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [alertView show];

}

-(void) saveImageToCameraRoll: (NSURL *)srcURL{
    //NSLog(@"srcURL: %@", srcURL);
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    ALAssetsLibraryWriteVideoCompletionBlock videoWriteCompletionBlock =
    ^(NSURL *newURL, NSError *error) {
        if (error) {
            NSLog( @"Error writing image with metadata to Photo Library: %@", error );
        } else {
            NSLog( @"Wrote image with metadata to Photo Library %@", newURL.absoluteString);
        }
    };
    
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:srcURL])
    {
        [library writeVideoAtPathToSavedPhotosAlbum:srcURL
                                    completionBlock:videoWriteCompletionBlock];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your Dub has been successfully saved Image to your Camera Roll!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)hideIndicator {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void) Alert:( NSString * )title
joiningArgument2:( NSString * )message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == ALERT_MESSENGER_TAG) {
//        if(buttonIndex == 0) {
//            NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:outputFilePath]];
//            [FBSDKMessengerSharer shareVideo:videoData withOptions:nil];
//        }
    }
    else if(alertView.tag == Delete_Video_TAG)
    {
        [self goBackToMain];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
