//
//  RecordViewController.m
//  SnapDub
//
//  Created by Infinidy_jiawei on 2015-05-26.
//  Copyright (c) 2015 wjs. All rights reserved.
//



#import "RecordViewController.h"
#import "Define.h"
#import "Common.h"
#import "RangeViewController.h"
#import "SDTutorialManager.h"

@interface RecordViewController ()

@property (nonatomic, strong) NSTimer *procTimer;
@property (nonatomic) float watchValue;
@end

@implementation RecordViewController
@synthesize microphone;
@synthesize recorder;


#pragma mark - Initialize View Controller Here
-(void)initializeViewController {
    // Create an instance of the microphone and tell it to use this view controller instance as the delegate
    self.microphone = [EZMicrophone microphoneWithDelegate:self];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 99)
    {
        [[SDTutorialManager ShareManager] setTutorialStepFinish: ANALYTICS_MANAGER_TUTORIAL_STEP_7_1_sound_permission_popup];
        
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                //NSLog(@"Permission granted");
            }
            else {
                //NSLog(@"Permission denied");
            }
            
            //[self initializeViewController];
            [self initializeControls];
            [self.microphone startFetchingAudio];
        }];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = NULL;
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];
    if( err ){
        //NSLog(@"There was an error creating the audio session");
    }
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:NULL];
    if( err ){
        //NSLog(@"There was an error sending the audio to the speakers");
    }
    
    
    // Do any additional setup after loading the view.
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    

    [self initializeViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = NULL;
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];
    if( err ){
        //NSLog(@"There was an error creating the audio session");
    }
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:NULL];
    if( err ){
        //NSLog(@"There was an error sending the audio to the speakers");
    }
    
    if(![[SDTutorialManager ShareManager] isTutorialStepDone: ANALYTICS_MANAGER_TUTORIAL_STEP_7_1_sound_permission_popup])
    {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Grant Access"
                                                    message:@"We will ask for permission to use the mic to record DubSounds. Please grant us the access permission :)"
                                                   delegate: self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    alert.tag = 99;
    [alert show];
    
    }
    else{
        [self initializeControls];
        [self.microphone startFetchingAudio];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.microphone stopFetchingAudio];
    //self.microphone = [EZMicrophone microphoneWithDelegate:nil];
    if (self.recorder) {
        [self.recorder closeAudioFile];
        self.recorder = nil;
    }
    
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
    
}

- (IBAction)Done:(id)sender {
    [self finishProc];
}

- (IBAction)Start:(id)sender {
    _watchValue = 10.0f;
    _procTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onProcess:) userInfo:nil repeats:YES];
    _Description.text = TEXT_TAP_DONE_RECORD;
    _Start.hidden = YES;
    _Done.hidden = NO;
    _Hint.hidden = YES;
    _WatchTime.hidden = NO;
    [self startProc];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onProcess : (NSTimer *) timer {
    _watchValue -= 0.1;
    if (_watchValue <= 0) {
        [self finishProc];
    }
    else {
        _WatchTime.text = [NSString stringWithFormat:@"%.1f sec", _watchValue];
    }
    
}

- (void) startProc {
    /*
     Log out where the file is being written to within the app's documents directory
     */
    //NSLog(@"File written to application sandbox's documents directory: %@",[self testFilePathURL]);
    
    if (!self.recorder) {
        //zhaozhaozhao
        self.recorder = [EZRecorder recorderWithDestinationURL:[self testFilePathURL]
                                                  sourceFormat:self.microphone.audioStreamBasicDescription
                                           destinationFileType:EZRecorderFileTypeM4A];//EZRecorderFileTypeM4A
    }
    
    self.isRecording = YES;
    
}

- (void)finishProc {
    [_procTimer invalidate];
    [self initializeControls];
    
    self.isRecording = NO;
    
    if (self.recorder) {
        [self.recorder closeAudioFile];
        self.recorder = nil;
    }
    
    
     RangeViewController *selRanger = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectRangeView"];
    [selRanger setSrcFile:[self testFilePathURL]];
    [self.navigationController pushViewController:selRanger animated:YES];
    // [self.navigationController performSegueWithIdentifier:@"pushSelRange3" sender:self];
}

- (void)initializeControls {
    _Done.hidden = YES;
    _WatchTime.hidden = YES;
    _Start.hidden = NO;
    _Hint.hidden = NO;
    _Description.text = TEXT_TAP_START_RECORD;
    
}

#pragma mark - Utility


-(NSURL*)testFilePathURL {
    /////lgilgilgi
    return [Common withFilePathURL:kAudioFilePath extension:@"m4a"];
}

#pragma mark - EZMicrophoneDelegate
#warning Thread Safety
// Note that any callback that provides streamed audio data (like streaming microphone input) happens on a separate audio thread that should not be blocked. When we feed audio data into any of the UI components we need to explicity create a GCD block on the main thread to properly get the UI to work.
-(void)microphone:(EZMicrophone *)microphone
 hasAudioReceived:(float **)buffer
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
    // Getting audio data as an array of float buffer arrays. What does that mean? Because the audio is coming in as a stereo signal the data is split into a left and right channel. So buffer[0] corresponds to the float* data for the left channel while buffer[1] corresponds to the float* data for the right channel.
    
}

-(void)microphone:(EZMicrophone *)microphone
    hasBufferList:(AudioBufferList *)bufferList
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
    
    // Getting audio data as a buffer list that can be directly fed into the EZRecorder. This is happening on the audio thread - any UI updating needs a GCD main queue block. This will keep appending data to the tail of the audio file.
    if( self.isRecording ){
        [self.recorder appendDataFromBufferList:bufferList
                                 withBufferSize:bufferSize];
    }
    
}

@end
