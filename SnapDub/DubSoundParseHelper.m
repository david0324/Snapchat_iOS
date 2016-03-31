//
//  DubSoundAndSoundBoardParseHelper.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-04-29.
//
//

#import "DubSoundParseHelper.h"
#import "SDConstants.h"
#import "GeneralUtility.h"
#import "DubSound.h"
#import "SDFilesNeededToBeUploaded.h"
#import "DubSoundBoard.h"
#import "GeneralUtility.h"

@implementation DubSoundParseHelper

+(void) GetDubSoundFromObjectId: (NSString*) objectId policy: (PFCachePolicy) policy block: (void (^)(DubSound* sound, NSError *error))completionBlock
{

}

+(void) SaveADubSoundCreatedByCurrentUserInBackground: (DubSound*) sound block: (void (^)(BOOL result, NSError *error))completionBlock{
  
}

+(void) GetAllDubSoundsLikedByAUserInBackground: (PFUser*) user cachePolicy: (PFCachePolicy) policy limitPerPage: (int) limit pageNum: (int) pageNum block: (void (^)(NSArray* results, NSError *error))completionBlock
{

}
+(void) GetAllDubSoundsCreatedByAUserInBackground: (PFUser*) user cachePolicy: (PFCachePolicy) policy limitPerPage: (int) limit pageNum: (int) pageNum block: (void (^)(NSArray* results, NSError *error))completionBlock
{
  
}

+(void) LikeADubSound: (PFObject*) soundObject
{

}

+(void) UnlikeADubSound: (PFObject*) soundObject
{

}

+(void) GetAllDubSoundsOrderByScoreInBackground: (PFCachePolicy) policy limitPerPage: (int) limit pageNum: (int) pageNum block: (void (^)(NSArray* results, NSError *error))completionBlock
{

}

-(void) RemoveADubSoundFromADubSoundBoardEventually: (DubSound*) sound soundBoard: (DubSoundBoard*) soundBoard
{
    
}

//Implement this
+(void) getAllFeatureDubSoundsInBackground: (void (^)(NSArray* results, NSError *error))completionBlock
{
    
}

//Implement this
+(void) getAllFeaturedDubSoundboardsInBackground: (void (^)(NSArray* results, NSError *error))completionBlock
{
    
}

//Implement this, easy
+(void) getAllCommentsOfASoundboardInBackgroundwithPageLimit: (int) limit pageNum: (int) page block: (void (^)(NSArray* results, NSError *error))completionBlock
{
    
}


@end
