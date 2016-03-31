//
//  DubFeaturedContentsParseHelper.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-20.
//
//

#import <Foundation/Foundation.h>

@interface DubFeaturedContentsParseHelper : NSObject

+(void) GetAllCategories:(PFCachePolicy) policy block: (void (^)(NSArray* , NSError *))completionBlock;

+(void) GetFeaturedSoundsForFrontPageInBackground:(PFCachePolicy) policy block: (void (^)(NSArray* , NSError *))completionBlock;

+(void) GetFeatureSoundBoardsForFrontPageInBackground:(PFCachePolicy) policy block: (void (^)(NSArray* , NSError *))completionBlock;

+(void) GetFeaturedSoundsOfACategoryInBackground:(PFObject*) category cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* , NSError *))completionBlock;

+(void) GetTopDubSoundsFromACategory: (PFObject*) categoryObject limit: (int) limit pageNum:(int) page cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* , NSError *))completionBlock;

+(void) GetTopDubVideosFromACategory: (PFObject*) categoryObject limit: (int) limit pageNum:(int) page cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* , NSError *))completionBlock;

+(void) GetRecentDubSoundsFromACategory: (PFObject*) categoryObject limit: (int) limit pageNum:(int) page cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* , NSError *))completionBlock;

+(void) GetRecentDubVideosFromACategory: (PFObject*) categoryObject limit: (int) limit pageNum:(int) page cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* , NSError *))completionBlock;

+(void) GetFeaturedVideoFromACategory: (PFObject*) category cachePolicy:(PFCachePolicy) policy limit:(int) limit pageNum: (int) pageNum block: (void (^)(NSArray* , NSError *))completionBlock;
@end
