//
//  DMVideoRecordingViewController.h
//  Dubsmash
//
//  Created by Altair on 4/27/15.
//  Copyright (c) 2015 Altair. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "FVSoundWaveView.h"
#import "EZAudio.h"
#import "ILSideScrollView.h"
#import "ACPScrollMenu.h"
#import "GPUImage.h"

typedef enum {
    GPUIMAGE_SATURATION,
    GPUIMAGE_SWIRL,
    GPUIMAGE_BULGE,
    GPUIMAGE_PINCH,
    GPUIMAGE_STRETCH
    
} GPUImageShowcaseFilterType;


@interface DMVideoRecordingViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate,    GPUImageVideoCameraDelegate, GPUImageMovieDelegate, GPUImageMovieWriterDelegate,ACPItemDelegate,ACPScrollDelegate>
{
    AVCaptureSession *_captureSession;
    
    ILSideScrollView * m_selectFilter;
    GPUImageFilterGroup* filter2_1;
    GPUImageFilterGroup* filter2_2;
    GPUImageFilterGroup* filter2_3;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageOutput<GPUImageInput> *filter1;
    GPUImageOutput<GPUImageInput> *filter2;
    GPUImageOutput<GPUImageInput> *filter3;
    
    dispatch_semaphore_t frameRenderingSemaphore;
    
    GPUImageShowcaseFilterType filterType;
    
    GPUImageView *m_gpuImageView;
    
    GPUImageView *m_gpuImageView1;
    GPUImageView *m_gpuImageView2;
    GPUImageView *m_gpuImageView3;
    GPUImageView *m_gpuImageView4;
    GPUImageView *m_gpuImageView5;
    GPUImageView *m_gpuImageView6;
    
    GPUImageUIElement *uiElementInput;
    GPUImagePicture *sourcePicture;
    GPUImageMovieWriter *movieWriter;
    GPUImageMovie *movieFile;
    
    int m_filterMethod;
    
    UIView *faceView;
    
    CIDetector *faceDetector;
    BOOL faceThinking;
    NSString * m_cameraOption;
    
    BOOL mb_isSelectedStartButton;
    
    ACPItem *theFilterItem;
    
    BOOL shouldStopFlashingStartButton;
}

@property (nonatomic,strong) EZAudioFile *audioFile;

@property (nonatomic,assign) BOOL eof;

@property (strong, nonatomic) ACPScrollMenu *scrollView;

- (id)initWithFilterType:(GPUImageShowcaseFilterType)newFilterType;
@property(nonatomic,retain) CIDetector*faceDetector;
@property(nonatomic,retain) IBOutlet GPUImageView *m_gpuImageView;
@property(nonatomic,retain) IBOutlet GPUImageView *m_gpuImageView1;
@property(nonatomic,retain) IBOutlet GPUImageView *m_gpuImageView2;
@property(nonatomic,retain) IBOutlet GPUImageView *m_gpuImageView3;
@property(nonatomic,retain) IBOutlet GPUImageView *m_gpuImageView4;
@property(nonatomic,retain) IBOutlet GPUImageView *m_gpuImageView5;
@property(nonatomic,retain) IBOutlet GPUImageView *m_gpuImageView6;
@property (nonatomic, weak) GPUImageMovieWriter *movieWriter;

@property (nonatomic, retain) IBOutlet EZAudioPlot *audioPlot;
@property (nonatomic, retain) IBOutlet UIImageView *progressImageView;
@property (nonatomic, retain) IBOutlet UIButton *recordBtn;
@property (nonatomic, retain) IBOutlet UIButton *cameraBtn;
@property (nonatomic, retain) IBOutlet UILabel *recordTitleLabel;

@property (nonatomic, retain) NSString* soundFilePath;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) IBOutlet UIView *scrollPositon;
- (void)stopAutoRecording;
@end
