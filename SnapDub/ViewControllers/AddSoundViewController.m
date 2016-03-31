//
//  AddSoundViewController.m
//  SnapDub
//
//  Created by Poland on 07/05/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "AddSoundViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "RangeViewController.h"
#import "UIViewController+Starlet.h"
#import "Common.h"

@interface AddSoundViewController ()

@end

@implementation AddSoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onMusicPick:(id)sender {
    MPMediaPickerController* mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = NO;
    mediaPicker.showsCloudItems = NO;
    mediaPicker.prompt = @"Select songs to play";
    [self presentViewController:mediaPicker animated:YES completion:nil];
    
}

- (IBAction)onGalleryPick:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        //imagePicker.allowsEditing = YES;
        
        imagePicker.mediaTypes = @[(NSString*)kUTTypeMovie];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController* popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            popoverController.delegate = self;
            
            CGRect frame = self.view.bounds;
            [popoverController presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        } else {
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
}

#pragma mark - image picker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeMovie]) {
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        self.selectedMediaURL = url.absoluteString;
        [self extractAudioFromVideo:url];
        
        //self.mediaImageView.image = [UIImage imageNamed:@"img_record"];
        
        //self.mediaImageView.image = image;
    }
}

#pragma mark - Media picker delegate
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    MPMediaItem* item = [mediaItemCollection representativeItem];
    NSURL *url = [item valueForProperty:MPMediaItemPropertyAssetURL];
    
    //    [item enumerateValuesForProperties:[NSSet setWithObjects:MPMediaItemPropertyPersistentID, MPMediaItemPropertyMediaType, MPMediaItemPropertyAssetURL, nil] usingBlock:^(NSString *property, id value, BOOL *stop) {
    //        //NSLog(@"property : %@, %@", property, value);
    //    }];
    if (url == nil) {
        //NSLog(@"%@ has DRM", [item valueForProperty:MPMediaItemPropertyTitle]);
        self.selectedMediaURL = [item valueForProperty:MPMediaItemPropertyPersistentID];
        self.selectedMediaType = MediaType_AudioPrefID;
    } else {
        self.selectedMediaURL = url.absoluteString;
        //NSLog(@"item: %@", url);
        [mediaPicker dismissViewControllerAnimated:YES completion:nil];
        RangeViewController * selRanger = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectRangeViewController"];
        [selRanger setSrcFile:url];
        [self.navigationController pushViewController:selRanger animated:YES];
    }
    //self.mediaImageView.image = [UIImage imageNamed:@"img_record"];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)extractAudioFromVideo:(NSURL *) inputFile
{
    NSURL *audioFileInput = inputFile;
    NSURL *audioFileOutput = [self outputPathURL];
    AVAsset *movie = [AVAsset assetWithURL:inputFile];
    CMTime movieLength = movie.duration;
    
    // CMTime duration = playerItem.duration;
    float duration = CMTimeGetSeconds(movieLength);
    if (!audioFileInput || !audioFileOutput)
    {
        return NO;
    }
    
    [[NSFileManager defaultManager] removeItemAtURL:audioFileOutput error:NULL];
    AVAsset *asset = [AVAsset assetWithURL:audioFileInput];
    
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:asset
                                                                            presetName:AVAssetExportPresetAppleM4A];
    
    if (exportSession == nil)
    {
        return NO;
    }
    
    CMTime startTime = CMTimeMake((int)(floor(0 * 100)), 100);
    CMTime stopTime = CMTimeMake((int)(ceil(10 * 100)), 100);
    CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(startTime, movieLength);
    
    exportSession.outputURL = audioFileOutput;
    exportSession.outputFileType = AVFileTypeAppleM4A;
    exportSession.timeRange = exportTimeRange;
    
    [self showHUD];
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (AVAssetExportSessionStatusCompleted == exportSession.status)
             {
                 [self hideHUD];
                 // It worked!
                 //NSLog(@"audio is extracted successfully!");
                 RangeViewController * selRanger = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectRangeViewController"];
                 [selRanger setSrcFile:audioFileOutput];
                 [self.navigationController pushViewController:selRanger animated:YES];
             }
             else if (AVAssetExportSessionStatusFailed == exportSession.status)
             {
                 [self hideHUD];
                 // It failed...
                 //NSLog(@"extracting audio is failed!");
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail!"
                                                                 message:@"Audio extracting is failed!"
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                 [alert show];
             }
         });
     }];
    
    return YES;
}

-(NSURL*)outputPathURL {
    return [Common withFilePathURL:kAudioFile extension:@"m4a"];
}


@end


