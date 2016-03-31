//
//  DubUser.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-04-30.
//
//

#import <Foundation/Foundation.h>


@class DubSoundCollectionManager, DubVideoCollectionManager, DubSoundBoardCollectionManager;
@interface DubUser : NSObject
{
    int dubsSoundPlayCount;
    int dubsVideoPlayCount;
    int dubsLikeCount;
    int numFollower;
    int numFollowing;
    
    DubSoundCollectionManager* dubSoundCollectionManager;
    DubVideoCollectionManager* dubVideoCollectionManager;
    DubSoundBoardCollectionManager* dubSoundboardCollectionManager;
    PFUser* connectedParseObject;
    
    NSString* profileName;
    PFFile* profileImagePFFile;
    
    NSMutableDictionary* followingUsersIdList;
    NSMutableDictionary* followingSoundBoardIdList;
    NSMutableDictionary* likedSoundsIdList;
    NSMutableDictionary* likedVideoIdList;
}

@property (nonatomic, assign) int dubsPlayCount;
@property (nonatomic, assign) int dubsLikeCount;
@property (nonatomic, assign) int numFollower;

@property (nonatomic, strong) DubSoundCollectionManager* dubSoundCollectionManager;
@property (nonatomic, strong) DubVideoCollectionManager* dubVideoCollectionManager;
@property (nonatomic, strong) DubSoundBoardCollectionManager* dubSoundboardCollectionManager;
@property (nonatomic, strong) PFUser* connectedParseObject;

@property (nonatomic, strong) NSString* profileName;
@property (nonatomic, strong) PFFile* profileImagePFFile;

@property (nonatomic, strong) NSMutableDictionary* followingUsersIdList;
@property (nonatomic, strong) NSMutableDictionary* followingSoundBoardIdList;
@property (nonatomic, strong) NSMutableDictionary* likedSoundsIdList;
@property (nonatomic, strong) NSMutableDictionary* likedVideoIdList;

+(DubUser*) CurrentDubUser;

+(DubUser*) getARandomUser;
+(void) initUserLists: (void (^)(BOOL result))completionBlock;
-(BOOL) isCurrentDubUser;
+(void) loadCurrentUserSoundboardInfoFromParseWithBlock: (void (^)(BOOL result, NSError *error))completionBlock;
+(void) loadCurrentUserInBackgroundWithBlock:(PFCachePolicy) policy block: (void (^)(BOOL result, NSError *error))completionBlock;
+(void) SignupUserWithBlock: (void (^)(BOOL result, NSError *error))completionBlock;

-(void) loadSoundCollectionManagerUserLikedSoundsFromParseWithBlock:(void (^)(NSArray* result, NSError *error))completionBlock;
-(void) loadSoundCollectionManagerContentsFromParseWithBlock:(void (^)(NSArray* result, NSError *error))completionBlock;

-(void) loadVideoCollectionManagerContentsFromParseWithBlock:(void (^)(NSArray* result, NSError *error))completionBlock;
-(void) loadVideoCollectionManagerUserLikedVideosFromParseWithBlock:(void (^)(NSArray* result, NSError *error))completionBlock;
-(BOOL) isTheSameUser: (DubUser*) another;
-(BOOL) isFollowedByCurrentUser;
-(void) follow;
-(void) unfollow;
@end
