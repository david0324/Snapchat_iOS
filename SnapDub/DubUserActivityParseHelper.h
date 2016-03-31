//
//  DubUserActivityParseHelper.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-04-30.
//
//

#import <Foundation/Foundation.h>

@interface DubUserActivityParseHelper : NSObject

+(void) GetLatestListOfUsers:(PFCachePolicy) policy block: (void (^)(NSArray* users, NSError *error))completionBlock;
+(void) GetAllActivityOfAllFollowingUsers: (int) limit pageNum: (int) pageNum cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* results, NSError *error))completionBlock;
+ (void)FollowUserEventually:(PFUser *)userObject;
+ (void) UnfollowUserEventually:(PFUser *)userObject;
+(void) GetAllActivityOfAUserInBackground: (PFUser*) userObject fromLocalDataStore:(BOOL) fromLocalDatastore block: (void (^)(NSArray* results, NSError *error))completionBlock;

+(void) GetAllFollowingUsersOfAUserInBackground: (PFUser*) userObject pageLimit: (int) limit pageNum:(int) pageNum cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* results, NSError *error))completionBlock;

+(void) GetAllUsersThatFollowAUserInBackground: (PFUser*) userObject pageLimit: (int) limit pageNum:(int) pageNum cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* results, NSError *error))completionBlock;

+(void) GetAllFollowingActivitiesOfCurrentUserInBackground: (BOOL) fromLocalDatastore lock: (void (^)(NSArray* results, NSError *error))completionBlock;

+(void) GetNumFollowerInBackground: (PFUser*) userObject cachePolicy: (PFCachePolicy) policy block: (void (^)(int numFollower, NSError *error))completionBlock;
+(void) GetNumFollowingInBackground: (PFUser*) userObject cachePolicy: (PFCachePolicy) policy block: (void (^)(int numFollower, NSError *error))completionBlock;

+(void) GetNumTotalVideoAndSoundsPostedByAUserInBackground:(PFUser*) userObject cachePolicy: (PFCachePolicy) policy block: (void (^)(int numFollower, NSError *error))completionBlock;
+(void) GetNumLikedItemsOfAUserInBackground:(PFUser*) userObject cachePolicy: (PFCachePolicy) policy block: (void (^)(int numFollower, NSError *error))completionBlock;

+(void) GetUserPostedVideoAndSound:(PFUser*) userObject limit: (int) limit pageNum: (int) pageNum cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* results, NSError *error))completionBlock;
+(void) GetUserLikedVideoAndSound:(PFUser*) userObject limit: (int) limit pageNum: (int) pageNum cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* results, NSError *error))completionBlock;

+(void) GetNumFollowersOfAuserInBackground: (PFUser*) userObject pageLimit: (int) limit pageNum:(int) pageNum cachePolicy: (PFCachePolicy) policy block: (void (^)(int result, NSError *error))completionBlock;
@end
