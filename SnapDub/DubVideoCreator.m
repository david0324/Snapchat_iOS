//
//  DubVideoCreator.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-18.
//
//

#import "DubVideoCreator.h"
#import "DubSound.h"
#import "GeneralUtility.h"
#import "DubUser.h"
#import "DubVideo.h"
#import "DubCategory.h"
#import "DubCategory.h"

@implementation DubVideoCreator
static NSString* videoName;
static NSString* description;
static NSData* videoData;
static DubSound* soundRef;
static float duration;
static DubCategory* category;
//new
static PFFile *imageFile;

+(void) resetData
{
    videoName = @"";
    description=@"";
    videoData = nil;
    soundRef = nil;
    duration = 0;
    category = nil;
    //new
    imageFile = nil;
}

+(void) setDubCategory: (DubCategory*) m
{
    category = m;
}

+(void) setDuration: (float) m
{
    duration = m;
}

+(void) setVideoName: (NSString*) name
{
    videoName = name;
}

+(void) setDescription: (NSString*) des
{
    description = des;
}

+(void) setVideoData: (NSData*) data
{
    videoData = data;
}

+(void) setDubSoundRef: (DubSound*) ref
{
    soundRef = ref;
    [self setDuration: ref.duration];
}



//new
+(void) setPreviewImageFile:(PFFile *)image{
    //NSLog(@"setPreviewImageFile");
    imageFile = image;
}

+(BOOL) createADubVideoByCurrentUser
{
    

    return YES;
}

@end
