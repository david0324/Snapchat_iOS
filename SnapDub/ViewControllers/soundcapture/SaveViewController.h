//
//  SaveViewController.h
//  SnapDub
//
//  Created by Infinidy_jiawei on 2015-05-26.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>
// Import AVFoundation to play the file (will save EZAudioFile and EZOutput for separate example)
#import <AVFoundation/AVFoundation.h>

@interface SaveViewController : UIViewController<AVAudioPlayerDelegate>
{
    NSString* savingFileName;
    NSURL* savingFilePath;
    NSArray* categoryArray;
}
- (IBAction)next:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *Filename;
- (IBAction)back:(id)sender;

@property (nonatomic) float startMarker;
@property (nonatomic) float endMarker;
@property (nonatomic, strong) NSURL *srcFile;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UILabel *warningMsg;


@end
