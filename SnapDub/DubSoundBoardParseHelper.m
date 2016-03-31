//
//  DubSoundBoardParseHelper.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-19.
//
//

#import "DubSoundBoardParseHelper.h"
#import "SDConstants.h"
#import "GeneralUtility.h"
#import "DubSound.h"
#import "SDFilesNeededToBeUploaded.h"
#import "DubSoundBoard.h"
#import "GeneralUtility.h"

@implementation DubSoundBoardParseHelper



+(void) GetAllDubSoundBoardsCreatedByAUserInBackground: (PFUser*) user policy: (PFCachePolicy) policy  block: (void (^)(NSArray* results, NSError *error))completionBlock
{
   
}

+(void) GetAllDubSoundboardsAUserFollowsInBackground: (PFUser*) theUser policy: (PFCachePolicy) policy block: (void (^)(NSArray* results, NSError *error))completionBlock
{
  
}

+(void) GetAllDubSoundsInADubSoundBoardInBackground: (PFObject*) soundBoardObject cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* results, NSError *error))completionBlock
{
  
}

+(void) FollowADubSoundBoard: (PFObject*) soundBoardObject
{
    
}

+(void) UnfollowADubSoundBoard: (PFObject*) soundBoardObject
{
   }

+(void) SaveADubSoundBoardToParseInBackgroundWithBlock: (DubSoundBoard*) sounbBoard block: (void (^)(BOOL result, NSError* error)) completionBlock
{
    
    
    
}

//TODO: add the cache logic!
+(void) AddADubSoundToADubSoundBoardEventuallyWithBlock: (DubSound*) sound soundBoard: (DubSoundBoard*) soundBoard block: (void (^)(BOOL result, NSError* error)) completionBlock
{
    
}

@end
