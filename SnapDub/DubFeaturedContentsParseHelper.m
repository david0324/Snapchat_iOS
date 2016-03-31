//
//  DubFeaturedContentsParseHelper.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-20.
//
//

#import "DubFeaturedContentsParseHelper.h"
#import "SDConstants.h"
#import "GeneralUtility.h"
#import "DubSound.h"
#import "DubVideo.h"
#import "SDFilesNeededToBeUploaded.h"
#import "DubSoundBoard.h"
#import "GeneralUtility.h"

@implementation DubFeaturedContentsParseHelper

+(void) GetAllCategories:(PFCachePolicy) policy block: (void (^)(NSArray* , NSError *))completionBlock
{
    PFQuery* query = [PFQuery queryWithClassName: kSDCategoryClassName];
    [query orderByDescending: kSDOrderValue];
    [query setCachePolicy: policy];
    [query findObjectsInBackgroundWithBlock: completionBlock];
}

+(void) GetFeaturedSoundsForFrontPageInBackground:(PFCachePolicy) policy block: (void (^)(NSArray* , NSError *))completionBlock
{
    PFQuery* query = [PFQuery queryWithClassName: kSDFeaturedSoundClassName];
    [query orderByDescending: kSDOrderValue];
    [query includeKey: kSDFeaturedSoundDubSoundRefKey];
    [query includeKey: [NSString stringWithFormat:@"%@.%@",kSDFeaturedSoundDubSoundRefKey, kSDDubSoundCreatorKey ]];
    [query setCachePolicy: policy];
    [query findObjectsInBackgroundWithBlock: completionBlock];
}

+(void) GetFeatureSoundBoardsForFrontPageInBackground:(PFCachePolicy) policy block: (void (^)(NSArray* , NSError *))completionBlock
{
    PFQuery* query = [PFQuery queryWithClassName: kSDFeaturedSoundboardClassName];
    [query orderByDescending: kSDOrderValue];
    [query includeKey: kSDFeaturedSoundboardDubSoundboardRefKey];
    [query includeKey: [NSString stringWithFormat:@"%@.%@",kSDFeaturedSoundboardDubSoundboardRefKey, kSDDubSoundboardCreatorKey ]];
    [query setCachePolicy: policy];
    [query findObjectsInBackgroundWithBlock: completionBlock];
}

+(void) GetFeaturedSoundsOfACategoryInBackground:(PFObject*) category cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* , NSError *))completionBlock
{

}

+(void) GetTopDubSoundsFromACategory: (PFObject*) categoryObject limit: (int) limit pageNum:(int) page cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* , NSError *))completionBlock
{

}

+(void) GetTopDubVideosFromAllCategoryWithLimit: (int) limit pageNum:(int) page cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* , NSError *))completionBlock
{
    
}

+(void) GetTopDubVideosFromACategory: (PFObject*) categoryObject limit: (int) limit pageNum:(int) page cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* , NSError *))completionBlock
{
   
}

+(void) GetRecentDubSoundsFromACategory: (PFObject*) categoryObject limit: (int) limit pageNum:(int) page cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* , NSError *))completionBlock
{

}

+(void) GetRecentDubVideosFromACategory: (PFObject*) categoryObject limit: (int) limit pageNum:(int) page cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* , NSError *))completionBlock
{

}


+(void) GetFeaturedVideoFromACategory: (PFObject*) category cachePolicy:(PFCachePolicy) policy limit:(int) limit pageNum: (int) pageNum block: (void (^)(NSArray* , NSError *))completionBlock
{

}


@end
