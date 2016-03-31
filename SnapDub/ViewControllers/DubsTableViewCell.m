//
//  ProfileTableViewCell.m
//  SnapDub
//
//  Created by Poland on 08/05/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "DubsTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DubVideo.h"
#import "DubUser.h"
#import "DubSound.h"
#import "GeneralUtility.h"
#import "SDConstants.h"
#import "AppDelegate.h"
#import "CommentViewController.h"
#import "GeneralUtility.h"
#import "DubVideoParseHelper.h"
#import "ProfileViewController.h"
#import "DubVideoCreator.h"
#import "DMVideoShareViewController.h"

#import <FBSDKSharekit/FBSDKShareKit.h>
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface DubsTableViewCell(){
    UIDocumentInteractionController *docController;
}
@end



@implementation DubsTableViewCell
@synthesize imgprofile, lblName, lblTime, lblViews, imgPost,imgLike, lblDetail, lblLikes, lblComment, lblShare, btnDub, connectedDubVideo, connectedDubUser, tableView, connectedDubSound;




-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)awakeFromNib {
    // Initialization code
    [self setLayoutMargins:UIEdgeInsetsZero];
    
    UITapGestureRecognizer *singleTapRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeUnlikeClicked:)];
    [singleTapRecogniser setDelegate:self];
    singleTapRecogniser.numberOfTouchesRequired = 1;
    singleTapRecogniser.numberOfTapsRequired = 1;
    [imgLike setUserInteractionEnabled:YES];
    [imgLike addGestureRecognizer:singleTapRecogniser];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectUser)];
    singleTap.numberOfTapsRequired = 1;
    [self.imgprofile setUserInteractionEnabled:YES];
    [self.imgprofile addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectUser)];
    singleTap2.numberOfTapsRequired = 1;
    [self.lblName setUserInteractionEnabled:YES];
    [self.lblName addGestureRecognizer:singleTap2];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlaying) name:EVENT_STOP_PLAYING object:nil];
    
    [self.btnComment addTarget:self action:@selector(commentClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnDub addTarget:self action:@selector(dubThisClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [GeneralUtility processUserImage: self.imgprofile];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object: [self.celPlayer currentItem]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlaying)  name:EVENT_STOP_PLAYING object:nil];
    
    btnDub.hidden = YES;
}

-(void) cellIsSelected
{
    if(self.celPlayer.rate == 0){
        [self.celPlayer play];
        
    }
    else{
        [self manualPausePlaying];
    }

}

-(void)selectUser{
    if(!self.connectedDubUser.connectedParseObject)
    {
        return;
    }
    
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    ProfileViewController *controller = [delegate.navi.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    
    [controller setConnectedDubUser: self.connectedDubUser];
    controller.hidesBottomBarWhenPushed = YES;
    
    [GeneralUtility pushViewController: controller animated: YES];
    
    self.selected = NO;
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
  //  AVPlayerItem *p = [notification object];
   // [p seekToTime:kCMTimeZero];
    CGRect r = [self.tableView convertRect:self.frame toView: [tableView superview]];
    
    float yPosition = r.origin.y;
    
    if(yPosition<329 && yPosition>-141)
    {
        AVPlayerItem *p = [notification object];
        [p seekToTime:kCMTimeZero];
    }
}

-(void) updateCountersInfo
{
    self.lblViews.text = [NSString stringWithFormat: @"%d", self.connectedDubVideo.playCount];
    if(self.connectedDubVideo.playCount>0)
    {
        self.lblViews.hidden = NO;
        _viewWord.hidden = NO;
    }else
    {
        self.lblViews.hidden = YES;
        _viewWord.hidden = YES;
    }
    
    if(self.connectedDubVideo.likeCount>0)
    {
        lblLikes.text = [NSString stringWithFormat: self.connectedDubVideo.likeCount==1?@"%d Like" : @"%d Likes", self.connectedDubVideo.likeCount];
    }else
    {
        lblLikes.text = @"Like";
    }
        
    if(self.connectedDubVideo.commentCount>0)
    {
        lblComment.text = [NSString stringWithFormat: self.connectedDubVideo.commentCount==1?@"%d Comment" : @"%d Comments", self.connectedDubVideo.commentCount];
    }else
    {
        lblComment.text = @"Comment";
    }

}

-(void) setConnectedDubVideo:(DubVideo *)connectedDubVideo2
{
    connectedDubVideo = connectedDubVideo2;
    connectedDubUser = self.connectedDubVideo.creator;
    connectedDubSound = self.connectedDubVideo.connectedDubSound;
    
    imgprofile.image = [UIImage imageNamed: @"defaultUser.png"];
    
    if(self.connectedDubUser.profileImagePFFile.url)
    {
        imgprofile.file =  self.connectedDubUser.profileImagePFFile;
        [imgprofile loadInBackground];
    }
    
    if(self.connectedDubUser.profileName && self.connectedDubUser.profileName.length>0)
    {
        lblName.text = self.connectedDubUser.profileName;
    }else
    {
        lblName.text = @"User";
    }

    
  //  imgprofile.file =  self.connectedDubUser.profileImagePFFile;
  //  [imgprofile loadInBackground];
    
  //  lblName.text = self.connectedDubUser.profileName;
    lblTime.text = [GeneralUtility getDateDiffString: self.connectedDubVideo.createdDate];
    
    lblViews.text = [NSString stringWithFormat:@"%d",self.connectedDubVideo.playCount ] ;
    lblDetail.text = self.connectedDubSound.soundName;
    
    
    NSURL *path = [[NSURL alloc]initWithString: self.connectedDubVideo.videoFile.url ];
    //add previewImage
    if (connectedDubVideo.previewImage == nil) {

        self.imgPost.image = nil;

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
            AVAsset *asset = [AVAsset assetWithURL:path];
            AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
            //imageGenerator.appliesPreferredTrackTransform = YES;
            NSError *eror = nil;
            UIImage* image = [UIImage imageWithCGImage:[imageGenerator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:&eror]];
            dispatch_async(dispatch_get_main_queue(), ^{ // 2
                self.imgPost.image = image; // 3
            });
        });

    }
    else{
        [connectedDubVideo.previewImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
            UIImage *image = [UIImage imageWithData:data];
            self.imgPost.image = image;
        }];
    }
    
    
    [self.celPlayer replaceCurrentItemWithPlayerItem:nil];
    
    self.celPlayer = [AVPlayer playerWithURL:path];
    self.celPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.celPlayer currentItem]];
    
    self.celLayer = [AVPlayerLayer playerLayerWithPlayer: self.celPlayer];
    self.celLayer.frame =  self.imgPost.bounds;
    self.celLayer.videoGravity =  AVLayerVideoGravityResizeAspectFill;
    [self.imgPost.layer addSublayer: self.celLayer];

    [DubVideoParseHelper GetIsADubVideoLikedByCurrentUser: connectedDubVideo.connectedParseObject policy:kPFCachePolicyCacheThenNetwork block:^(BOOL result) {
        self.liked = result;
        [self updateLikeButton];
    }];
    
    /*
    [DubVideoParseHelper GetNumLikesOfAVideoInBackground:connectedDubVideo.connectedParseObject policy:kPFCachePolicyCacheThenNetwork block:^(int result, NSError *error) {
        if(result>1)
        {
            lblLikes.text = [NSString stringWithFormat: result==1?@"%d Like" : @"%d Likes", result];
        }else
        {
            lblLikes.text = @"Like";
}
    }];

    [DubVideoParseHelper GetNumCommentsOfAVideoInBackground:connectedDubVideo.connectedParseObject policy:kPFCachePolicyCacheThenNetwork block:^(int result, NSError *error) {
        if(result>1)
        {
            lblComment.text = [NSString stringWithFormat: result==1?@"%d Comment" : @"%d Comments", result];
        }
        else
        {
            lblComment.text = @"Comment";
        }
    }];
    */
    
    if(self.connectedDubSound)
        btnDub.hidden = NO;
    
    [self updateCountersInfo];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // [self stopPlaying];
    // Configure the view for the selected state
}

-(void) stopPlaying
{
    [self.celPlayer pause];
}

-(void) manualPausePlaying{
    [self.celPlayer pause];
    _Paused = YES;
}

-(void) playVideoIfNotBeingPlayed
{
    if(self.celPlayer.rate==0)
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName: EVENT_STOP_PLAYING object:nil];
      
        if (!_Paused)
        {
            [self.celPlayer play];
            //NSLog(@"Call playVidio Cloudcode");
            
            [PFCloud callFunctionInBackground:@"playVidio" withParameters:@{@"videoId": self.connectedDubVideo.connectedParseObject.objectId}
                                        block:^(NSString *response, NSError *error) {
                                            if (!error) {
                                                
                                            }
                                        }];
        }
    }
}

-(void) updateLikeButton
{
    if(self.liked)
    {
        [imgLike setImage:[UIImage imageNamed:@"smileYellow.png"]];
    }else
    {
        [imgLike setImage:[UIImage imageNamed:@"Smiley.png"]];
    }
}

- (IBAction)likeUnlikeClicked:(id)sender {
    
    //NSLog(@"Clicked like/unlike button");
    
    if(self.liked) {
        [self.connectedDubVideo unlike];
        self.liked = false;
        //remove .png extension
        [imgLike setImage:[UIImage imageNamed:@"Smiley"]];
    } else {
        [self.connectedDubVideo like];
        self.liked = true;
        [imgLike setImage:[UIImage imageNamed:@"smileYellow.png"]];
    }
    
}

-(void) updatePosition
{
    CGRect r = [self.tableView convertRect:self.frame toView: [tableView superview]];
    
    float yPosition = r.origin.y;
    
    if(yPosition<329 && yPosition>-141)
    {
        [self playVideoIfNotBeingPlayed];
    }
}

- (IBAction)commentClicked:(id)sender {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    CommentViewController * selRanger = [delegate.navi.storyboard instantiateViewControllerWithIdentifier:@"CommentViewController"];
    selRanger.connectedDubVideo = self.connectedDubVideo.connectedParseObject;

    [GeneralUtility pushViewController: selRanger animated:YES];
}


- (IBAction)moreclicked:(UIButton *)sender {
    NSString *actionSheetTitle = @"MoreOptions";
    //Action Sheet Title
    //NSString *destructiveTitle = @"Destructive Button"; //Action Sheet Button Titles
    NSString *otherforreport = @"Report Abuse";
    
    
    //adding Other Share option
    
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:otherforreport, nil];
    
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


- (IBAction)shareClicked:(id)sender {
    NSString *actionSheetTitle = @"Share";
    //Action Sheet Title
    NSString *destructiveTitle = @"Destructive Button"; //Action Sheet Button Titles
    NSString *other = @"WhatsApp";
    NSString *other1 = @"Facebook Post";
    NSString *other2 = @"Facebook Messenger";
    NSString *other3 = @"iMessage";
    NSString *other4 = @"Instagram";
    NSString *other5 = @"Camera Roll";
    NSString *other6 = @"Report Abuse";
    
    
    //adding Other Share option
    
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other2,other, other3,other4,other1, other5, other6, nil];
    
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


-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSString *tmpFile = [tmpDirectory stringByAppendingPathComponent:@"tempVideo.mp4"];
    
    if ([buttonTitle isEqualToString:@"Cancel"]) {
        //NSLog(@"Cancel pressed --> Cancel ActionSheet");
    }
    
    if ([buttonTitle isEqualToString:@"Report Abuse"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Video reported" message:@"Video reported for abusive content." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    if ([buttonTitle isEqualToString:@"Camera Roll"]) {
        NSString *camerastring = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tempVideo.mp4"];
        NSURL *video_outputFileUrl = [NSURL fileURLWithPath:camerastring];
        [self saveToCameraRoll:video_outputFileUrl];
    }

    
    if ([buttonTitle isEqualToString:@"WhatsApp"]) {
        
        [self.connectedDubVideo saveFileToTempFolderInBackground:^(BOOL result, NSString *filePath) {
            if (result) {
                NSURL *filePathURL = [NSURL fileURLWithPath:tmpFile isDirectory:NO];
                docController = [UIDocumentInteractionController interactionControllerWithURL:filePathURL];
                docController.UTI = @"net.whatsapp.movie";
                docController.delegate = (id)self;
                [docController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.superview animated:YES];            }
            else {
                //NSLog(@"ERROR: saveFiletoTempSound");
            }
        }];
        
    
    }
    if ([buttonTitle isEqualToString:@"Facebook Post"]) {
        
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

    }
    if ([buttonTitle isEqualToString:@"Facebook Messenger"]) {
        if ([FBSDKMessengerSharer messengerPlatformCapabilities] & FBSDKMessengerPlatformCapabilityVideo) {
            NSData *videoData = [NSData dataWithData:connectedDubVideo.videoFile.getData];
            [FBSDKMessengerSharer shareVideo:videoData withOptions:nil];
        }
        
    }
    if ([buttonTitle isEqualToString:@"iMessage"]) {
       
        [self.connectedDubVideo saveFileToTempFolderInBackground:^(BOOL result, NSString *filePath) {
            if (result) {
                    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
                    messageController.messageComposeDelegate = self;
                    if([MFMessageComposeViewController canSendText]) {
                        
                        NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath: tmpFile]];
                        BOOL didAttachVideo = [messageController addAttachmentData:videoData typeIdentifier:@"public.movie"filename: tmpFile];
                        
                        [self.navController presentViewController:messageController animated:YES completion:nil];
                        if (didAttachVideo) {
                            //NSLog(@"Video Attached.");
                            
                        } else {
                            //NSLog(@"Video Could Not Be Attached.");
                        }
                    }
                
                }
            
            else {
                //NSLog(@"ERROR: saveFiletoTempSound");
            }
        }];

    }

    //adding Action for Other Share Options
    if ([buttonTitle isEqualToString:@"Instagram"]) {

        
        [self.connectedDubVideo saveFileToTempFolderInBackground:^(BOOL result, NSString *filePath) {
            if (result) {
                NSString *caption = @"Some Preloaded Caption";
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                [library writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:tmpFile] completionBlock:^(NSURL *assetURL, NSError *error) {
                    NSString *instagramString =[NSString stringWithFormat:@"instagram://library?AssetPath=%@&InstagramCaption=%@",[assetURL absoluteString],caption];
                    NSString* webStringURL = [instagramString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    //NSLog(@"%@",webStringURL);
                    
                    NSURL *instagramURL = [NSURL URLWithString:webStringURL];
                    //NSLog(@"instagramURL %@ ",instagramURL);
                    
                    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
                        [[UIApplication sharedApplication] openURL:instagramURL];
                    }
                }];
            }
            else {
                //NSLog(@"ERROR: saveFiletoTempSound");
            }
        }];
    }
    
    
}

- (IBAction)dubThisClicked:(id)sender {
    if(!self.connectedDubSound)
        return;
    
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



-(void)facebookPostVideo{
    //                FBSDKShareVideo *video = [[FBSDKShareVideo alloc] init];
    //                video.videoURL = [NSURL fileURLWithPath:outputFilePath];
    //                FBSDKShareVideoContent *content = [[FBSDKShareVideoContent alloc] init];
    //                content.video = video;
    
    
    NSData *videoData = [NSData dataWithData:connectedDubVideo.videoFile.getData];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   videoData, @"video.mp4",
                                   @"video/mp4", @"contentType",
                                   connectedDubVideo.videoName, @"title",
                                   nil];
    
    
    [[[FBSDKGraphRequest alloc]
      initWithGraphPath:@"me/videos"
      parameters: params
      HTTPMethod:@"POST"]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             //NSLog(@"Post id:%@", result[@"id"]);
             [self Alert:@"Success!" joiningArgument2:@"Dub video posted on Facebook!"];
         }
         else{
             //NSLog(@"POST ERROR: %@",error.description);
             [self Alert:@"Failed" joiningArgument2:@"Failed to post video on Facebook. Please try again later."];
         }
     }];
}

- (void) saveToCameraRoll:(NSURL *)srcURL
{
    NSString *camerarollstring = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tempVideo.mp4"];
    
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
    //[MBProgressHUD hideHUDForView:self animated:YES];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Dub video has been successfully saved to your Camera Roll!" delegate:nil cancelButtonTitle:@"Cool!" otherButtonTitles:nil, nil];
    [alertView show];
    
    
    //new
    // code for get first frame of video(thumbnail)
    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:camerarollstring] options:nil];
    AVAssetImageGenerator* imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    NSError *eror = nil;
    UIImage* image = [UIImage imageWithCGImage:[imageGenerator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:&eror]];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    [DubVideoCreator setPreviewImageFile:[PFFile fileWithName:@"image.jpg" data:imageData]];
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
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cancelled" message:@"Dub video sending cancelled ;(" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
            break;
        case MessageComposeResultFailed:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failed!" message:@"Oops!!! Message sending failed. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
            break;
        case MessageComposeResultSent:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"The dub video has been sent!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
            break;
        default:
            break;
    }
}



@end
