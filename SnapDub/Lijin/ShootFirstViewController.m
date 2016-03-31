//
//  ShootFirstViewController.m
//  SnapDub
//
//  Created by admin on 10/12/15.
//  Copyright © 2015 wjs. All rights reserved.
//


#import "ShootFirstViewController.h"
#import "ViewUtils.h"
#import <AVFoundation/AVFoundation.h>
#import "SCTouchDetector.h"
#import "SCAudioTools.h"

#import "SCVideoPlayerViewController.h"
#import "SCRecorderFocusView.h"
#import "SCRecorder.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SCRecordSessionManager.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define kVideoPreset AVCaptureSessionPresetHigh
const int videoDuration  = 10;

@interface ShootFirstViewController (){
    SCRecorder *_recorder;
    UIImage *_photo;
    GPUImageVideoCamera *videoCamera;
    AVAudioPlayer *_audioPlayer;
}
@property (nonatomic, assign) AVCaptureDevicePosition cameraType;
@property (nonatomic, strong) NSTimer  *progressTimer;
@property (nonatomic)         CGFloat        progress;
@end

@implementation ShootFirstViewController
@synthesize audioPlot,progressImageView,soundFilePath;
@synthesize filter_scroll;
@synthesize HUD;

#pragma mark - UIViewController

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#endif

#pragma mark - Left cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //create GPU camera
    self.cameraType = AVCaptureDevicePositionFront;
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:self.cameraType];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    videoCamera.horizontallyMirrorFrontFacingCamera = TRUE;

    [self previewCamera:0];
    [self savefiltermethod:0];
    isRecording = FALSE;

    // Do any additional setup after loading the view.
    [self initFlatWithIndicatorProgressBar];
    [self.view addSubview:self.progressBarFlatWithIndicator];
    [self.view addSubview:self.audioPlot];
    
    self.stopButton.hidden = YES;
    [self.view addSubview:filter_scroll];
    [self setupFilterScrollView];
    
    [self.recordBtn0 addTarget:self action:@selector(recording) forControlEvents:UIControlEventTouchDown];
    [self.recordBtn0 addTarget:self action:@selector(pausedRecording) forControlEvents:UIControlEventTouchUpInside];
    [self.recordBtn0 addTarget:self action:@selector(pausedRecording) forControlEvents:UIControlEventTouchUpOutside];
    
    [self.recordBtn1 addTarget:self action:@selector(recording) forControlEvents:UIControlEventTouchDown];
    [self.recordBtn1 addTarget:self action:@selector(pausedRecording) forControlEvents:UIControlEventTouchUpInside];
    [self.recordBtn1 addTarget:self action:@selector(pausedRecording) forControlEvents:UIControlEventTouchUpOutside];

    [self.recordBtn2 addTarget:self action:@selector(recording) forControlEvents:UIControlEventTouchDown];
    [self.recordBtn2 addTarget:self action:@selector(pausedRecording) forControlEvents:UIControlEventTouchUpInside];
    [self.recordBtn2 addTarget:self action:@selector(pausedRecording) forControlEvents:UIControlEventTouchUpOutside];

    [self.recordBtn3 addTarget:self action:@selector(recording) forControlEvents:UIControlEventTouchDown];
    [self.recordBtn3 addTarget:self action:@selector(pausedRecording) forControlEvents:UIControlEventTouchUpInside];
    [self.recordBtn3 addTarget:self action:@selector(pausedRecording) forControlEvents:UIControlEventTouchUpOutside];

    [self.recordBtn4 addTarget:self action:@selector(recording) forControlEvents:UIControlEventTouchDown];
    [self.recordBtn4 addTarget:self action:@selector(pausedRecording) forControlEvents:UIControlEventTouchUpInside];
    [self.recordBtn4 addTarget:self action:@selector(pausedRecording) forControlEvents:UIControlEventTouchUpOutside];

    [self.recordBtn5 addTarget:self action:@selector(recording) forControlEvents:UIControlEventTouchDown];
    [self.recordBtn5 addTarget:self action:@selector(pausedRecording) forControlEvents:UIControlEventTouchUpInside];
    [self.recordBtn5 addTarget:self action:@selector(pausedRecording) forControlEvents:UIControlEventTouchUpOutside];

    [self.recordBtn6 addTarget:self action:@selector(recording) forControlEvents:UIControlEventTouchDown];
    [self.recordBtn6 addTarget:self action:@selector(pausedRecording) forControlEvents:UIControlEventTouchUpInside];
    [self.recordBtn6 addTarget:self action:@selector(pausedRecording) forControlEvents:UIControlEventTouchUpOutside];

    gpuImageView_Array = [[NSMutableArray alloc] init];
    [gpuImageView_Array addObject:self.m_gpuImageView0];
    [gpuImageView_Array addObject:self.m_gpuImageView1];
    [gpuImageView_Array addObject:self.m_gpuImageView2];
    [gpuImageView_Array addObject:self.m_gpuImageView3];
    [gpuImageView_Array addObject:self.m_gpuImageView4];
    [gpuImageView_Array addObject:self.m_gpuImageView5];
    [gpuImageView_Array addObject:self.m_gpuImageView6];
    
    //filter2
    owleyefilter = [[GPUImageFilterGroup alloc] init];
    GPUImageBulgeDistortionFilter *m_GPUImageBulgeDistortionFilter = [[GPUImageBulgeDistortionFilter alloc] init];
    [owleyefilter addFilter:m_GPUImageBulgeDistortionFilter];
    GPUImageBulgeDistortionFilter1 *m_GPUImageBulgeDistortionFilter1 = [[GPUImageBulgeDistortionFilter1 alloc] init];
    [owleyefilter addFilter:m_GPUImageBulgeDistortionFilter1];
    [m_GPUImageBulgeDistortionFilter addTarget:m_GPUImageBulgeDistortionFilter1];
    [owleyefilter setInitialFilters:[NSArray arrayWithObject:m_GPUImageBulgeDistortionFilter]];
    [owleyefilter setTerminalFilter:m_GPUImageBulgeDistortionFilter1];
    
    //filter3
    hulkfilter = [[GPUImageFilterGroup alloc] init];
    GPUImagePinchDistortionFilter *m_pinch2 = [[GPUImagePinchDistortionFilter alloc] init];
    m_pinch2.center = CGPointMake(0.5, 0);
    m_pinch2.radius = 0.5;
    m_pinch2.scale = -0.6;
    
    [hulkfilter addFilter:m_pinch2];
    GPUImagePinchDistortionFilter *m_pinch4 = [[GPUImagePinchDistortionFilter alloc] init];
    
    m_pinch4.center = CGPointMake(0.5, 1);
    m_pinch4.radius = 0.5;
    m_pinch4.scale = -0.8;
    [hulkfilter addFilter:m_pinch4];
    
    GPUImageHueFilter *m_pinch5 = [[GPUImageHueFilter alloc] init];
    [hulkfilter addFilter:m_pinch5];
    [m_pinch2 addTarget:m_pinch4];
    [m_pinch4 addTarget:m_pinch5];
    [hulkfilter setInitialFilters:[NSArray arrayWithObject:m_pinch2]];
    [hulkfilter setTerminalFilter:m_pinch5];

    // Construct URL to sound file
    NSString* filename = @"2.mp3";
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    // Create audio player object and initialize with URL to sound
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
}

- (void)viewDidUnload
{
    self.progressBarFlatWithIndicator = nil;
    self.progress = 0;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController  setNavigationBarHidden:YES animated:YES];
    [self initAudioWaveView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.progress = 0;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)initFlatWithIndicatorProgressBar
{
    _progressBarFlatWithIndicator.type                     = YLProgressBarTypeFlat;
    _progressBarFlatWithIndicator.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayModeProgress;
    _progressBarFlatWithIndicator.behavior                 = YLProgressBarBehaviorIndeterminate;
    _progressBarFlatWithIndicator.stripesOrientation       = YLProgressBarStripesOrientationVertical;
}

- (void)previewCamera:(int) i{
    
    BOOL isplaying = [[SoundManager sharedManager].currentMusic isPlaying];
    
    if(isplaying){
        return;
    }else{
        for (int k = 0;  k < [gpuImageView_Array count]; k++) {
            GPUImageView *imageView = [gpuImageView_Array objectAtIndex:k];
            if (i == k) {
                [imageView setHidden:NO];
            }else{
                [imageView setHidden:YES];
            }
        }
        if (i == 0) {
            if (normalfilter) {
                [normalfilter removeTarget:self.m_gpuImageView0];
                [videoCamera removeTarget:normalfilter];
            }

            //filter1
            normalfilter = [[GPUImageSaturationFilter alloc] init];

            [videoCamera addTarget:normalfilter];
            [normalfilter addTarget:self.m_gpuImageView0];
            self.m_gpuImageView0.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        }
        if (i == 1) {
            if (owleyefilter) {
                [owleyefilter removeTarget:self.m_gpuImageView1];
                [videoCamera removeTarget:owleyefilter];
            }
            
            [videoCamera addTarget:owleyefilter];
            [owleyefilter addTarget:self.m_gpuImageView1];
            self.m_gpuImageView1.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        }
        if (i == 2) {
            if (hulkfilter) {
                [hulkfilter removeTarget:self.m_gpuImageView2];
                [videoCamera removeTarget:hulkfilter];
            }
            
            [videoCamera addTarget:hulkfilter];
            
            [hulkfilter addTarget:self.m_gpuImageView2];
            self.m_gpuImageView2.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        }
        if (i == 3) {
            if (squareheadfilter) {
                [squareheadfilter removeTarget:self.m_gpuImageView3];
                [videoCamera removeTarget:squareheadfilter];
            }
            
            squareheadfilter = [[GPUImageStretchDistortionFilter alloc] init];
            [videoCamera addTarget:squareheadfilter];
            [squareheadfilter addTarget:self.m_gpuImageView3];
            self.m_gpuImageView3.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        }
        if (i == 4) {
            if (squarechinfilter) {
                [squarechinfilter removeTarget:self.m_gpuImageView4];
                [videoCamera removeTarget:squarechinfilter];
            }
            
            squarechinfilter = [[GPUImageStretchDistortionFilter1 alloc] init];
            [videoCamera addTarget:squarechinfilter];
            [squarechinfilter addTarget:self.m_gpuImageView4];
            self.m_gpuImageView4.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        }
        if (i == 5) {
            if (bigheadfilter) {
                [bigheadfilter removeTarget:self.m_gpuImageView5];
                [videoCamera removeTarget:bigheadfilter];
            }
            
            bigheadfilter = [[GPUImageBulgeDistortionFilter2 alloc] init];
            [videoCamera addTarget:bigheadfilter];
            [bigheadfilter addTarget:self.m_gpuImageView5];
            self.m_gpuImageView5.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        }
        if (i == 6) {
            if (gremlinfilter) {
                [gremlinfilter removeTarget:self.m_gpuImageView6];
                [videoCamera removeTarget:gremlinfilter];
            }
            
            gremlinfilter = [[GPUImageFilterGroup alloc] init];
            GPUImageSwirlFilter *m_GPUImageSwirlFilter = [[GPUImageSwirlFilter alloc] init];
            [gremlinfilter addFilter:m_GPUImageSwirlFilter];
            GPUImageSwirlFilter1 *m_GPUImageSwirlFilter1 = [[GPUImageSwirlFilter1 alloc] init];
            [gremlinfilter addFilter:m_GPUImageSwirlFilter1];
            [m_GPUImageSwirlFilter addTarget:m_GPUImageSwirlFilter1];
            [gremlinfilter setInitialFilters:[NSArray arrayWithObject:m_GPUImageSwirlFilter]];
            [gremlinfilter setTerminalFilter:m_GPUImageSwirlFilter1];
            [videoCamera addTarget:gremlinfilter];
            [gremlinfilter addTarget:self.m_gpuImageView6];
            self.m_gpuImageView6.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        }
        [videoCamera startCameraCapture];
    }
}

#pragma mark - Handle
-(IBAction)onCloseButtonClicked:(id)sender
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: nil
                                                                        message: nil
                                                                 preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle: @"delete this musical"
                                                        style: UIAlertActionStyleDestructive
                                                      handler: ^(UIAlertAction *action) {
                                                          [self onDeleteButtonClicked];
                                                      }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle: @"re-shoot"
                                                       style: UIAlertActionStyleDefault
                                                     handler: ^(UIAlertAction *action) {
                                                         [self onReshootButtonClicked];
                                                     }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 [controller dismissViewControllerAnimated:YES completion:nil];
                             }];

    [controller addAction: yesAction];
    [controller addAction: noAction];
    [controller addAction: cancel];
    [self presentViewController: controller animated: YES completion: nil];
}

-(IBAction)onDetermineButtonClicked:(id)sender
{
    
}
- (void) onReshootButtonClicked {
    [self previewCamera:0];
}

- (void) onDeleteButtonClicked {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)initAudioWaveView {
    self.audioPlot.color           = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    // Plot type
    self.audioPlot.plotType        = EZPlotTypeBuffer;
    // Fill
    self.audioPlot.shouldFill      = YES;
    // Mirror
    self.audioPlot.shouldMirror    = YES;
    
    [progressImageView setFrame:CGRectMake(0, 0, 1.0f, audioPlot.frame.size.height)];

    NSString* filename = @"2.mp3";
    NSURL* url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:filename ofType:nil]];
    [self openFileWithFilePathURL:url];
}

-(void)openFileWithFilePathURL:(NSURL*)filePathURL {
    self.audioFile          = [EZAudioFile audioFileWithURL:filePathURL];
    self.eof                = NO;
    // Plot the whole waveform
    self.audioPlot.plotType        = EZPlotTypeBuffer;
    self.audioPlot.shouldFill      = YES;
    self.audioPlot.shouldMirror    = YES;
    [self.audioFile getWaveformDataWithCompletionBlock:^(float *waveformData, UInt32 length) {
        [self.audioPlot updateBuffer:waveformData withBufferSize:length];
    }];
}

- (void)startPlayWav {
    [[SoundManager sharedManager] playMusic:@"2.mp3" looping:NO];
//    [_audioPlayer play];
}

- (IBAction)onDeleteSegmentButttonClicked:(id)sender{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Selete Last Segment"
                                                                        message: @"Are you sure to delete the last segment you have recorded?"
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle: @"no"
                                                        style: UIAlertActionStyleDefault
                                                      handler: ^(UIAlertAction *action) {
                                                          [self CancelDeleteSegment];
                                                      }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle: @"delete"
                                                       style: UIAlertActionStyleDefault
                                                     handler: ^(UIAlertAction *action) {
                                                         [self DeleteLastSegment];
                                                         
                                                     }];
    [controller addAction: yesAction];
    [controller addAction: noAction];
    [self presentViewController: controller animated: YES completion: nil];
}

- (void) DeleteLastSegment{

}

- (void) CancelDeleteSegment{
    
}

- (IBAction)onCameraChangeAction:(id)sender {
    [videoCamera rotateCamera];
}

- (void)recording {
    NSLog(@"recording........................................................");
    
    count_Camera ++;

    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    
    NSString *pathToMovie = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"movie%d.m4v",count_Camera]];
    unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
    movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(720, 1280)];
    movieWriter.encodingLiveVideo = YES;
    videoCamera.audioEncodingTarget = movieWriter;

    int filtertype = [self getfiltermethod];
    if (filtertype == 0) {
        if (normalfilter) {
            [normalfilter removeTarget:self.m_gpuImageView0];
            [videoCamera removeTarget:normalfilter];
        }

        normalfilter = [[GPUImageSaturationFilter alloc] init];
        [videoCamera addTarget:normalfilter];
        [normalfilter addTarget:self.m_gpuImageView0];
        self.m_gpuImageView0.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        [normalfilter addTarget:movieWriter];
    }else if (filtertype == 1){
        if (owleyefilter) {
            [owleyefilter removeTarget:self.m_gpuImageView1];
            [videoCamera removeTarget:owleyefilter];
        }
        owleyefilter = [[GPUImageFilterGroup alloc] init];
        GPUImageBulgeDistortionFilter *m_GPUImageBulgeDistortionFilter = [[GPUImageBulgeDistortionFilter alloc] init];
        [owleyefilter addFilter:m_GPUImageBulgeDistortionFilter];
        GPUImageBulgeDistortionFilter1 *m_GPUImageBulgeDistortionFilter1 = [[GPUImageBulgeDistortionFilter1 alloc] init];
        [owleyefilter addFilter:m_GPUImageBulgeDistortionFilter1];
        [m_GPUImageBulgeDistortionFilter addTarget:m_GPUImageBulgeDistortionFilter1];
        [owleyefilter setInitialFilters:[NSArray arrayWithObject:m_GPUImageBulgeDistortionFilter]];
        [owleyefilter setTerminalFilter:m_GPUImageBulgeDistortionFilter1];
        GPUImageView *filterView = self.m_gpuImageView1;
        [owleyefilter addTarget:filterView];
        [owleyefilter addTarget:movieWriter];
        [videoCamera addTarget:owleyefilter];
        
    }else if (filtertype == 2){
        if (hulkfilter) {
            [hulkfilter removeTarget:self.m_gpuImageView2];
            [videoCamera removeTarget:hulkfilter];
        }

        hulkfilter = [[GPUImageFilterGroup alloc] init];
        GPUImagePinchDistortionFilter *m_pinch2 = [[GPUImagePinchDistortionFilter alloc] init];
        m_pinch2.center = CGPointMake(0.5, 0);
        m_pinch2.radius = 0.5;
        m_pinch2.scale = -0.6;
        
        [hulkfilter addFilter:m_pinch2];
        GPUImagePinchDistortionFilter *m_pinch4 = [[GPUImagePinchDistortionFilter alloc] init];
        
        m_pinch4.center = CGPointMake(0.5, 1);
        m_pinch4.radius = 0.5;
        m_pinch4.scale = -0.8;
        [hulkfilter addFilter:m_pinch4];
        
        GPUImageHueFilter *m_pinch5 = [[GPUImageHueFilter alloc] init];
        [hulkfilter addFilter:m_pinch5];
        [m_pinch2 addTarget:m_pinch4];
        [m_pinch4 addTarget:m_pinch5];
        [hulkfilter setInitialFilters:[NSArray arrayWithObject:m_pinch2]];
        [hulkfilter setTerminalFilter:m_pinch5];
        [videoCamera addTarget:hulkfilter];
        
        [hulkfilter addTarget:self.m_gpuImageView2];
        self.m_gpuImageView2.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        [hulkfilter addTarget:movieWriter];
        
    }else if (filtertype == 3){
        if (squareheadfilter) {
            [squareheadfilter removeTarget:self.m_gpuImageView3];
            [videoCamera removeTarget:squareheadfilter];
        }
        squareheadfilter = [[GPUImageStretchDistortionFilter alloc] init];
        [videoCamera addTarget:squareheadfilter];
        [squareheadfilter addTarget:self.m_gpuImageView3];
        self.m_gpuImageView3.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        [squareheadfilter addTarget:movieWriter];

    }else if (filtertype == 4){
        if (squarechinfilter) {
            [squarechinfilter removeTarget:self.m_gpuImageView4];
            [videoCamera removeTarget:squarechinfilter];
        }
        squarechinfilter = [[GPUImageStretchDistortionFilter1 alloc] init];
        [videoCamera addTarget:squarechinfilter];
        [squarechinfilter addTarget:self.m_gpuImageView4];
        self.m_gpuImageView4.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        [squarechinfilter addTarget:movieWriter];

    }else if (filtertype == 5){
        if (bigheadfilter) {
            [bigheadfilter removeTarget:self.m_gpuImageView5];
            [videoCamera removeTarget:bigheadfilter];
        }
        bigheadfilter = [[GPUImageBulgeDistortionFilter2 alloc] init];
        [videoCamera addTarget:bigheadfilter];
        [bigheadfilter addTarget:self.m_gpuImageView5];
        self.m_gpuImageView5.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        [bigheadfilter addTarget:movieWriter];

    }else if (filtertype == 6){
        if (gremlinfilter) {
            [gremlinfilter removeTarget:self.m_gpuImageView6];
            [videoCamera removeTarget:gremlinfilter];
        }
        gremlinfilter = [[GPUImageFilterGroup alloc] init];
        GPUImageSwirlFilter *m_GPUImageSwirlFilter = [[GPUImageSwirlFilter alloc] init];
        [gremlinfilter addFilter:m_GPUImageSwirlFilter];
        GPUImageSwirlFilter1 *m_GPUImageSwirlFilter1 = [[GPUImageSwirlFilter1 alloc] init];
        [gremlinfilter addFilter:m_GPUImageSwirlFilter1];
        [m_GPUImageSwirlFilter addTarget:m_GPUImageSwirlFilter1];
        [gremlinfilter setInitialFilters:[NSArray arrayWithObject:m_GPUImageSwirlFilter]];
        [gremlinfilter setTerminalFilter:m_GPUImageSwirlFilter1];
        GPUImageView *filterView = self.m_gpuImageView6;
        [gremlinfilter addTarget:filterView];
        [gremlinfilter addTarget:movieWriter];
        [videoCamera addTarget:gremlinfilter];
    }

    if (movieWriter.isPaused) {
        movieWriter.paused = NO;
    } else {
        [movieWriter startRecording];
    }
}

- (void)pausedRecording {
    [_audioPlayer pause];
    [self.progressTimer invalidate];
    movieWriter.paused = YES;
    
    [videoCamera removeTarget:movieWriter];
    [normalfilter removeTarget:movieWriter];
    [owleyefilter removeTarget:movieWriter];
    [hulkfilter removeTarget:movieWriter];
    [squareheadfilter removeTarget:movieWriter];
    [squarechinfilter removeTarget:movieWriter];
    [bigheadfilter removeTarget:movieWriter];
    [gremlinfilter removeTarget:movieWriter];
    
    videoCamera.audioEncodingTarget = nil;
    
    [movieWriter finishRecording];
}

- (void)updateProgress {
    self.progress += 0.05 / videoDuration;

    NSLog(@"updateprogress...............................................");
    [_progressBarFlatWithIndicator setProgress:self.progress animated:YES];

    if (self.progress > 0.2) {
        self.stopButton.hidden = NO;
        if (self.progress >= 1)
        {
            [self setSectionCount:count_Camera];
            [self.progressTimer invalidate];
            
            [[SoundManager sharedManager].currentMusic stop];
            [SoundManager sharedManager].currentMusic = nil;
            
            int tempSectionCount = [self getSectionCount];
            VideoAsset_Array = [[NSMutableArray alloc] init];
            
            for (int i = 1; i < tempSectionCount + 1; i++) {
                NSMutableArray *videoNameArray = [[NSMutableArray alloc] init];
                [videoNameArray addObject:[NSString stringWithFormat:@"movie%d.m4v",i]];

                NSURL *videoTempUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"movie%d.m4v",i]]];
                AVAsset *tempAsset = [AVAsset assetWithURL:videoTempUrl];
                [VideoAsset_Array addObject:tempAsset];
            }
            [self MergeAndSave];
        }
    }
}

- (int) getfiltermethod {
    return m_filterMethod;
}

- (void) setSectionCount: (int) count  {
    count_Section = count;
}

- (int) getSectionCount {
    return count_Section;
}

- (void)setupFilterScrollView {
    if ([[SoundManager sharedManager].currentMusic isPlaying]) {
        return;
    }else{
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSArray *filternames = [NSArray arrayWithObjects:@"Normal",@"OwlEyes", @"TheHulk", @"SquareHead", @"SquareChin",@"BigHead", @"Gremlin",nil];
        NSArray *selectedFilternames = [NSArray arrayWithObjects:@"NormalSelected",@"OwlEyesSelected", @"TheHulkSelected", @"SquareHeadSelected", @"SquareChinSelected",@"BigHeadSelected", @"GremlinSelected",nil];
        for (int i = 0; i < [filternames count]; i++)
        {
            //Item working with blocks
            ACPItem *item = [[ACPItem alloc] initACPItem:[UIImage imageNamed:[filternames objectAtIndex:i]]
                                               iconImage:nil
                                                   label:nil
                                               andAction: ^(ACPItem *item) {
                                                    [self savefiltermethod:i];
                                                    [self previewCamera:i];
                                               }];
            //Set highlighted behaviour
            [item setHighlightedBackground:[UIImage imageNamed:[selectedFilternames objectAtIndex:i]] iconHighlighted:nil textColorHighlighted:nil];
            [array addObject:item];
        }
        self.scrollView = [[ACPScrollMenu alloc] initACPScrollMenuWithFrame:CGRectMake(0, filter_scroll.frame.origin.y, filter_scroll.frame.size.width, 60)
                           
                                                        withBackgroundColor:[UIColor clearColor]
                                                                  menuItems:array];
        //We choose an animation when the user touch the item (you can create your own animation)
        [self.scrollView setAnimationType:ACPZoomOut];
        self.scrollView.delegate = self;
        [self.view addSubview:self.scrollView];
    }
}

- (void)savefiltermethod:(int) i{
    m_filterMethod = i;
}

- (void)MergeAndSave
{
    AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
    
    NSMutableArray *arrayInstruction = [[NSMutableArray alloc] init];
    
    AVMutableVideoCompositionInstruction * MainInstruction =
    [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    AVMutableCompositionTrack *audioTrack;
    
    audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                             preferredTrackID:kCMPersistentTrackID_Invalid];
    CMTime duration = kCMTimeZero;
    for(int i = 0 ; i < [self getSectionCount] ; i++)
    {
        AVAsset *currentAsset = [self currentAsset:i]; // i take the for loop for geting the asset
        /* Current Asset is the asset of the video From the Url Using AVAsset */
        if ([[currentAsset tracksWithMediaType:AVMediaTypeVideo] count] > 0) {
            AVMutableCompositionTrack *currentTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
            
            [currentTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, currentAsset.duration) ofTrack:[[currentAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:duration error:nil];
            
            if ([[currentAsset tracksWithMediaType:AVMediaTypeAudio] count] > 0) {
                [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, currentAsset.duration) ofTrack:[[currentAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:duration error:nil];
            }
            
            AVMutableVideoCompositionLayerInstruction *currentAssetLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:currentTrack];
            
            AVAssetTrack *currentAssetTrack = [[currentAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
            UIImageOrientation currentAssetOrientation  = UIImageOrientationUp;
            BOOL  isCurrentAssetPortrait  = NO;
            CGAffineTransform currentTransform = currentAssetTrack.preferredTransform;
            
            if(currentTransform.a == 0 && currentTransform.b == 1.0 && currentTransform.c == -1.0 && currentTransform.d == 0)  {currentAssetOrientation= UIImageOrientationRight; isCurrentAssetPortrait = YES;}
            if(currentTransform.a == 0 && currentTransform.b == -1.0 && currentTransform.c == 1.0 && currentTransform.d == 0)  {currentAssetOrientation =  UIImageOrientationLeft; isCurrentAssetPortrait = YES;}
            if(currentTransform.a == 1.0 && currentTransform.b == 0 && currentTransform.c == 0 && currentTransform.d == 1.0)   {currentAssetOrientation =  UIImageOrientationUp;}
            if(currentTransform.a == -1.0 && currentTransform.b == 0 && currentTransform.c == 0 && currentTransform.d == -1.0) {currentAssetOrientation = UIImageOrientationDown;}
            
            CGFloat FirstAssetScaleToFitRatio = 640.0/640.0;
            if(isCurrentAssetPortrait){
                FirstAssetScaleToFitRatio = 640.0/640.0;
                CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
                [currentAssetLayerInstruction setTransform:CGAffineTransformConcat(currentAssetTrack.preferredTransform, FirstAssetScaleFactor) atTime:duration];
            }else{
                CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
                [currentAssetLayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(currentAssetTrack.preferredTransform, FirstAssetScaleFactor),CGAffineTransformMakeTranslation(0, 0)) atTime:duration];
            }
            duration=CMTimeAdd(duration, currentAsset.duration);
            
            [currentAssetLayerInstruction setOpacity:0.0 atTime:duration];
            [arrayInstruction addObject:currentAssetLayerInstruction];
            
            videoLayer  = [CALayer layer];
            parentLayer.frame = CGRectMake(0, 0, 720,1280);
            videoLayer.frame = CGRectMake(0, 0, 720, 1280);
            [parentLayer addSublayer:videoLayer];
        }
    }
    
    MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, duration);
    MainInstruction.layerInstructions = arrayInstruction;
    AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    MainCompositionInst.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
    MainCompositionInst.frameDuration = CMTimeMake(1, 30);
    MainCompositionInst.renderSize = CGSizeMake(720.0, 1280.0);
    
    NSString *myPathDocs =  [[self applicationCacheDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo%-dtemp.mp4",arc4random() % 10000]];
    
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.delegate = self;
    [HUD setLabelFont:[UIFont systemFontOfSize:12]];
    [HUD setLabelText:@"Processing..."];

    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.videoComposition = MainCompositionInst;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^
     {
         switch (exporter.status)
         {
             case AVAssetExportSessionStatusCompleted:
             {
                 NSURL *outputURL = exporter.outputURL;

                 
                 NSData *urlData = [NSData dataWithContentsOfURL:outputURL];
                 if ( urlData )
                 {
                     NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"final.m4v"];
                     
                     //saving is done on main thread
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [urlData writeToFile:filePath atomically:YES];
                         [HUD hide:YES];
                         [self performSegueWithIdentifier:@"Video" sender:nil];
                     });
                 }
             }
                 break;
             case AVAssetExportSessionStatusFailed:
                 break;
             case AVAssetExportSessionStatusCancelled:
                 break;
             case AVAssetExportSessionStatusExporting:
                 break;
             case AVAssetExportSessionStatusWaiting:
                 break;
             default:
                 break;
         }
     }];
}

-(AVAsset *)currentAsset:(int)num
{
    return [VideoAsset_Array objectAtIndex:num];
}

-(NSString *)applicationCacheDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end