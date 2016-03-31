//
//  DubUserActivityParseHelper.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-04-30.
//
//

#import "DubUserActivityParseHelper.h"
#import "SDConstants.h"
#import "GeneralUtility.h"
#import "DubSound.h"
#import "DubVideo.h"
#import "UserActivity.h"
#import "DubUser.h"

@implementation DubUserActivityParseHelper


+(void) GetLatestListOfUsers:(PFCachePolicy) policy block: (void (^)(NSArray* users, NSError *error))completionBlock
{
   
}

+(void) GetAllActivityOfAllFollowingUsers: (int) limit pageNum: (int) pageNum cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* results, NSError *error))completionBlock
{
   
}

+(void) GetUserLikedVideoAndSound:(PFUser*) userObject limit: (int) limit pageNum: (int) pageNum cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* results, NSError *error))completionBlock
{
   
}


+(void) GetNumLikedItemsOfAUserInBackground:(PFUser*) userObject cachePolicy: (PFCachePolicy) policy block: (void (^)(int numFollower, NSError *error))completionBlock
{
    }

+(void) GetUserPostedVideoAndSound:(PFUser*) userObject limit: (int) limit pageNum: (int) pageNum cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* results, NSError *error))completionBlock
{
    
}

+(void) GetNumTotalVideoAndSoundsPostedByAUserInBackground:(PFUser*) userObject cachePolicy: (PFCachePolicy) policy block: (void (^)(int numFollower, NSError *error))completionBlock
{

}

+(void) LoadCurrentUserInfoFromParseInBackground
{
    
}

+(void) SetUpPFAnonymousUtilsIfNotLoggedIn
{
    if(![[PFUser currentUser] isAuthenticated])
    {
        [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
            if (error) {
                //NSLog(@"Anonymous login failed.");
            } else {
                //NSLog(@"Anonymous user logged in.");
            }
        }];
    }
}

+(void) GetNumFollowerInBackground: (PFUser*) userObject cachePolicy: (PFCachePolicy) policy block: (void (^)(int numFollower, NSError *error))completionBlock
{

}

+(void) GetNumFollowingInBackground: (PFUser*) userObject cachePolicy: (PFCachePolicy) policy block: (void (^)(int numFollower, NSError *error))completionBlock
{

}

+ (void)FollowUserEventually:(PFUser *)userObject {

    
    //[[PAPCache sharedCache] setFollowStatus:YES user:user];
}

+ (void) UnfollowUserEventually:(PFUser *)userObject {
    
   
}

+(void) GetAllFollowingActivitiesOfCurrentUserInBackground: (BOOL) fromLocalDatastore lock: (void (^)(NSArray* results, NSError *error))completionBlock
{

}

+(void) GetAllActivityOfAUserInBackground: (PFUser*) userObject fromLocalDataStore:(BOOL) fromLocalDatastore block: (void (^)(NSArray* results, NSError *error))completionBlock
{
    }

+(void) GetAllFollowingUsersOfAUserInBackground: (PFUser*) userObject pageLimit: (int) limit pageNum:(int) pageNum cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* results, NSError *error))completionBlock
{
    
}

+(void) GetAllUsersThatFollowAUserInBackground: (PFUser*) userObject pageLimit: (int) limit pageNum:(int) pageNum cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* results, NSError *error))completionBlock
{
   
}

@end
