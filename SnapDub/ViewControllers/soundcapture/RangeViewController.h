//
//  RangeViewController.h
//  SnapDub
//
//  Created by Infinidy_jiawei on 2015-05-26.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZAudio.h"

#define MARGIN_VAL 20

@interface RangeViewController : UIViewController <EZAudioFileDelegate,EZOutputDataSource, UIScrollViewDelegate>
{
    UIImageView* tutorialView;
}
#pragma mark - Components

// for audioPlot
@property (nonatomic,strong) EZAudioFile *audioFile;
@property (nonatomic,weak) IBOutlet EZAudioPlot *audioPlot;

// for totalPlot
@property (nonatomic, strong) EZAudioFile *totalfile;
@property (strong, nonatomic) IBOutlet EZAudioPlot *totalPlot;

// for play audiofile
@property (nonatomic, strong) EZAudioFile *playFile;
/**
 A BOOL indicating whether or not we've reached the end of the file
 */
@property (nonatomic,assign) BOOL eof;
@property (weak, nonatomic) IBOutlet UIImageView *viewPosition;

@property (weak, nonatomic) IBOutlet UIImageView *viewRight;
@property (nonatomic, strong) NSURL *srcFile;
@property (weak, nonatomic) IBOutlet UIImageView *viewLeft;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftViewLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *positionViewLeadingConstraint;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightViewLeadingConstraint;
- (IBAction)onNext:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *displayRange;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *displayRangeWidthConst;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *displayRangeLeadingConst;
- (IBAction)back:(id)sender;

@end
