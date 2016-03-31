//
//  DubAudioPlayer.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-06-02.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol DubAudioPlayerDelegate <NSObject>

-(void) audioBeingPlayed: (AVAudioPlayer*) player;
-(void) audioPaused: (AVAudioPlayer*) player;
-(void) audioBeingLoaded: (AVAudioPlayer*) player;
@end


@interface DubAudioPlayer : NSObject<AVAudioPlayerDelegate>
{
    AVAudioPlayer *audioPlayer;
    NSObject<DubAudioPlayerDelegate>* delegate;
}
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) NSObject<DubAudioPlayerDelegate>* delegate;

+(DubAudioPlayer*) ShareInstance;
-(void) playAudioFromAPFFile: (PFFile*) theFilel;
-(void) pauseAudio;
@end


