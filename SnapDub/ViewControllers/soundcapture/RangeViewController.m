//
//  RangeViewController.m
//  SnapDub
//
//  Created by Infinidy_jiawei on 2015-05-26.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "RangeViewController.h"

#import "SaveViewController.h"
#import "UIViewController+Starlet.h"
#import "SDTutorialManager.h"

@interface RangeViewController ()<UIGestureRecognizerDelegate>{
    
    AudioBufferList *readBuffer;
    float  *_waveformData;
    UInt32 _waveformDrawingIndex;
    UInt32 _waveformFrameRate;
    UInt32 _waveformTotalBuffers;
    float _totalLength;
    float oldX;
    BOOL dragging;
    UIView *window;
    SInt64 minFrame;
    SInt64 maxFrame;
    float _totalDuration;
    float _maxDistance;
    float _minDistance;
    float _leftLimit;
    float _rightLimit;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *totalWidthConst;
@end

@implementation RangeViewController
@synthesize audioPlot = _audioPlot;
@synthesize audioFile = _audioFile;
@synthesize eof = _eof;

#pragma mark - Customize the Audio Plot

-(void) tutorialImageClicked:(id) m
{
    [tutorialView removeFromSuperview];
    
    [[SDTutorialManager ShareManager] setTutorialStepFinish: ANALYTICS_MANAGER_TUTORIAL_STEP_7_0_sound_editing_popupImage];
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    /*
     Customizing the audio plot's look
     */
    // Background color
    self.audioPlot.backgroundColor = [UIColor colorWithRed: 1.0 green: 1.0 blue: 1.0 alpha: 1];
    // Waveform color
    self.audioPlot.color           = [UIColor colorWithRed:0.7 green:0.11 blue:0.58 alpha:0.8];
    // Plot type
    self.audioPlot.plotType        = EZPlotTypeBuffer;
    // Fill
    self.audioPlot.shouldFill      = YES;
    // Mirror
    self.audioPlot.shouldMirror    = YES;
    
    self.totalPlot.backgroundColor = [UIColor colorWithRed: 1.0 green: 1.0 blue: 1.0 alpha: 1];
    // Waveform color
    self.totalPlot.color           = [UIColor colorWithRed:0.8 green:0.2 blue:0.6 alpha:0.8];
    // Plot type
    self.totalPlot.plotType        = EZPlotTypeBuffer;
    // Fill
    self.totalPlot.shouldFill      = YES;
    // Mirror
    
    self.totalPlot.shouldMirror    = YES;
    
    if(![[SDTutorialManager ShareManager] isTutorialStepDone: ANALYTICS_MANAGER_TUTORIAL_STEP_7_0_sound_editing_popupImage] )
    {
        NSString *path = [[NSBundle mainBundle] pathForResource: @"Tutorial_addsoundboard" ofType: @"png"];
        //NSLog(@"path: %@", path);
        UIImage* image = [[UIImage alloc] initWithContentsOfFile: path];
        tutorialView = [[UIImageView alloc] initWithImage: image];
        [tutorialView setFrame:[[UIScreen mainScreen] bounds]];
        [self.view addSubview: tutorialView];
        [ tutorialView setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2)];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tutorialImageClicked:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [tutorialView addGestureRecognizer:singleTap];
        [tutorialView setUserInteractionEnabled:YES];
    }
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /*
     Load in the sample file
     */
    [self openFileWithFilePathURL:_srcFile];
    [self initializeControls];
    //[self play];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[EZOutput sharedOutput] stopPlayback];
    [EZOutput sharedOutput].outputDataSource = nil;
    self.playFile.audioFileDelegate = nil;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return NO;
}

#pragma mark - Action Extensions
-(void)openFileWithFilePathURL:(NSURL*)filePathURL {
    [self.navigationController showHUD];
    // for audioPlot
    self.audioFile          = [EZAudioFile audioFileWithURL:filePathURL];
    _totalDuration          = self.audioFile.totalDuration;
    
    self.eof                = NO;
    //self.audioFile.audioFileDelegate      = self;
    self.audioPlot.plotType        = EZPlotTypeBuffer;//EZPlotTypeBuffer
    self.audioPlot.shouldFill      = YES;
    self.audioPlot.shouldMirror    = YES;
    [self.audioFile getWaveformDataWithCompletionBlock:^(float *waveformData, UInt32 length) {
        [self.audioPlot updateBuffer:waveformData withBufferSize:length];
    }];
    
    // for play Audio file
    // Set the client format from the EZAudioFile on the output
    self.playFile          = [EZAudioFile audioFileWithURL:filePathURL];
    self.playFile.audioFileDelegate      = self;
    [[EZOutput sharedOutput] setAudioStreamBasicDescription:self.playFile.clientFormat];
    //    [self play];
    
    // for draw full graph totalPlot
    // Plot the whole waveform
    self.totalfile = [EZAudioFile audioFileWithURL:filePathURL];
    self.totalPlot.plotType = EZPlotTypeBuffer;
    self.totalPlot.shouldFill = YES;
    self.totalPlot.shouldMirror = YES;
    [self.totalfile getWaveformDataWithCompletionBlock:^(float *waveformData, UInt32 length) {
        [self.totalPlot updateBuffer:waveformData withBufferSize:length];
        [self play];
        [self.navigationController hideHUD];
    }];
}

-(void)play {
    if( ![[EZOutput sharedOutput] isPlaying] ){
        if( self.eof ){
            [self.playFile seekToFrame:0];
            
        }
        [EZOutput sharedOutput].outputDataSource = self;
        [[EZOutput sharedOutput] startPlayback];
    }
    else {
        [EZOutput sharedOutput].outputDataSource = nil;
        [[EZOutput sharedOutput] stopPlayback];
    }
}

- (void) initializeControls {
    
    // set position of viewLeft
    CGRect frame1 = self.viewLeft.frame;
    _leftLimit = 20 - frame1.size.width / 2;
    self.leftViewLeadingConstraint.constant = MARGIN_VAL - frame1.size.width / 2;
    
    // set position of viewRight
    CGRect frame2 = self.viewRight.frame;
    
    
    //NSLog(@"total plot width %f",self.totalPlot.frame.size.width);
    
    //NSLog(@"super view width %f",self.view.frame.size.width);
    
    _rightLimit = self.view.frame.size.width - MARGIN_VAL - frame2.size.width / 2;
    self.rightViewLeadingConstraint.constant = self.view.frame.size.width - 20 - frame2.size.width / 2;
    
    
   // //NSLog(@"left leading constraint %f right leading constraint %f\n left limit %f right limit %f", self.leftViewLeadingConstraint.constant,self.rightViewLeadingConstraint.constant,_leftLimit,_rightLimit);
    
    
    
    // set position of viewPosition
    self.positionViewLeadingConstraint.constant = self.leftViewLeadingConstraint.constant;
    
    // adjust audioPlot frame
    _maxDistance = _rightLimit - _leftLimit;
    if (_totalDuration > 10) {
        _totalLength = ((double)_totalDuration / (double)10) * _maxDistance;
        _minDistance = _maxDistance / 10;
    }
    else {
        _totalLength = _maxDistance;
        _minDistance = _maxDistance / _totalDuration;
    }
    self.totalWidthConst.constant = _totalLength;
    
    
   // //NSLog(@"total width constraint %f",self.totalWidthConst.constant);
    
    // adjust scrollView
    CGSize contentSize = self.scrollView.bounds.size;
    contentSize.width = _totalLength + MARGIN_VAL * 2;
    self.scrollView.contentSize = contentSize;
    self.scrollView.delegate = self;
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = 0;
    self.scrollView.contentOffset = offset;
    
    // adjust button size and draw border;
    self.displayRange.layer.borderWidth = 1;
    self.displayRange.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // adjust controls
    [self adjustMinMaxFrames];
    
    
}

#pragma mark - Drag Drop controls
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    if (CGRectContainsPoint(self.viewLeft.frame, touchLocation)) {
        dragging = YES;
        oldX = touchLocation.x;
        window = _viewLeft;
        [[EZOutput sharedOutput] stopPlayback];
    }
    else if (CGRectContainsPoint(self.displayRange.frame, touchLocation)){
        dragging = YES;
        oldX = touchLocation.x;
        window = _displayRange;
        [[EZOutput sharedOutput] stopPlayback];
    }
    else if (CGRectContainsPoint(self.viewRight.frame, touchLocation)) {
        dragging = YES;
        oldX = touchLocation.x;
        window = _viewRight;
    }
    else if (CGRectContainsPoint(self.totalPlot.frame, touchLocation)) {
        dragging = YES;
        oldX = self.displayRangeLeadingConst.constant - self.displayRangeWidthConst.constant / 2;
        window = _totalPlot;
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    if (dragging) {
        CGRect frame = window.frame;
        float x = touchLocation.x - frame.size.width / 2;
        if (x < _leftLimit) {
            x =_leftLimit;
        }
        else if (x > _rightLimit) {
            x = _rightLimit;
        }
        if ([window isEqual:_viewLeft]) {
            if (_rightViewLeadingConstraint.constant - x < _minDistance) {
                x = _rightViewLeadingConstraint.constant - _minDistance;
            }
            _leftViewLeadingConstraint.constant = x;
        }
        else if ([window isEqual:_viewRight]) {
            if (x - _leftViewLeadingConstraint.constant < _minDistance) {
                x = _leftViewLeadingConstraint.constant + _minDistance;
            }
            _rightViewLeadingConstraint.constant = x;
        }
        else if ([window isEqual:_displayRange] || [window isEqual:_totalPlot]){
            float offsetX = self.scrollView.contentOffset.x + (touchLocation.x - oldX) * (double)self.totalWidthConst.constant / (double)self.view.frame.size.width;
            if (offsetX < 0)
            {
                offsetX = 0;
            }
            else if (offsetX > self.totalWidthConst.constant - _maxDistance){
                offsetX = self.totalWidthConst.constant - _maxDistance;
            }
            float offsetY = self.scrollView.contentOffset.y;
            self.scrollView.contentOffset = CGPointMake(offsetX, offsetY);
            oldX = touchLocation.x;
        }
        [self adjustMinMaxFrames];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    dragging = NO;
    if ([window isEqual:_viewLeft] || [window isEqual:_displayRange] || [window isEqual:_totalPlot])
    {
        [[EZOutput sharedOutput] startPlayback];
        [self.playFile seekToFrame:minFrame];
    }
    window = nil;
    oldX = 0;
    
}

- (void) adjustMinMaxFrames {
    float leftPos = _leftViewLeadingConstraint.constant + self.viewLeft.frame.size.width / 2 - MARGIN_VAL;
    float rightPos = _rightViewLeadingConstraint.constant + self.viewRight.frame.size.width / 2 - MARGIN_VAL;
    
    //NSLog(@"%f,%f",leftPos,rightPos);
    
    minFrame = (self.scrollView.contentOffset.x + leftPos) * (double)_totalfile.totalFrames / (double)self.totalWidthConst.constant;
    maxFrame = (self.scrollView.contentOffset.x + rightPos) * (double)_totalfile.totalFrames / (double)self.totalWidthConst.constant;
    if (minFrame < 0)
        minFrame = 0;
    if (maxFrame > self.totalfile.totalFrames)
        maxFrame = self.totalfile.totalFrames;
    //NSLog(@"minFrame: %lld maxFrame: %lld", minFrame, maxFrame);
    
    self.displayRangeLeadingConst.constant = minFrame * (double)self.view.frame.size.width / (double)self.totalfile.totalFrames;
    self.displayRangeWidthConst.constant = (maxFrame - minFrame) * (double)self.self.view.frame.size.width / (double)self.totalfile.totalFrames;
}

#pragma mark - EZAudioFileDelegate
-(void)audioFile:(EZAudioFile *)audioFile
       readAudio:(float **)buffer
  withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
    dispatch_async(dispatch_get_main_queue(), ^{
        //        if( [EZOutput sharedOutput].isPlaying ){
        //            if( self.audioPlot.plotType     == EZPlotTypeBuffer &&
        //               self.audioPlot.shouldFill    == YES              &&
        //               self.audioPlot.shouldMirror  == YES ){
        //                self.audioPlot.shouldFill   = NO;
        //                self.audioPlot.shouldMirror = NO;
        //            }
        //            [self.audioPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
        //        }
    });
}

-(void)audioFile:(EZAudioFile *)audioFile
 updatedPosition:(SInt64)framePosition {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setPosition:framePosition];
    });
}

- (void) setPosition :(SInt64)framePosition {
    if (framePosition >= maxFrame) {
        [self.playFile seekToFrame:minFrame];
        return;
    }
    
    float offsetPos = (framePosition - minFrame) * (double)self.totalWidthConst.constant / (double)_playFile.totalFrames;
    self.positionViewLeadingConstraint.constant = self.leftViewLeadingConstraint.constant + offsetPos + _viewLeft.frame.size.width / 2;
    
}

#pragma mark - EZOutputDataSource
-(void)output:(EZOutput *)output shouldFillAudioBufferList:(AudioBufferList *)audioBufferList withNumberOfFrames:(UInt32)frames
{
    if( self.playFile )
    {
        UInt32 bufferSize;
        [self.playFile readFrames:frames
                  audioBufferList:audioBufferList
                       bufferSize:&bufferSize
                              eof:&_eof];
        if( _eof )
        {
            [self.playFile seekToFrame:0];
        }
        
    }
}

-(AudioStreamBasicDescription)outputHasAudioStreamBasicDescription:(EZOutput *)output {
    return self.audioFile.clientFormat;
}

- (IBAction)onNext:(id)sender {
    SaveViewController * saveViewer = [self.storyboard instantiateViewControllerWithIdentifier:@"SaveView"];
    saveViewer.srcFile = _srcFile;
    float startMarker = ((double) minFrame / (double)_audioFile.totalFrames) * _audioFile.totalDuration;
    float endMarker = ((double) maxFrame / (double)_audioFile.totalFrames) * _audioFile.totalDuration;
    saveViewer.startMarker = startMarker;
    saveViewer.endMarker = endMarker;
    [self.navigationController pushViewController:saveViewer animated:YES];
    
}

#pragma scrollview delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self adjustMinMaxFrames];
    [[EZOutput sharedOutput] startPlayback];
    [self.playFile seekToFrame:minFrame];
//    //NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[EZOutput sharedOutput] stopPlayback];
    [self adjustMinMaxFrames];
//    //NSLog(@"scrollViewDidScroll");
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    //NSLog(@"scrollViewEndDragging");
    [self adjustMinMaxFrames];
    [[EZOutput sharedOutput] startPlayback];
    [self.playFile seekToFrame:minFrame];
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
