
//
//  DMVideoRecordingViewController.m
//  Dubsmash
//
//  Created by Altair on 4/27/15.
//  Copyright (c) 2015 Altair. All rights reserved.
//

#import "DMVideoRecordingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SoundManager.h"
#import "MBProgressHUD.h"
#import "DMUtils.h"
#import "AppDelegate.h"
#import "ILSideScrollView.h"
#import "GPUImageBulgeDistortionFilter.h"
#import "GPUImageBulgeDistortionFilter1.h"
#import "GPUImageBulgeDistortionFilter2.h"
#import "GPUImageStretchDistortionFilter1.h"
#import "GPUImagePinchDistortionFilter1.h"
#import "GPUImageSwirlFilter1.h"
#import "GPUImage.h"
#import "DMVideoPreviewViewController.h"
#import "SDTutorialManager.h"
#import "GeneralUtility.h"
///////////////////////////////
//zhaozhao

#define cameraoption

///////////////////////////////
@interface DMVideoRecordingViewController ()
{
    AVAssetWriterInput *_wVideoInput;
    AVAssetWriterInput *_wAudioInput;
    
    GPUImageVideoCamera *videoCamera;
    
    CMTime lastSampleTime;
    BOOL bEncode;
    NSTimer *playingTimer;
    
    AudioBufferList *readBuffer;
    
}

//@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageView *captureVideoLayer;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, assign) AVCaptureDevicePosition cameraType;
@property (nonatomic, retain) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic, retain) AVCaptureAudioDataOutput *audioOutput;
@property (nonatomic, retain) AVAssetWriter *writer;
@property (nonatomic, retain) AVAssetWriter *writerCodec;

@end

@implementation DMVideoRecordingViewController
@synthesize captureVideoLayer, audioPlot, session, cameraType, recordBtn, videoOutput, audioOutput, cameraBtn, audioFile,eof, progressImageView, recordTitleLabel, soundFilePath;
@synthesize faceDetector, m_gpuImageView;
@synthesize m_gpuImageView1;
@synthesize m_gpuImageView2;
@synthesize m_gpuImageView3;
@synthesize m_gpuImageView4;
@synthesize m_gpuImageView5;
@synthesize m_gpuImageView6;

static bool viewLoad = NO;
static bool viewAppear = NO;

-(void) initialCameraAndView
{
    [self createGpuCamera];
    [self setupFilterScrollView];
    
    [self previewCamera:1];
    [self savefiltermethod:1];
    
    [videoCamera resumeCameraCapture];
    [videoCamera startCameraCapture];
    viewLoad = YES;
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(status == AVAuthorizationStatusAuthorized) {
        [[SDTutorialManager ShareManager] setTutorialStepFinish: ANALYTICS_MANAGER_TUTORIAL_STEP_1_1_CameraAccess_given];
    }else if(status == AVAuthorizationStatusDenied)
    {
        [[SDTutorialManager ShareManager] setTutorialStepFinish: ANALYTICS_MANAGER_TUTORIAL_STEP_1_1_CameraAccess_denied];
    }
    
    if(! [[SDTutorialManager ShareManager] isTutorialStepDone:ANALYTICS_MANAGER_TUTORIAL_STEP_2_Recording_filer_selected]  )
        [self performSelector:@selector(showFilterTutorial) withObject:nil afterDelay: 0.5];
    
    if( ![[SDTutorialManager ShareManager] isTutorialStepDone: ANALYTICS_MANAGER_TUTORIAL_STEP_4_Recording_finished] ){
        recordBtn.hidden = YES;
        recordTitleLabel.hidden = YES;
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 99)
    {
        [[SDTutorialManager ShareManager] setTutorialStepFinish: ANALYTICS_MANAGER_TUTORIAL_STEP_1_CameraAccess_info_ok];
        
        [self initialCameraAndView];
    }
}

-(void) grantCameraAccess
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status == AVAuthorizationStatusAuthorized) {
        [self initialCameraAndView];
    } else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Grant access"
                                                        message:@"We will ask for permission to record a video using your camera. Please be sure to grant access :)"
                                                       delegate: self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        alert.tag = 99;
        [alert show];
    }
}

-(void) showStartRecordingTutorial
{
    [[SDTutorialManager ShareManager] setTutorialStepFinish: ANALYTICS_MANAGER_TUTORIAL_STEP_2_Recording_filer_selected];
    
    theFilterItem = nil;
    recordTitleLabel.hidden = NO;
    recordBtn.hidden = NO;
    [SDTutorialManager showTutorialBarMessageWithTitle: @"Start Recording" message:@"Click Start :)" isOnTop:YES];
    
    [self flashStartButton];
}

-(void) showFilterTutorial
{
    [SDTutorialManager showTutorialBarMessageWithTitle: @"Funny Filter" message:@"Select a Funny Filter ;)" isOnTop:YES];
    [self flashFilterButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
}

- (void)createGpuCamera {
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:self.cameraType];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    videoCamera.horizontallyMirrorFrontFacingCamera = TRUE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.m_gpuImageView.backgroundColor  = [UIColor clearColor];
    self.m_gpuImageView1.backgroundColor = [UIColor clearColor];
    self.m_gpuImageView2.backgroundColor = [UIColor clearColor];
    self.m_gpuImageView3.backgroundColor = [UIColor clearColor];
    self.m_gpuImageView4.backgroundColor = [UIColor clearColor];
    self.m_gpuImageView5.backgroundColor = [UIColor clearColor];
    self.m_gpuImageView6.backgroundColor = [UIColor clearColor];

    self.navigationController.navigationBarHidden = YES;
    self.cameraType = AVCaptureDevicePositionFront;
    
    [self initAudioWaveView];
    
    [self grantCameraAccess];
    
    if( [[SDTutorialManager ShareManager] isTutorialStepDone: ANALYTICS_MANAGER_TUTORIAL_STEP_4_Recording_finished] )
    {
        _backButton.hidden = YES;
    }else
    {
        _backButton.hidden = NO;
    }
}

-(void)viewDidLayoutSubviews{
    if (viewAppear) {
        if (!viewLoad) {
            [self grantCameraAccess];
        }
    }
}

//change made by JWL move createGPUCamera methods from viewWillAppear to viewDidAppear
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if([[SDTutorialManager ShareManager] isTutorialStepDone: ANALYTICS_MANAGER_TUTORIAL_STEP_4_Recording_finished])
    {
        recordBtn.hidden = NO;
        _backButton.hidden = NO;
    }else
    {
        recordBtn.hidden = YES;
        _backButton.hidden  = YES;
    }
    viewAppear = YES;
    
    [AdManager sharedAppManager].disabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SDTutorialManager hideAllTutorialMessages];
    [videoCamera pauseCameraCapture];
    [videoCamera stopCameraCapture];
    runSynchronouslyOnVideoProcessingQueue(^{
        glFinish();
    });
    
    [self.scrollView removeFromSuperview];
    self.scrollView = nil;
    viewAppear = NO;
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

    [self openFileWithFilePathURL:  [NSURL URLWithString: self.soundFilePath]  ];
    NSLog(@"sounfilepath = %@",soundFilePath);
}

#pragma mark - Select Filter Method

- (void)setupFilterScrollView {
    
    if ([[SoundManager sharedManager].currentMusic isPlaying]) {
        return;
    }else{
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSArray *filternames = [NSArray arrayWithObjects:@"Normal",@"OwlEyes", @"TheHulk", @"SquareHead", @"SquareChin",@"BigHead", @"Gremlin",nil];
        NSArray *selectedFilternames = [NSArray arrayWithObjects:@"NormalSelected",@"OwlEyesSelected", @"TheHulkSelected", @"SquareHeadSelected", @"SquareChinSelected",@"BigHeadSelected", @"GremlinSelected",nil];
        for (int i = 1; i < [filternames count]+1; i++)
        {
            //Item working with blocks
            ACPItem *item = [[ACPItem alloc] initACPItem:[UIImage imageNamed:[filternames objectAtIndex:i-1]]
                                               iconImage:nil
                                                   label:nil
                                               andAction: ^(ACPItem *item) {
                                                   
                                                   [self savefiltermethod:i];
                                                   [self previewCamera:i];
                                                   
                                               }];
            //Set highlighted behaviour
            [item setHighlightedBackground:[UIImage imageNamed:[selectedFilternames objectAtIndex:i-1]] iconHighlighted:nil textColorHighlighted:nil];
            if(i==2)
            {
                theFilterItem = item;
            }
            [array addObject:item];
        }
        self.scrollView = [[ACPScrollMenu alloc] initACPScrollMenuWithFrame:CGRectMake(0, _scrollPositon.frame.origin.y, _scrollPositon.frame.size.width, 60)
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

- (int) getfiltermethod {
    return m_filterMethod;
}

-(void) flashStartButton
{
    [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.60 animations:^{
            recordBtn.transform = CGAffineTransformMakeScale(1.4, 1.2);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.60 relativeDuration:0.40 animations:^{
            recordBtn.transform = CGAffineTransformIdentity;
        }];
    } completion:^(BOOL finished) {
        
        if(!shouldStopFlashingStartButton)
            [self performSelector:@selector(flashStartButton) withObject: nil afterDelay:0.6];
    }];
    
}

-(void) flashFilterButton
{
    if(!theFilterItem)
        return;
    
    [UIView animateKeyframesWithDuration:0.4 delay:0 options: UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.60 animations:^{
            theFilterItem.transform = CGAffineTransformMakeScale(1.3, 3.6);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.60 relativeDuration:0.40 animations:^{
            theFilterItem.transform = CGAffineTransformIdentity;
        }];
    } completion:^(BOOL finished) {
        
        [self performSelector:@selector(flashFilterButton) withObject: nil afterDelay:0.1];
        
    }];
}

- (void)previewCamera:(int) i{
    BOOL isplaying = [[SoundManager sharedManager].currentMusic isPlaying];
    
    if(isplaying){
        return;
    }else{
        if (i!=1) {
            [SDTutorialManager hideAllTutorialMessages];
            
            theFilterItem = nil;
            if(![[SDTutorialManager ShareManager] isTutorialStepDone: ANALYTICS_MANAGER_TUTORIAL_STEP_4_Recording_finished])
            {
                [self performSelector:@selector(showStartRecordingTutorial) withObject:nil afterDelay:0.5f];
            }
        }
        
        if (i == 1) {
            [self.m_gpuImageView setHidden:NO];
            [self.m_gpuImageView1 setHidden:YES];
            [self.m_gpuImageView2 setHidden:YES];
            [self.m_gpuImageView3 setHidden:YES];
            [self.m_gpuImageView4 setHidden:YES];
            [self.m_gpuImageView5 setHidden:YES];
            [self.m_gpuImageView6 setHidden:YES];
            
            if (filter) {
                [filter removeTarget:self.m_gpuImageView];
                [videoCamera removeTarget:filter];
            }
            if (filter2_1) {
                [filter2_1 removeTarget:self.m_gpuImageView1];
                [videoCamera removeTarget:filter2_1];
            }
            if (filter2_2) {
                [filter2_2 removeTarget:self.m_gpuImageView2];
                [videoCamera removeTarget:filter2_2];
            }
            if (filter1) {
                [filter1 removeTarget:self.m_gpuImageView3];
                [videoCamera removeTarget:filter1];
            }
            if (filter2) {
                [filter2 removeTarget:self.m_gpuImageView4];
                [videoCamera removeTarget:filter2];
            }
            if (filter3) {
                [filter3 removeTarget:self.m_gpuImageView5];
                [videoCamera removeTarget:filter3];
            }
            if (filter2_3) {
                [filter2_3 removeTarget:self.m_gpuImageView6];
                [videoCamera removeTarget:filter2_3];
            }
            filter = [[GPUImageSaturationFilter alloc] init];
            [videoCamera addTarget:filter];
            [filter addTarget:self.m_gpuImageView];
            self.m_gpuImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        }
        if (i == 2) {
            [self.m_gpuImageView setHidden:YES];
            [self.m_gpuImageView1 setHidden:NO];
            [self.m_gpuImageView2 setHidden:YES];
            [self.m_gpuImageView3 setHidden:YES];
            [self.m_gpuImageView4 setHidden:YES];
            [self.m_gpuImageView5 setHidden:YES];
            [self.m_gpuImageView6 setHidden:YES];
            if (filter) {
                [filter removeTarget:self.m_gpuImageView];
                [videoCamera removeTarget:filter];
            }
            if (filter2_1) {
                [filter2_1 removeTarget:self.m_gpuImageView1];
                [videoCamera removeTarget:filter2_1];
            }
            if (filter2_2) {
                [filter2_2 removeTarget:self.m_gpuImageView2];
                [videoCamera removeTarget:filter2_2];
            }
            if (filter1) {
                [filter1 removeTarget:self.m_gpuImageView3];
                [videoCamera removeTarget:filter1];
            }
            if (filter2) {
                [filter2 removeTarget:self.m_gpuImageView4];
                [videoCamera removeTarget:filter2];
            }
            if (filter3) {
                [filter3 removeTarget:self.m_gpuImageView5];
                [videoCamera removeTarget:filter3];
            }
            if (filter2_3) {
                [filter2_3 removeTarget:self.m_gpuImageView6];
                [videoCamera removeTarget:filter2_3];
            }
            filter2_1 = [[GPUImageFilterGroup alloc] init];
            GPUImageBulgeDistortionFilter *m_GPUImageBulgeDistortionFilter = [[GPUImageBulgeDistortionFilter alloc] init];
            [filter2_1 addFilter:m_GPUImageBulgeDistortionFilter];
            GPUImageBulgeDistortionFilter1 *m_GPUImageBulgeDistortionFilter1 = [[GPUImageBulgeDistortionFilter1 alloc] init];
            [filter2_1 addFilter:m_GPUImageBulgeDistortionFilter1];
            [m_GPUImageBulgeDistortionFilter addTarget:m_GPUImageBulgeDistortionFilter1];
            [filter2_1 setInitialFilters:[NSArray arrayWithObject:m_GPUImageBulgeDistortionFilter]];
            [filter2_1 setTerminalFilter:m_GPUImageBulgeDistortionFilter1];
            [videoCamera addTarget:filter2_1];
            [filter2_1 addTarget:self.m_gpuImageView1];
            //NSLog(@"self.m_gpuimageview width= %f,self.m_gpuimageview height= %f",[self.m_gpuImageView1 sizeInPixels].width ,[self.m_gpuImageView1 sizeInPixels].height );
            self.m_gpuImageView1.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        }
        if (i == 3) {
            [self.m_gpuImageView setHidden:YES];
            [self.m_gpuImageView1 setHidden:YES];
            [self.m_gpuImageView2 setHidden:NO];
            [self.m_gpuImageView3 setHidden:YES];
            [self.m_gpuImageView4 setHidden:YES];
            [self.m_gpuImageView5 setHidden:YES];
            [self.m_gpuImageView6 setHidden:YES];
            if (filter) {
                [filter removeTarget:self.m_gpuImageView];
                [videoCamera removeTarget:filter];
            }
            if (filter2_1) {
                [filter2_1 removeTarget:self.m_gpuImageView1];
                [videoCamera removeTarget:filter2_1];
            }
            if (filter2_2) {
                [filter2_2 removeTarget:self.m_gpuImageView2];
                [videoCamera removeTarget:filter2_2];
            }
            if (filter1) {
                [filter1 removeTarget:self.m_gpuImageView3];
                [videoCamera removeTarget:filter1];
            }
            if (filter2) {
                [filter2 removeTarget:self.m_gpuImageView4];
                [videoCamera removeTarget:filter2];
            }
            if (filter3) {
                [filter3 removeTarget:self.m_gpuImageView5];
                [videoCamera removeTarget:filter3];
            }
            if (filter2_3) {
                [filter2_3 removeTarget:self.m_gpuImageView6];
                [videoCamera removeTarget:filter2_3];
            }
            
            filter2_2 = [[GPUImageFilterGroup alloc] init];
            //        GPUImagePinchDistortionFilter *m_pinch1 = [[GPUImagePinchDistortionFilter alloc] init];
            //        m_pinch1.center = CGPointMake(0, 0.5);
            //        m_pinch1.radius = 0.2;
            //        m_pinch1.scale = -0.5;
            //        [filter2_2 addFilter:m_pinch1];
            
            GPUImagePinchDistortionFilter *m_pinch2 = [[GPUImagePinchDistortionFilter alloc] init];
            m_pinch2.center = CGPointMake(0.5, 0);
            m_pinch2.radius = 0.5;
            m_pinch2.scale = -0.6;
            
            [filter2_2 addFilter:m_pinch2];
            //        GPUImagePinchDistortionFilter *m_pinch3 = [[GPUImagePinchDistortionFilter alloc] init];
            
            //        m_pinch3.center = CGPointMake(1, 0.5);
            //        m_pinch3.radius = 0.2;
            //        m_pinch3.scale = -0.5;
            //        [filter2_2 addFilter:m_pinch3];
            GPUImagePinchDistortionFilter *m_pinch4 = [[GPUImagePinchDistortionFilter alloc] init];
            
            m_pinch4.center = CGPointMake(0.5, 1);
            m_pinch4.radius = 0.5;
            m_pinch4.scale = -0.8;
            [filter2_2 addFilter:m_pinch4];
            
            GPUImageHueFilter *m_pinch5 = [[GPUImageHueFilter alloc] init];
            [filter2_2 addFilter:m_pinch5];
            
            //        [m_pinch1 addTarget:m_pinch2];
            [m_pinch2 addTarget:m_pinch4];
            //        [m_pinch3 addTarget:m_pinch4];
            [m_pinch4 addTarget:m_pinch5];
            
            
            
            [filter2_2 setInitialFilters:[NSArray arrayWithObject:m_pinch2]];
            [filter2_2 setTerminalFilter:m_pinch5];
            [videoCamera addTarget:filter2_2];
            
            [filter2_2 addTarget:self.m_gpuImageView2];
            self.m_gpuImageView2.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
            
        }
        if (i == 4) {
            [self.m_gpuImageView setHidden:YES];
            [self.m_gpuImageView1 setHidden:YES];
            [self.m_gpuImageView2 setHidden:YES];
            [self.m_gpuImageView3 setHidden:NO];
            [self.m_gpuImageView4 setHidden:YES];
            [self.m_gpuImageView5 setHidden:YES];
            [self.m_gpuImageView6 setHidden:YES];
            if (filter) {
                [filter removeTarget:self.m_gpuImageView];
                [videoCamera removeTarget:filter];
            }
            if (filter2_1) {
                [filter2_1 removeTarget:self.m_gpuImageView1];
                [videoCamera removeTarget:filter2_1];
            }
            if (filter2_2) {
                [filter2_2 removeTarget:self.m_gpuImageView2];
                [videoCamera removeTarget:filter2_2];
            }
            if (filter1) {
                [filter1 removeTarget:self.m_gpuImageView3];
                [videoCamera removeTarget:filter1];
            }
            if (filter2) {
                [filter2 removeTarget:self.m_gpuImageView4];
                [videoCamera removeTarget:filter2];
            }
            if (filter3) {
                [filter3 removeTarget:self.m_gpuImageView5];
                [videoCamera removeTarget:filter3];
            }
            if (filter2_3) {
                [filter2_3 removeTarget:self.m_gpuImageView6];
                [videoCamera removeTarget:filter2_3];
            }
            filter1 = [[GPUImageStretchDistortionFilter alloc] init];
            [videoCamera addTarget:filter1];
            [filter1 addTarget:self.m_gpuImageView3];
            m_gpuImageView3.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        }
        if (i == 5) {
            [self.m_gpuImageView setHidden:YES];
            [self.m_gpuImageView1 setHidden:YES];
            [self.m_gpuImageView2 setHidden:YES];
            [self.m_gpuImageView3 setHidden:YES];
            [self.m_gpuImageView4 setHidden:NO];
            [self.m_gpuImageView5 setHidden:YES];
            [self.m_gpuImageView6 setHidden:YES];
            if (filter) {
                [filter removeTarget:self.m_gpuImageView];
                [videoCamera removeTarget:filter];
            }
            if (filter2_1) {
                [filter2_1 removeTarget:self.m_gpuImageView1];
                [videoCamera removeTarget:filter2_1];
            }
            if (filter2_2) {
                [filter2_2 removeTarget:self.m_gpuImageView2];
                [videoCamera removeTarget:filter2_2];
            }
            if (filter1) {
                [filter1 removeTarget:self.m_gpuImageView3];
                [videoCamera removeTarget:filter1];
            }
            if (filter2) {
                [filter2 removeTarget:self.m_gpuImageView4];
                [videoCamera removeTarget:filter2];
            }
            if (filter3) {
                [filter3 removeTarget:self.m_gpuImageView5];
                [videoCamera removeTarget:filter3];
            }
            if (filter2_3) {
                [filter2_3 removeTarget:self.m_gpuImageView6];
                [videoCamera removeTarget:filter2_3];
            }
            filter2 = [[GPUImageStretchDistortionFilter1 alloc] init];
            [videoCamera addTarget:filter2];
            [filter2 addTarget:self.m_gpuImageView4];
            self.m_gpuImageView4.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        }
        if (i == 6) {
            [self.m_gpuImageView setHidden:YES];
            [self.m_gpuImageView1 setHidden:YES];
            [self.m_gpuImageView2 setHidden:YES];
            [self.m_gpuImageView3 setHidden:YES];
            [self.m_gpuImageView4 setHidden:YES];
            [self.m_gpuImageView5 setHidden:NO];
            [self.m_gpuImageView6 setHidden:YES];
            if (filter) {
                [filter removeTarget:self.m_gpuImageView];
                [videoCamera removeTarget:filter];
            }
            if (filter2_1) {
                [filter2_1 removeTarget:self.m_gpuImageView1];
                [videoCamera removeTarget:filter2_1];
            }
            if (filter2_2) {
                [filter2_2 removeTarget:self.m_gpuImageView2];
                [videoCamera removeTarget:filter2_2];
            }
            if (filter1) {
                [filter1 removeTarget:self.m_gpuImageView3];
                [videoCamera removeTarget:filter1];
            }
            if (filter2) {
                [filter2 removeTarget:self.m_gpuImageView4];
                [videoCamera removeTarget:filter2];
            }
            if (filter3) {
                [filter3 removeTarget:self.m_gpuImageView5];
                [videoCamera removeTarget:filter3];
            }
            if (filter2_3) {
                [filter2_3 removeTarget:self.m_gpuImageView6];
                [videoCamera removeTarget:filter2_3];
            }
            filter3 = [[GPUImageBulgeDistortionFilter2 alloc] init];
            [videoCamera addTarget:filter3];
            [filter3 addTarget:m_gpuImageView5];
            m_gpuImageView5.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        }
        if (i == 7) {
            [self.m_gpuImageView setHidden:YES];
            [self.m_gpuImageView1 setHidden:YES];
            [self.m_gpuImageView2 setHidden:YES];
            [self.m_gpuImageView3 setHidden:YES];
            [self.m_gpuImageView4 setHidden:YES];
            [self.m_gpuImageView5 setHidden:YES];
            [self.m_gpuImageView6 setHidden:NO];
            if (filter) {
                [filter removeTarget:self.m_gpuImageView];
                [videoCamera removeTarget:filter];
            }
            if (filter2_1) {
                [filter2_1 removeTarget:self.m_gpuImageView1];
                [videoCamera removeTarget:filter2_1];
            }
            if (filter2_2) {
                [filter2_2 removeTarget:self.m_gpuImageView2];
                [videoCamera removeTarget:filter2_2];
            }
            if (filter1) {
                [filter1 removeTarget:self.m_gpuImageView3];
                [videoCamera removeTarget:filter1];
            }
            if (filter2) {
                [filter2 removeTarget:self.m_gpuImageView4];
                [videoCamera removeTarget:filter2];
            }
            if (filter3) {
                [filter3 removeTarget:self.m_gpuImageView5];
                [videoCamera removeTarget:filter3];
            }
            if (filter2_3) {
                [filter2_3 removeTarget:self.m_gpuImageView6];
                [videoCamera removeTarget:filter2_3];
            }
            filter2_3 = [[GPUImageFilterGroup alloc] init];
            GPUImageSwirlFilter *m_GPUImageSwirlFilter = [[GPUImageSwirlFilter alloc] init];
            [filter2_3 addFilter:m_GPUImageSwirlFilter];
            GPUImageSwirlFilter1 *m_GPUImageSwirlFilter1 = [[GPUImageSwirlFilter1 alloc] init];
            [filter2_3 addFilter:m_GPUImageSwirlFilter1];
            [m_GPUImageSwirlFilter addTarget:m_GPUImageSwirlFilter1];
            [filter2_3 setInitialFilters:[NSArray arrayWithObject:m_GPUImageSwirlFilter]];
            [filter2_3 setTerminalFilter:m_GPUImageSwirlFilter1];
            [videoCamera addTarget:filter2_3];
            [filter2_3 addTarget:self.m_gpuImageView6];
            m_gpuImageView6.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
            
        }
        [videoCamera startCameraCapture];
    }
}

- (IBAction)onCameraChangeAction:(id)sender {
    if(![cameraBtn isSelected]) {
        [cameraBtn setSelected:YES]; //back
        [videoCamera rotateCamera];
        
    }else{
        [cameraBtn setSelected:NO]; //front
        [videoCamera rotateCamera];
    }
}

- (void)selectedFilterMethod:(int) i{
    if (m_filterMethod == 1) {// && !mb_isSelected
        [self selectedNormalFilterMethod];
    }else if(m_filterMethod == 2) {// && !mb_isSelected
        [self selectedOwlEyeFilterMethod];
    }else if(m_filterMethod == 3) {// && !mb_isSelected
        [self selectedGreenMonsterFilterMethod];
    }else if(m_filterMethod == 4) {// && !mb_isSelected
        [self selectedSquareHeadFilterMethod];
    }else if(m_filterMethod == 5) {
        [self selectedSquareChinFilterMethod];
    }else if(m_filterMethod == 6) {// && !mb_isSelected
        [self selectedBigHeadFilterMethod];
    }else if(m_filterMethod == 7 ) {//&& !mb_isSelected
        [self selectedGremlinFaceMethod];
    }else{
        return;
    }
}

#pragma mark - Action Extensions
-(void)openFileWithFilePathURL:(NSURL*)filePathURL {
    //NSLog(@"filePathURL is %@", filePathURL.absoluteString);
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

#pragma mark - Record Video
- (IBAction)onRecordAction:(id)sender {
    if([recordBtn isSelected]) {
        [self stopAutoRecording];
    }else{
        [SDTutorialManager hideAllTutorialMessages];
        [self startAutoRecording];
    }
}

- (void)stopAutoRecording {
    
    if(![[SDTutorialManager ShareManager] isTutorialStepDone: ANALYTICS_MANAGER_TUTORIAL_STEP_4_Recording_finished])
    {
        shouldStopFlashingStartButton = NO;
    }
    
    [self setProgress:0.0f];
    [[SoundManager sharedManager].currentMusic setCurrentTime:0];
    [[SoundManager sharedManager].currentMusic stop];
    [SoundManager sharedManager].currentMusic = nil;
    
    [recordTitleLabel setHidden:NO];
    [cameraBtn setHidden:NO];
    _scrollView.hidden = NO;
    [recordBtn setSelected:NO];
    [self stopRecord];
    [playingTimer invalidate];
    playingTimer = nil;
}

- (void)startAutoRecording {
    //  [SDTutorialManager ShareManager].clickOnVideoStartRecordingStepFinished = YES;
    
    shouldStopFlashingStartButton = YES;
    
    [[SDTutorialManager ShareManager] setTutorialStepFinish: ANALYTICS_MANAGER_TUTORIAL_STEP_3_Recording_start_pressed];
    
    [recordTitleLabel setHidden:YES];
    [cameraBtn setHidden:YES];
    _scrollView.hidden = YES;
    [recordBtn setSelected:YES];
    //zhaozhaozhao
    [self recordVideo];
    [self selectedFilterMethod:[self getfiltermethod]];
    [self startPlayWav];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DMVideoPreviewViewController *controller = segue.destinationViewController;
    
    controller.soundFilePath = soundFilePath;
    //  detailVC.category = [categoryList objectAtIndex:indexPath.row];
    //  detailVC.soundBoardName = self.soundboardNameField.text;
}

- (void)updateTime:(NSTimer *)timer {
    if(![[SoundManager sharedManager].currentMusic isPlaying]) {
        [self stopAutoRecording];
        [movieWriter finishRecording];
        
        [[SDTutorialManager ShareManager] setTutorialStepFinish: ANALYTICS_MANAGER_TUTORIAL_STEP_4_Recording_finished];
        [[SDTutorialManager ShareManager] saveData];
        
        [self performSegueWithIdentifier:@"DMVideoPreviewIdentifier" sender:nil];
        return;
    }
    if ([SoundManager sharedManager].currentMusic.duration == 0.f) {
        return;
    }
    float fProgress = [SoundManager sharedManager].currentMusic.currentTime / [SoundManager sharedManager].currentMusic.duration;
    [self setProgress:fProgress];
}

- (void)setProgress:(float)progress {
    [progressImageView setFrame:CGRectMake(self.audioPlot.frame.size.width * progress, progressImageView.frame.origin.y, progressImageView.frame.size.width, progressImageView.frame.size.height)];
}

- (void)stopRecord {
    
}

- (void)startPlayWav {
    /*
     Load in the sample file
     */
    [self setProgress:0.0f];
    // NSString* filename = @"2.mp3";
    [[SoundManager sharedManager] playMusic:soundFilePath looping:NO];
    playingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
}

- (void) deleteWriter
{
    _wVideoInput = nil;
    _wAudioInput = nil;
    _writer = nil;
}

- (void) deleteWriterCodec
{
    _writerCodec = nil;
}

- (void)recordVideo {
    bEncode = YES;
}

#pragma mark - selected the filter Method and capture video

- (void) selectedNormalFilterMethod
{
    if([[SoundManager sharedManager].currentMusic isPlaying] && !([self getfiltermethod] == 1)){
        return;
    }else{
        
        if (movieWriter) {
            [filter removeTarget:movieWriter];
        }
        
        if (filter) {
            [filter removeTarget:self.m_gpuImageView];
            [videoCamera removeTarget:filter];
        }
        if (filter2_1) {
            [filter2_1 removeTarget:self.m_gpuImageView1];
            [videoCamera removeTarget:filter2_1];
        }
        if (filter2_2) {
            [filter2_2 removeTarget:self.m_gpuImageView2];
            [videoCamera removeTarget:filter2_2];
        }
        if (filter1) {
            [filter1 removeTarget:self.m_gpuImageView3];
            [videoCamera removeTarget:filter1];
        }
        if (filter2) {
            [filter2 removeTarget:self.m_gpuImageView4];
            [videoCamera removeTarget:filter2];
        }
        if (filter3) {
            [filter3 removeTarget:self.m_gpuImageView5];
            [videoCamera removeTarget:filter3];
        }
        if (filter2_3) {
            [filter2_3 removeTarget:self.m_gpuImageView6];
            [videoCamera removeTarget:filter2_3];
        }
        
        filter = [[GPUImageSaturationFilter alloc] init];
        [videoCamera addTarget:filter];
        [filter addTarget:self.m_gpuImageView];
        self.m_gpuImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        
        
        NSString *pathToMovie = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Movie.m4v"];
        unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
        NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
        //NSLog(@"this is capture video link = %@",pathToMovie);
        movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0, 640.0)];
        movieWriter.encodingLiveVideo = YES;
        [filter addTarget:movieWriter];
        //    double delayToStartRecording = 0.0;
        //    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, delayToStartRecording * NSEC_PER_SEC);
        //    dispatch_after(startTime, dispatch_get_main_queue(), ^(void){
        if(![[SoundManager sharedManager].currentMusic isPlaying]) {
            //NSLog(@"Start recording");
            [movieWriter startRecording];
        }else{
            //        double delayInSeconds = 10.0;
            //        dispatch_time_t stopTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            //        dispatch_after(stopTime, dispatch_get_main_queue(), ^(void){
            [filter removeTarget:movieWriter];
            videoCamera.audioEncodingTarget = nil;
            [movieWriter finishRecording];
            //NSLog(@"Movie completed");
            mb_isSelectedStartButton = NO;
        }
        //        });
        //    });
    }
}

- (void) selectedOwlEyeFilterMethod
{
    if([[SoundManager sharedManager].currentMusic isPlaying] && !([self getfiltermethod] == 2)){
        return;
    }else{
        if (movieWriter) {
            [filter2_1 removeTarget:movieWriter];
        }
        if (filter) {
            [filter removeTarget:self.m_gpuImageView];
            [videoCamera removeTarget:filter];
        }
        if (filter2_1) {
            [filter2_1 removeTarget:self.m_gpuImageView1];
            [videoCamera removeTarget:filter2_1];
        }
        if (filter2_2) {
            [filter2_2 removeTarget:self.m_gpuImageView2];
            [videoCamera removeTarget:filter2_2];
        }
        if (filter1) {
            [filter1 removeTarget:self.m_gpuImageView3];
            [videoCamera removeTarget:filter1];
        }
        if (filter2) {
            [filter2 removeTarget:self.m_gpuImageView4];
            [videoCamera removeTarget:filter2];
        }
        if (filter3) {
            [filter3 removeTarget:self.m_gpuImageView5];
            [videoCamera removeTarget:filter3];
        }
        if (filter2_3) {
            [filter2_3 removeTarget:self.m_gpuImageView6];
            [videoCamera removeTarget:filter2_3];
        }
        filter2_1 = [[GPUImageFilterGroup alloc] init];
        GPUImageBulgeDistortionFilter *m_GPUImageBulgeDistortionFilter = [[GPUImageBulgeDistortionFilter alloc] init];
        [filter2_1 addFilter:m_GPUImageBulgeDistortionFilter];
        GPUImageBulgeDistortionFilter1 *m_GPUImageBulgeDistortionFilter1 = [[GPUImageBulgeDistortionFilter1 alloc] init];
        [filter2_1 addFilter:m_GPUImageBulgeDistortionFilter1];
        [m_GPUImageBulgeDistortionFilter addTarget:m_GPUImageBulgeDistortionFilter1];
        [filter2_1 setInitialFilters:[NSArray arrayWithObject:m_GPUImageBulgeDistortionFilter]];
        [filter2_1 setTerminalFilter:m_GPUImageBulgeDistortionFilter1];
        GPUImageView *filterView = self.m_gpuImageView1;
        [filter2_1 addTarget:filterView];
        // Record a movie for 10 s and store it in /Documents, visible via iTunes file sharing
        NSString *pathToMovie = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Movie.m4v"];
        unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
        NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
        //NSLog(@"this is capture video link = %@",pathToMovie);
        movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0, 640.0)];
        movieWriter.encodingLiveVideo = YES;
        [filter2_1 addTarget:movieWriter];
        [videoCamera addTarget:filter2_1];
        [videoCamera startCameraCapture];
        
        if(![[SoundManager sharedManager].currentMusic isPlaying]) {
            //NSLog(@"Start recording");
            [movieWriter startRecording];
        }else{
            //        double delayInSeconds = 10.0;
            //        dispatch_time_t stopTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            //        dispatch_after(stopTime, dispatch_get_main_queue(), ^(void){
            [filter2_1 removeTarget:movieWriter];
            videoCamera.audioEncodingTarget = nil;
            [movieWriter finishRecording];
            //NSLog(@"Movie completed");
            mb_isSelectedStartButton = NO;
        }
        //        });
        //    });
    }
}

- (void) selectedGreenMonsterFilterMethod
{
    if([[SoundManager sharedManager].currentMusic isPlaying] && !([self getfiltermethod] == 3)){
        return;
    }else{
        if (movieWriter) {
            [filter2_2 removeTarget:movieWriter];
        }
        if (filter) {
            [filter removeTarget:self.m_gpuImageView];
            [videoCamera removeTarget:filter];
        }
        if (filter2_1) {
            [filter2_1 removeTarget:self.m_gpuImageView1];
            [videoCamera removeTarget:filter2_1];
        }
        if (filter2_2) {
            [filter2_2 removeTarget:self.m_gpuImageView2];
            [videoCamera removeTarget:filter2_2];
        }
        if (filter1) {
            [filter1 removeTarget:self.m_gpuImageView3];
            [videoCamera removeTarget:filter1];
        }
        if (filter2) {
            [filter2 removeTarget:self.m_gpuImageView4];
            [videoCamera removeTarget:filter2];
        }
        if (filter3) {
            [filter3 removeTarget:self.m_gpuImageView5];
            [videoCamera removeTarget:filter3];
        }
        if (filter2_3) {
            [filter2_3 removeTarget:self.m_gpuImageView6];
            [videoCamera removeTarget:filter2_3];
        }
        filter2_2 = [[GPUImageFilterGroup alloc] init];
        //        GPUImagePinchDistortionFilter *m_pinch1 = [[GPUImagePinchDistortionFilter alloc] init];
        //        m_pinch1.center = CGPointMake(0, 0.5);
        //        m_pinch1.radius = 0.2;
        //        m_pinch1.scale = -0.5;
        //        [filter2_2 addFilter:m_pinch1];
        
        GPUImagePinchDistortionFilter *m_pinch2 = [[GPUImagePinchDistortionFilter alloc] init];
        m_pinch2.center = CGPointMake(0.5, 0);
        m_pinch2.radius = 0.5;
        m_pinch2.scale = -0.6;
        
        [filter2_2 addFilter:m_pinch2];
        //        GPUImagePinchDistortionFilter *m_pinch3 = [[GPUImagePinchDistortionFilter alloc] init];
        
        //        m_pinch3.center = CGPointMake(1, 0.5);
        //        m_pinch3.radius = 0.2;
        //        m_pinch3.scale = -0.5;
        //        [filter2_2 addFilter:m_pinch3];
        GPUImagePinchDistortionFilter *m_pinch4 = [[GPUImagePinchDistortionFilter alloc] init];
        
        m_pinch4.center = CGPointMake(0.5, 1);
        m_pinch4.radius = 0.5;
        m_pinch4.scale = -0.8;
        [filter2_2 addFilter:m_pinch4];
        
        GPUImageHueFilter *m_pinch5 = [[GPUImageHueFilter alloc] init];
        [filter2_2 addFilter:m_pinch5];
        
        //        [m_pinch1 addTarget:m_pinch2];
        [m_pinch2 addTarget:m_pinch4];
        //        [m_pinch3 addTarget:m_pinch4];
        [m_pinch4 addTarget:m_pinch5];
        
        
        
        [filter2_2 setInitialFilters:[NSArray arrayWithObject:m_pinch2]];
        [filter2_2 setTerminalFilter:m_pinch5];
        [videoCamera addTarget:filter2_2];
        
        [filter2_2 addTarget:self.m_gpuImageView2];
        self.m_gpuImageView2.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        
        NSString *pathToMovie = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Movie.m4v"];
        unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
        NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
        //NSLog(@"this is capture video link = %@",pathToMovie);
        movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0, 640.0)];
        movieWriter.encodingLiveVideo = YES;
        [filter2_2 addTarget:movieWriter];
        if(![[SoundManager sharedManager].currentMusic isPlaying]) {
            //NSLog(@"Start recording");
            [movieWriter startRecording];
        }else{
            //        double delayInSeconds = 10.0;
            //        dispatch_time_t stopTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            //        dispatch_after(stopTime, dispatch_get_main_queue(), ^(void){
            [filter2_2 removeTarget:movieWriter];
            videoCamera.audioEncodingTarget = nil;
            [movieWriter finishRecording];
            //NSLog(@"Movie completed");
            mb_isSelectedStartButton = NO;
        }
        //        });
        //    });
    }
}

- (void) selectedSquareHeadFilterMethod
{
    if([[SoundManager sharedManager].currentMusic isPlaying] && !([self getfiltermethod] == 4)){
        return;
    }else{
        
        if (movieWriter) {
            [filter1 removeTarget:movieWriter];
        }
        if (filter) {
            [filter removeTarget:self.m_gpuImageView];
            [videoCamera removeTarget:filter];
        }
        if (filter2_1) {
            [filter2_1 removeTarget:self.m_gpuImageView1];
            [videoCamera removeTarget:filter2_1];
        }
        if (filter2_2) {
            [filter2_2 removeTarget:self.m_gpuImageView2];
            [videoCamera removeTarget:filter2_2];
        }
        if (filter1) {
            [filter1 removeTarget:self.m_gpuImageView3];
            [videoCamera removeTarget:filter1];
        }
        if (filter2) {
            [filter2 removeTarget:self.m_gpuImageView4];
            [videoCamera removeTarget:filter2];
        }
        if (filter3) {
            [filter3 removeTarget:self.m_gpuImageView5];
            [videoCamera removeTarget:filter3];
        }
        if (filter2_3) {
            [filter2_3 removeTarget:self.m_gpuImageView6];
            [videoCamera removeTarget:filter2_3];
        }
        filter1 = [[GPUImageStretchDistortionFilter alloc] init];
        [videoCamera addTarget:filter1];
        [filter1 addTarget:self.m_gpuImageView3];
        m_gpuImageView3.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        
        NSString *pathToMovie = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Movie.m4v"];
        unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
        NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
        //NSLog(@"this is capture video link = %@",pathToMovie);
        movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0, 640.0)];
        movieWriter.encodingLiveVideo = YES;
        [filter1 addTarget:movieWriter];
        if(![[SoundManager sharedManager].currentMusic isPlaying]) {
            //NSLog(@"Start recording");
            [movieWriter startRecording];
        }else{
            //        double delayInSeconds = 10.0;
            //        dispatch_time_t stopTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            //        dispatch_after(stopTime, dispatch_get_main_queue(), ^(void){
            [filter1 removeTarget:movieWriter];
            videoCamera.audioEncodingTarget = nil;
            [movieWriter finishRecording];
            //NSLog(@"Movie completed");
            mb_isSelectedStartButton = NO;
        }
        //        });
        //    });
    }}

- (void) selectedSquareChinFilterMethod
{
    if([[SoundManager sharedManager].currentMusic isPlaying] && !([self getfiltermethod] == 5)){
        return;
    }else{
        
        if (movieWriter) {
            [filter2 removeTarget:movieWriter];
        }
        if (filter) {
            [filter removeTarget:self.m_gpuImageView];
            [videoCamera removeTarget:filter];
        }
        if (filter2_1) {
            [filter2_1 removeTarget:self.m_gpuImageView1];
            [videoCamera removeTarget:filter2_1];
        }
        if (filter2_2) {
            [filter2_2 removeTarget:self.m_gpuImageView2];
            [videoCamera removeTarget:filter2_2];
        }
        if (filter1) {
            [filter1 removeTarget:self.m_gpuImageView3];
            [videoCamera removeTarget:filter1];
        }
        if (filter2) {
            [filter2 removeTarget:self.m_gpuImageView4];
            [videoCamera removeTarget:filter2];
        }
        if (filter3) {
            [filter3 removeTarget:self.m_gpuImageView5];
            [videoCamera removeTarget:filter3];
        }
        if (filter2_3) {
            [filter2_3 removeTarget:self.m_gpuImageView6];
            [videoCamera removeTarget:filter2_3];
        }
        filter2 = [[GPUImageStretchDistortionFilter1 alloc] init];
        [videoCamera addTarget:filter2];
        [filter2 addTarget:self.m_gpuImageView4];
        self.m_gpuImageView4.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        
        NSString *pathToMovie = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Movie.m4v"];
        unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
        NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
        //NSLog(@"this is capture video link = %@",pathToMovie);
        movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0, 640.0)];
        movieWriter.encodingLiveVideo = YES;
        [filter2 addTarget:movieWriter];
        if(![[SoundManager sharedManager].currentMusic isPlaying]) {
            //NSLog(@"Start recording");
            [movieWriter startRecording];
        }else{
            [filter2 removeTarget:movieWriter];
            videoCamera.audioEncodingTarget = nil;
            [movieWriter finishRecording];
            //NSLog(@"Movie completed");
            mb_isSelectedStartButton = NO;
        }
    }}

- (void) selectedBigHeadFilterMethod
{
    if([[SoundManager sharedManager].currentMusic isPlaying] && !([self getfiltermethod] == 6)){
        return;
    }else{
        
        if (movieWriter) {
            [filter3 removeTarget:movieWriter];
        }
        if (filter) {
            [filter removeTarget:self.m_gpuImageView];
            [videoCamera removeTarget:filter];
        }
        if (filter2_1) {
            [filter2_1 removeTarget:self.m_gpuImageView1];
            [videoCamera removeTarget:filter2_1];
        }
        if (filter2_2) {
            [filter2_2 removeTarget:self.m_gpuImageView2];
            [videoCamera removeTarget:filter2_2];
        }
        if (filter1) {
            [filter1 removeTarget:self.m_gpuImageView3];
            [videoCamera removeTarget:filter1];
        }
        if (filter2) {
            [filter2 removeTarget:self.m_gpuImageView4];
            [videoCamera removeTarget:filter2];
        }
        if (filter3) {
            [filter3 removeTarget:self.m_gpuImageView5];
            [videoCamera removeTarget:filter3];
        }
        if (filter2_3) {
            [filter2_3 removeTarget:self.m_gpuImageView6];
            [videoCamera removeTarget:filter2_3];
        }
        filter3 = [[GPUImageBulgeDistortionFilter2 alloc] init];
        [videoCamera addTarget:filter3];
        [filter3 addTarget:m_gpuImageView5];
        m_gpuImageView5.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        
        NSString *pathToMovie = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Movie.m4v"];
        unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
        NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
        //NSLog(@"this is capture video link = %@",pathToMovie);
        movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0, 640.0)];
        movieWriter.encodingLiveVideo = YES;
        [filter3 addTarget:movieWriter];
        if(![[SoundManager sharedManager].currentMusic isPlaying]) {
            //NSLog(@"Start recording");
            [movieWriter startRecording];
        }else{
            [filter3 removeTarget:movieWriter];
            videoCamera.audioEncodingTarget = nil;
            [movieWriter finishRecording];
            //NSLog(@"Movie completed");
            mb_isSelectedStartButton = NO;
        }
    }
}

- (void) selectedGremlinFaceMethod
{
    if([[SoundManager sharedManager].currentMusic isPlaying] && !([self getfiltermethod] == 7)){
        return;
    }else{
        
        if (movieWriter) {
            [filter2_3 removeTarget:movieWriter];
        }
        if (filter) {
            [filter removeTarget:self.m_gpuImageView];
            [videoCamera removeTarget:filter];
        }
        if (filter2_1) {
            [filter2_1 removeTarget:self.m_gpuImageView1];
            [videoCamera removeTarget:filter2_1];
        }
        if (filter2_2) {
            [filter2_2 removeTarget:self.m_gpuImageView2];
            [videoCamera removeTarget:filter2_2];
        }
        if (filter1) {
            [filter1 removeTarget:self.m_gpuImageView3];
            [videoCamera removeTarget:filter1];
        }
        if (filter2) {
            [filter2 removeTarget:self.m_gpuImageView4];
            [videoCamera removeTarget:filter2];
        }
        if (filter3) {
            [filter3 removeTarget:self.m_gpuImageView5];
            [videoCamera removeTarget:filter3];
        }
        if (filter2_3) {
            [filter2_3 removeTarget:self.m_gpuImageView6];
            [videoCamera removeTarget:filter2_3];
        }
        
        filter2_3 = [[GPUImageFilterGroup alloc] init];
        GPUImageSwirlFilter *m_GPUImageSwirlFilter = [[GPUImageSwirlFilter alloc] init];
        [filter2_3 addFilter:m_GPUImageSwirlFilter];
        GPUImageSwirlFilter1 *m_GPUImageSwirlFilter1 = [[GPUImageSwirlFilter1 alloc] init];
        [filter2_3 addFilter:m_GPUImageSwirlFilter1];
        [m_GPUImageSwirlFilter addTarget:m_GPUImageSwirlFilter1];
        [filter2_3 setInitialFilters:[NSArray arrayWithObject:m_GPUImageSwirlFilter]];
        [filter2_3 setTerminalFilter:m_GPUImageSwirlFilter1];
        GPUImageView *filterView = self.m_gpuImageView6;
        [filter2_3 addTarget:filterView];
        NSString *pathToMovie = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Movie.m4v"];
        unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
        NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
        //NSLog(@"this is capture video link = %@",pathToMovie);
        movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0, 640.0)];
        movieWriter.encodingLiveVideo = YES;
        
        [filter2_3 addTarget:movieWriter];
        [videoCamera addTarget:filter2_3];
        [videoCamera startCameraCapture];
        
        if(![[SoundManager sharedManager].currentMusic isPlaying]) {
            //NSLog(@"Start recording");
            [movieWriter startRecording];
        }else{
            [filter2_3 removeTarget:movieWriter];
            videoCamera.audioEncodingTarget = nil;
            [movieWriter finishRecording];
            //NSLog(@"Movie completed");
            mb_isSelectedStartButton = NO;
        }
    }
}
- (IBAction)goBack:(id)sender {
    viewLoad = NO;
    [self stopAutoRecording];
    [self.navigationController popViewControllerAnimated:YES];
    [AdManager sharedAppManager].disabled = NO;
}

@end