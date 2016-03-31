//
//  DubSoundCreator.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-18.
//
//

#import "DubSoundCreator.h"
#import "GeneralUtility.h"
#import "DubSound.h"
#import "DubCategory.h"

@implementation DubSoundCreator
static NSString* soundName;
static NSData* soundData;
static NSString* Language;
static NSArray* tags;
static NSString* localDataFilePath;
static DubCategory* category;
static float duration;
static NSString* offlineFileName;

+(void) resetData
{
    soundName = nil;
    soundData = nil;
    Language= nil;
    tags = nil;
    localDataFilePath = nil;
    category = nil;
    duration = 0;
    offlineFileName= nil;
}

+(void) setOfflineFileName: (NSString*) m
{
    offlineFileName = m;
}

+(void) setDuration: (float) m
{
    duration = m;
}

+(void) setCategory: (DubCategory*) m
{
    category = m;
}

+(void) setLocalDataFilePath: (NSString*) file
{
    localDataFilePath = file;
}
+(void) setSoundName: (NSString*) name
{
    soundName = name;
}

+(void) setSoundData: (NSData*) data
{
    soundData = data;
}

+(void) setLanguage: (NSString*) theLanguage
{
    Language = theLanguage;
}

+(void) setTags: (NSArray*) array
{
    tags = [NSArray arrayWithArray: array];
}

+(void) CreateADubSoundByCurrentUserInBackground:(void(^)(BOOL result, NSError* error)) completeBlock
{
   
}

@end
