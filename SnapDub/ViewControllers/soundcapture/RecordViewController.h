//
//  RecordViewController.h
//  SnapDub
//
//  Created by Infinidy_jiawei on 2015-05-26.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>
// Import EZAudio header
#import "EZAudio.h"

// Import AVFoundation to play the file (will save EZAudioFile and EZOutput for separate example)
#import <AVFoundation/AVFoundation.h>

// By default this will record a file to the application's documents directory (within the application's sandbox)
#define kAudioFilePath @"EZAudioTest"

@interface RecordViewController : UIViewController <EZMicrophoneDelegate>

@property (weak, nonatomic) IBOutlet UILabel *Description;
@property (weak, nonatomic) IBOutlet UILabel *Hint;
@property (weak, nonatomic) IBOutlet UILabel *WatchTime;
@property (weak, nonatomic) IBOutlet UIButton *Done;
@property (weak, nonatomic) IBOutlet UIButton *Start;
- (IBAction)Done:(id)sender;
- (IBAction)Start:(id)sender;
- (IBAction)back:(id)sender;

/**
 A flag indicating whether we are recording or not
 */
@property (nonatomic,assign) BOOL isRecording;

/**
 The microphone component
 */
@property (nonatomic, strong) EZMicrophone *microphone;

/**
 The recorder component
 */
@property (nonatomic, strong) EZRecorder *recorder;

@end
