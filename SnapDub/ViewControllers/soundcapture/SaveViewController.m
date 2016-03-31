
#import "SaveViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIViewController+Starlet.h"
#import "Common.h"
#import "DubSound.h"
#import "DubSoundCreator.h"
#import "GeneralUtility.h"
#import "DubCategory.h"
#import "FeaturedContentsManager.h"
#import "AppDelegate.h"
#import "CategorySelectionViewController.h"
#import "AddSoundTagsViewController.h"
@implementation SaveViewController

-(void) viewDidLoad {
    //_Filename.text = @"test";
    [_Filename becomeFirstResponder];
}

-(void) performNextAction
{
    if(_Filename.text.length<3)
    {
        _warningMsg.hidden = NO;
        return;
    }
    savingFileName = [[GeneralUtility uuid] stringByAppendingString: [NSString stringWithFormat: @"_%@", _Filename.text] ];
    
    savingFilePath = [self outputPathURL];
    if ([self validateFileName: savingFileName]) {
        [self trimAudio:^(BOOL result) {
            
            if(result)
            {
                
            }
            
            AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
            
            AddSoundTagsViewController *controller = [delegate.navi.storyboard instantiateViewControllerWithIdentifier:@"AddSoundTagsViewController"];
            
            //  controller.hidesBottomBarWhenPushed = YES;
            
            [GeneralUtility pushViewController: controller animated: YES];
        }];
    }
}

- (IBAction)next:(id)sender {
    
    [self performNextAction];
}

- (BOOL) validateFileName : (NSString *) filename {
    
    if (!filename) {
        return false;
    }
    if ([filename isEqualToString:@""]) {
        return false;
    }
    
    
    return true;
}


- (void)trimAudio:(void(^)(BOOL result)) completeBlock
{
    float vocalStartMarker = _startMarker;
    float vocalEndMarker = _endMarker;
    
    NSURL *audioFileInput = _srcFile;
    NSURL *audioFileOutput = savingFilePath;
    
    if (!audioFileInput || !audioFileOutput)
    {
        if(completeBlock)
        {
            completeBlock(NO);
            return;
        }
    }
    
    
    
    [[NSFileManager defaultManager] removeItemAtURL:audioFileOutput error:NULL];
    AVAsset *asset = [AVAsset assetWithURL:audioFileInput];
    
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:asset
                                                                            presetName:AVAssetExportPresetAppleM4A];
    
    if (exportSession == nil)
    {
        if(completeBlock)
        {
            completeBlock(NO);
            return;
        }
    }
    
    CMTime startTime = CMTimeMake((int)(floor(vocalStartMarker * 100)), 100);
    CMTime stopTime = CMTimeMake((int)(ceil(vocalEndMarker * 100)), 100);
    CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(startTime, stopTime);
    
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
                 unsigned long long fileSize = 0;
                 if (audioFileOutput.isFileURL) {
                     NSString *file = audioFileOutput.path;
                     NSError *err = nil;
                     if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
                         NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:file error:&err];
                         fileSize = [attributes fileSize];
                         //NSLog(@"saving soundfile path is %@", file);
                         
                         /*
                         DubSound* sound = [[DubSound alloc] init];
                         sound.offlineFileName = [savingFileName stringByAppendingString: @"m4a"];
                         sound.soundName = self.Filename.text;
                         sound.duration = _endMarker - _startMarker;
                         sound.tags = [NSMutableArray arrayWithObjects:@"AAA", @"BBB", @"CCC", nil];
                         sound.soundLanguage = @"ENGLISH";
                         
                         [sound setSoundDataFromLocalFilePath: file];
                         
                         [sound saveSoundToParseInBackgrountWithBlock:^(BOOL result, NSError *error) {
                             //NSLog(@"Saving sound in background result %d and error %@", result, error);
                         }];
                          */
                         
                         [DubSoundCreator setLanguage: @"ENGLISH"];
                         [DubSoundCreator setSoundName: self.Filename.text];
                         [DubSoundCreator setTags:[NSMutableArray arrayWithObjects:@"AAA", @"BBB", @"CCC", nil]];
                         [DubSoundCreator setOfflineFileName: [savingFileName stringByAppendingString: @"m4a"]];
                         [DubSoundCreator setDuration: _endMarker - _startMarker];
                         [DubSoundCreator setLocalDataFilePath: file];
                     }
                 }
               //  //NSLog(@"%@.m4a is saved successfully!", _Filename.text);
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Succcess!"
                                                                 message:[NSString stringWithFormat:@"%@.m4a is saved successfully!\nduration:%.2f~%.2fsec\nfilesize:%lluByte", _Filename.text, _startMarker, _endMarker, fileSize]
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                 //[alert show];
                 
                 
                 if(completeBlock)
                 {
                     completeBlock(YES);
                     return;
                 }
            
             }
             else if (AVAssetExportSessionStatusFailed == exportSession.status)
             {
                 [self hideHUD];
                 // It failed...
                 //NSLog(@"%@.m4a is failed!", _Filename.text);
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail!"
                                                                 message:[NSString stringWithFormat:@"%@.m4a is failed to save!", _Filename.text]
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                 [alert show];
                 if(completeBlock)
                 {
                     completeBlock(NO);
                     return;
                 }
             }
             
             if(completeBlock)
             {
                 completeBlock(NO);
                 return;
             }
         });
     }];
}

#pragma mark - Utility

-(NSURL*)outputPathURL {
    return [Common withFilePathURL:savingFileName extension:@"m4a"];
}

#pragma mark - AVAudioPlayerDelegate
/*
 Occurs when the audio player instance completes playback
 */
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.audioPlayer = nil;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
/*
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                             withString:string];
    [self updateNextButton];
    // Now you can use the value of textField.text for whatever you need to do.
    return NO;
}
*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    /*
    if([_nameField.text length]>0)
    {
        [self performSegueWithIdentifier:@"goSelectIcon" sender:nil];
        
    }
     */
    [self performNextAction];
    return NO;
}
@end
