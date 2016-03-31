//
//  DubSoundAndSoundBoardParseHelper.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-04-29.
//
//

#import <Foundation/Foundation.h>

@class DubSound, DubSoundBoard;
@interface DubSoundParseHelper : NSObject
+(void) GetDubSoundFromObjectId: (NSString*) objectId policy: (PFCachePolicy) policy block: (void (^)(DubSound* sound, NSError *error))completionBlock;

+(void) SaveADubSoundCreatedByCurrentUserInBackground: (DubSound*) sound block: (void (^)(BOOL result, NSError *error))completionBlock;

+(void) GetAllDubSoundsLikedByAUserInBackground: (PFUser*) user cachePolicy: (PFCachePolicy) policy limitPerPage: (int) limit pageNum: (int) pageNum block: (void (^)(NSArray* results, NSError *error))completionBlock;
+(void) GetAllDubSoundsCreatedByAUserInBackground: (PFUser*) user cachePolicy: (PFCachePolicy) policy limitPerPage: (int) limit pageNum: (int) pageNum block: (void (^)(NSArray* results, NSError *error))completionBlock;

+(void) LikeADubSound: (PFObject*) soundObject;
+(void) UnlikeADubSound: (PFObject*) soundObject;



+(void) GetAllDubSoundsOrderByScoreInBackground: (PFCachePolicy) policy limitPerPage: (int) limit pageNum: (int) pageNum block: (void (^)(NSArray* results, NSError *error))completionBlock;
@end
