//
//  DubAudioPlayer.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-06-02.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "DubAudioPlayer.h"
#import "SDConstants.h"

@implementation DubAudioPlayer
@synthesize audioPlayer, delegate;
static DubAudioPlayer* thePlayer;

+(DubAudioPlayer*) ShareInstance
{
    if(!thePlayer)
    {
        thePlayer = [[DubAudioPlayer alloc] init];
     //   audioPlayer.delegate = self;
    }
    
    return thePlayer;
}

-(void) setDelegate:(NSObject<DubAudioPlayerDelegate> *)newdelegate
{
    [self pauseAudio];
    if (newdelegate!=delegate) {
        
        delegate = newdelegate;
        [delegate audioPaused: audioPlayer];
    }
}

-(void) playAudioFromAPFFile: (PFFile*) theFile
{
    [delegate audioBeingLoaded: audioPlayer];
    [theFile getDataInBackgroundWithBlock:^(NSData *soundData, NSError *error) {
        
        if (!error) {
            [delegate audioBeingPlayed: audioPlayer];
            NSError *error2;
            audioPlayer = [[AVAudioPlayer alloc] initWithData:soundData error:&error2];
            audioPlayer.delegate = self;
            
            if(error2)
            {
                //NSLog(@"ERROR Playing Audio: %@", error2);
            }
            audioPlayer.volume = 1.0f;
            [audioPlayer play];
        }
    }];
}

-(void) pauseAudio
{
    [audioPlayer stop];
    [self.delegate audioPaused: audioPlayer];
}

-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [delegate audioPaused: audioPlayer];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_SOUND_FINISH_PLAYING object:nil];
}




@end
