//
//  DMVideoPreviewViewController.h
//  Dubsmash
//
//  Created by Altair on 4/28/15.
//  Copyright (c) 2015 Altair. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"
#import "GPUImageMovieComposition.h"
#import "GPUImageMovieWriter.h"

@class DubSound;
@interface DMVideoPreviewViewController : UIViewController<UITextFieldDelegate>
{
    
}
@property (nonatomic, retain) IBOutlet UIView *videoPlayingView;
@property (nonatomic, retain) IBOutlet UIButton *muteButton;
@property (nonatomic, retain) IBOutlet UITextField *titleTxt;
@property (nonatomic, retain) IBOutlet UILabel *titleMark;
@property (nonatomic, retain) IBOutlet UIView *titleTxtView;

@property (nonatomic, retain) NSString* soundFilePath;
@property (nonatomic, retain) DubSound* connectedDubSound;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (void) playMedia;
- (void) stopMedia;
@end
