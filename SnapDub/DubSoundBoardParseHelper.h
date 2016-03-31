//
//  DubSoundBoardParseHelper.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-19.
//
//

#import <Foundation/Foundation.h>

@class DubSoundBoard, DubSound;
@interface DubSoundBoardParseHelper : NSObject

+(void) GetAllDubSoundboardsAUserFollowsInBackground: (PFUser*) theUser policy: (PFCachePolicy) policy block: (void (^)(NSArray* results, NSError *error))completionBlock;
+(void) AddADubSoundToADubSoundBoardEventuallyWithBlock: (DubSound*) sound soundBoard: (DubSoundBoard*) soundBoard block: (void (^)(BOOL result, NSError* error)) completionBlock;

+(void) SaveADubSoundBoardToParseInBackgroundWithBlock: (DubSoundBoard*) sounbBoard block: (void (^)(BOOL result, NSError* error)) completionBlock;
+(void) UnfollowADubSoundBoard: (PFObject*) soundBoardObject;
+(void) FollowADubSoundBoard: (PFObject*) soundBoardObject;

+(void) GetAllDubSoundBoardsCreatedByAUserInBackground: (PFUser*) user policy: (PFCachePolicy) policy  block: (void (^)(NSArray* results, NSError *error))completionBlock;

+(void) GetAllDubSoundsInADubSoundBoardInBackground: (PFObject*) soundBoardObject cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* results, NSError *error))completionBlock;
@end
