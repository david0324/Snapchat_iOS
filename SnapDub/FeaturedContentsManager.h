//
//  FeaturedContentsManager.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-26.
//
//

#import <Foundation/Foundation.h>

@interface FeaturedContentsManager : NSObject

+(void) GetAllCategories: (void (^)(NSArray* , NSError *))completionBlock;
+(void) GetFeaturedSoundsForFrontPageInBackground: (void (^)(NSArray* , NSError *))completionBlock;

+(void) GetFeatureSoundBoardsForFrontPageInBackground: (void (^)(NSArray* , NSError *))completionBlock;

+(void) GetFeaturedSoundsOfACategory:(PFObject*) categoryObject cachePolicy:(PFCachePolicy) policy block:(void (^)(NSArray* , NSError *))completionBlock;
@end
