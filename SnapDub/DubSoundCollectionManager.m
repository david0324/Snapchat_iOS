//
//  DubSoundCollectionManager.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-01.
//
//

#import "DubSoundCollectionManager.h"
#import "DubSoundParseHelper.h"
#import "SDConstants.h"
#import "DubSound.h"
#import "DubUser.h"
#import "SDFilesNeededToBeUploaded.h"
#import "GeneralUtility.h"

@implementation DubSoundCollectionManager
@synthesize userCreatedDubVideos, userLikedDubVideos, owner;

-(id) init
{
    if(self == [super init])
    {
        userCreatedDubSounds = [NSMutableArray array];
        userLikedDubSounds = [NSMutableArray array];
    }
    return self;
}
-(id) initWithPFUser: (DubUser*) m
{
    self = [self init];
    owner = m;
    
    return self;
}

-(void) loadOwnerCreatedSoundsFromParseInBackground:(PFCachePolicy) policy block:(void (^)(NSArray* , NSError *))completionBlock
{

}

-(void) loadOwnerLikedSoundsFromParseInBackground:(PFCachePolicy) policy block: (void (^)(NSArray* , NSError *))completionBlock
{

}

-(void) loadAllInfoFromParseInBackground:(PFCachePolicy) policy block:(void (^)(NSArray* userCreatedSounds, NSArray* userLikedSounds, NSError *error))completionBlock
{

}

//TODO: add Parse codes
-(void) addDubSoundToUserLikedSounds:(DubSound*) sound
{

}

-(void) removeDubSoundToUserLikedSounds:(DubSound*) sound
{

}

-(BOOL) isDubSoundLikedByUser: (DubSound*) sound
{

    return NO;
}

//TODO: add Parse codes
-(void) addDubSoundToUserCreatedDubSounds:(DubSound*) sound
{
    if(![userCreatedDubSounds containsObject: sound])
    {
        [userCreatedDubSounds addObject:sound];
    }
}

//TODO: Need to change it to real data later
+(void) createADubSoundWithFileName: (NSString*) fileName block:(void (^)(DubSound* result , NSError* error))completionBlock
{
    fileName = [NSString stringWithFormat:@"%@_%@", [GeneralUtility uuid], fileName];
    NSString* imageName = [[NSBundle mainBundle] pathForResource:@"justin1" ofType:@"png"];
    UIImage* imageToSave = [UIImage imageWithContentsOfFile: imageName];
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSData * binaryImageData = UIImagePNGRepresentation(imageToSave);
    
    NSString* filePath = [basePath stringByAppendingPathComponent: fileName ];
    [binaryImageData writeToFile:filePath atomically:YES];
    
    DubSound* sound = [[DubSound alloc] init];
    sound.offlineFileName = fileName;
    
    [sound saveSoundToParseInBackgrountWithBlock:^(BOOL result, NSError * error) {
        //NSLog(@"Saving Sound result is %d", result);
        
        if(completionBlock)
            completionBlock(sound, error);
    }];
}



@end
