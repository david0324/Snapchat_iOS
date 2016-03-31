//
//  HomeViewController.h
//  SnapDub
//
//  Created by Infinidy_jiawei on 2015-05-26.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "Define.h"

#define kAudioFile @"tempaudio"

@interface HomeViewController : UIViewController <MPMediaPickerControllerDelegate, UIImagePickerControllerDelegate>
@property (assign, nonatomic) MediaType selectedMediaType;
@property (strong, nonatomic) NSString* selectedMediaURL;

- (IBAction)MusicPick:(id)sender;

- (IBAction)GalleryPick:(id)sender;


- (IBAction)back:(id)sender;


@end