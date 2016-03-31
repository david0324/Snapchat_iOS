//
//  ShootFirstViewController.h
//  SnapDub
//
//  Created by admin on 10/12/15.
//  Copyright © 2015 wjs. All rights reserved.
//
@import AVFoundation;

#import <UIKit/UIKit.h>
#import "LLSimpleCamera.h"
#import "VideoViewController.h"
#import "ImageViewController.h"
#import "YLProgressBar.h"
#import "SCRecorder.h"
#import "SCVideoPlayerViewController.h"
#import "DubsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "EZAudioPlot.h"
#import "EZAudioFile.h"
#import "SoundManager.h"
#import "AppDelegate.h"
#import "GeneralUtility.h"
#import "GPUImageBulgeDistortionFilter1.h"
#import "GPUImageStretchDistortionFilter1.h"
#import "GPUImageBulgeDistortionFilter2.h"
#import "GPUImageSwirlFilter1.h"
#import "SDRecordButton.h"
#import "MBProgressHUD.h"

@interface ShootFirstViewController : UIViewController <SCRecorderDelegate, UIImagePickerControllerDelegate , ACPScrollDelegate , GPUImageVideoCameraDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate,MBProgressHUDDelegate>
{
    ACPItem *theFilterItem;

    GPUImageFilterGroup* owleyefilter;
    GPUImageFilterGroup* hulkfilter;
    GPUImageFilterGroup* gremlinfilter;
    GPUImageOutput<GPUImageInput> *normalfilter;
    GPUImageOutput<GPUImageInput> *squareheadfilter;
    GPUImageOutput<GPUImageInput> *squarechinfilter;
    GPUImageOutput<GPUImageInput> *bigheadfilter;
    
    GPUImageMovieWriter *movieWriter;
    GPUImageMovie *movieFile;
    
    NSMutableArray *gpuImageView_Array;

    AVCaptureSession *_captureSession;
    int m_filterMethod;
    BOOL bEncode;
    BOOL mb_isSelectedStartButton;
    BOOL isRecording;
    
    NSURL *movieURL;
    
    int count_Camera;
    int count_Section;
    
    NSMutableArray *VideoAsset_Array;
    
    CALayer *parentLayer;
    CALayer *videoLayer;
}

@property (weak, nonatomic) IBOutlet UIButton *stopButton;

@property (weak, nonatomic) IBOutlet SDRecordButton *recordBtn0;
@property (weak, nonatomic) IBOutlet SDRecordButton *recordBtn1;
@property (weak, nonatomic) IBOutlet SDRecordButton *recordBtn2;
@property (weak, nonatomic) IBOutlet SDRecordButton *recordBtn3;
@property (weak, nonatomic) IBOutlet SDRecordButton *recordBtn4;
@property (weak, nonatomic) IBOutlet SDRecordButton *recordBtn5;
@property (weak, nonatomic) IBOutlet SDRecordButton *recordBtn6;

@property (weak, nonatomic) IBOutlet UIButton *reverseCamera;
@property (nonatomic, strong) IBOutlet YLProgressBar      *progressBarFlatWithIndicator;
@property (nonatomic, retain) IBOutlet EZAudioPlot *audioPlot;
@property (nonatomic, retain) IBOutlet UIImageView *progressImageView;
@property (nonatomic, retain) NSURL* soundFilePath;
@property (nonatomic,strong) EZAudioFile *audioFile;
@property (nonatomic,assign) BOOL eof;

@property (strong, nonatomic) ACPScrollMenu *scrollView;
@property (strong, nonatomic) IBOutlet UIView *filter_scroll;

@property(nonatomic,retain) IBOutlet GPUImageView *m_gpuImageView0;
@property(nonatomic,retain) IBOutlet GPUImageView *m_gpuImageView1;
@property(nonatomic,retain) IBOutlet GPUImageView *m_gpuImageView2;
@property(nonatomic,retain) IBOutlet GPUImageView *m_gpuImageView3;
@property(nonatomic,retain) IBOutlet GPUImageView *m_gpuImageView4;
@property(nonatomic,retain) IBOutlet GPUImageView *m_gpuImageView5;
@property(nonatomic,retain) IBOutlet GPUImageView *m_gpuImageView6;

@property (strong, nonatomic) MBProgressHUD *HUD;

@end
