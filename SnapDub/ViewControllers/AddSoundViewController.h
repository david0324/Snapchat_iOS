//
//  AddSoundViewController.h
//  SnapDub
//
//  Created by Poland on 07/05/15.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "Define.h"

#define kAudioFile @"tempaudio"

@interface AddSoundViewController : UIViewController<MPMediaPickerControllerDelegate, UIImagePickerControllerDelegate>
@property (assign, nonatomic) MediaType selectedMediaType;
@property (strong, nonatomic) NSString* selectedMediaURL;

- (IBAction)onMusicPick:(id)sender;

- (IBAction)onGalleryPick:(id)sender;
@end


