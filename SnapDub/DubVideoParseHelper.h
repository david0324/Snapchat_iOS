//
//  DubVideoParseHelper.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-04-30.
//
//

#import <Foundation/Foundation.h>

@class DubVideo;
@interface DubVideoParseHelper : NSObject

+(void) GetIsADubVideoLikedByCurrentUser: (PFObject*) videoObject policy: (PFCachePolicy) policy  block: (void (^)(BOOL result))completionBlock;
+(void) GetAllDubVideoCreatedOrLikedByAUserInBackground: (PFUser*) user cachePolicy: (PFCachePolicy) policy  limitPerPage: (int) limit pageNum: (int) pageNum block: (void (^)(NSArray* results, NSError *error))completionBlock;
+(void) GetAllDubVideoCreatedByAUserInBackground: (PFUser*) user policy: (PFCachePolicy) policy  limitPerPage: (int) limit pageNum: (int) pageNum block: (void (^)(NSArray* results, NSError *error))completionBlock;

+(void) GetAllDubVideosLikedByAUserInBackground: (PFUser*) user policy: (PFCachePolicy) policy imitPerPage: (int) limit pageNum: (int) pageNum block: (void (^)(NSArray* results, NSError *error))completionBlock;

+(void) SaveADubVideoCreatedByCurrentUserEventuallyWithBlock: (DubVideo*) video block: (void (^)(BOOL , NSError *))completionBlock;
+(void) IncreaseNumLikeOfADubVideo: (PFObject*) videoObject byAmount: (int) amount;
+(void) LikeADubVideoInBackground: (PFObject*) videoObject;
+(void) UnlikeADubVideoInBackground: (PFObject*) videoObject;
+(void) getAllDubVideoRelatedToADubSound: (PFObject*) soundObject block: (void (^)(NSArray* results, NSError *error))completionBlock;

+(void) GetCommentsOfADubVideoInBackground:(PFObject*) videoObject policy: (PFCachePolicy) policy  limitPerPage: (int) limit pageNum: (int) pageNum block: (void (^)(NSArray* results, NSError *error))completionBlock;
+(void) SaveACommentToADubVideoEventually: (PFObject*) videoObject comment: (NSString*) comment;

+(void) GetNumLikesOfAVideoInBackground: (PFObject*) videoObject policy: (PFCachePolicy) policy block: (void (^)(int result, NSError *error))completionBlock;

+(void) GetNumCommentsOfAVideoInBackground: (PFObject*) videoObject policy: (PFCachePolicy) policy block: (void (^)(int result, NSError *error))completionBlock;
@end
