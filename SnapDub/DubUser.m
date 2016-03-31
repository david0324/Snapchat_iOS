//
//  DubUser.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-04-30.
//
//

#import "DubUser.h"
#import "SDConstants.h"
#import "GeneralUtility.h"
#import "DubVideoCollectionManager.h"
#import "DubSoundCollectionManager.h"
#import "DubSoundBoardCollectionManager.h"
#import "DubUserActivityParseHelper.h"
#import "DubSoundBoardParseHelper.h"

@implementation DubUser
@synthesize dubsPlayCount, dubsLikeCount, numFollower, dubSoundCollectionManager, dubVideoCollectionManager, dubSoundboardCollectionManager, connectedParseObject, profileName, profileImagePFFile, followingUsersIdList, followingSoundBoardIdList, likedSoundsIdList, likedVideoIdList;
static DubUser* CurrentUser;
static NSArray* usersList;

-(id) init
{
    if(self == [super init])
    {
        dubVideoCollectionManager = [[DubVideoCollectionManager alloc] init];
        dubVideoCollectionManager.owner = self;
        dubSoundCollectionManager = [[DubSoundCollectionManager alloc] init];
        dubSoundCollectionManager.owner = self;
        dubSoundboardCollectionManager = [[DubSoundBoardCollectionManager alloc] init];
        dubSoundboardCollectionManager.owner = self;
        
        followingUsersIdList = [NSMutableDictionary dictionary];
        followingSoundBoardIdList = [NSMutableDictionary dictionary];
        likedSoundsIdList = [NSMutableDictionary dictionary];
        likedVideoIdList = [NSMutableDictionary dictionary];
        
      //  dubSoundboardCollectionManager = [[DubSoundCollectionManager alloc] init];
    }
    return self;
}

+(DubUser*) getARandomUser
{
    //NSLog(@"getARandomUser count %d", (int) [usersList count]);
    if([usersList count])
    {
        int index = [GeneralUtility randomValueBetween:0 and:((int)[usersList count]-1)];
        return [usersList objectAtIndex: index];
    }else
    {
        return nil;
    }
}

+(void) initUserLists: (void (^)(BOOL result))completionBlock
{
    [DubUserActivityParseHelper GetLatestListOfUsers:kPFCachePolicyCacheThenNetwork block:^(NSArray *users, NSError *error) {
        if (!error) {
            usersList = [NSArray arrayWithArray: users];
            //NSLog(@"usersList count %d", (int)[usersList count]);
        }
        
        if(completionBlock)
            completionBlock(error==nil);
    }];
}

+(void) loadCurrentUserSoundboardInfoFromParseWithBlock: (void (^)(BOOL result, NSError *error))completionBlock
{
    [[DubUser CurrentDubUser].dubSoundboardCollectionManager loadInfoFromParseInBackground:kPFCachePolicyNetworkOnly block:^(NSArray *createdSoundboards, NSArray *followingSoundboards, NSError *error) {
        
        if(completionBlock)
        {
            completionBlock(error?NO:YES, error);
        }
    }];
}

+(void) loadCurrentUserInBackgroundWithBlock:(PFCachePolicy) policy block: (void (^)(BOOL result, NSError *error))completionBlock
{
    __block BOOL doneA, doneB;
    [[PFUser currentUser] fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        //NSLog(@"Fetch User error %@", error);
    }];
     
    [[DubUser CurrentDubUser] setConnectedParseObject: [PFUser currentUser]];
    completionBlock(YES, nil);
    
    [[DubUser CurrentDubUser].dubSoundCollectionManager loadAllInfoFromParseInBackground:policy block:^(NSArray *userCreatedSounds, NSArray *userLikedSounds, NSError *error) {
        //NSLog(@"local userCreated sound is %@ liked sounds is %@", userCreatedSounds, userLikedSounds);
        
        doneA = YES;
        if(completionBlock && doneA && doneB)
        {
            completionBlock(YES, error);
        }
    }];
    
    [[DubUser CurrentDubUser].dubSoundboardCollectionManager loadInfoFromParseInBackground:policy block:^(NSArray *createdSoundboards, NSArray *followingSoundboards, NSError *error) {
        
        //NSLog(@"DubSOundboare %@ and error %@", createdSoundboards, error);
        
        doneB = YES;
        if(completionBlock && doneA && doneB )
        {
            completionBlock(YES, error);
        }
    }];
    
    [DubUserActivityParseHelper GetAllFollowingUsersOfAUserInBackground:[PFUser currentUser] pageLimit:1000 pageNum:0 cachePolicy:kPFCachePolicyCacheThenNetwork block:^(NSArray *results, NSError *error) {
        if(!error)
        {
            [[DubUser CurrentDubUser].followingUsersIdList removeAllObjects];
            for(DubUser* user in results)
            {
                [[DubUser CurrentDubUser].followingUsersIdList setValue: [NSNumber numberWithBool:YES] forKey: user.connectedParseObject.objectId];
            }
        }
    }];
    
    [DubSoundBoardParseHelper GetAllDubSoundboardsAUserFollowsInBackground:[PFUser currentUser] policy:kPFCachePolicyCacheThenNetwork block:^(NSArray *results, NSError *error) {
        if(!error)
        {
            [[DubUser CurrentDubUser].followingSoundBoardIdList removeAllObjects];
            
            for(PFObject* object in results)
            {
                [[DubUser CurrentDubUser].followingUsersIdList setValue: [NSNumber numberWithBool:YES] forKey: object.objectId];
            }
        }
    }];
}

+(void) SignupUserWithBlock: (void (^)(BOOL result, NSError *error))completionBlock
{
    [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if(!error)
        {
            //NSLog(@"Register ok User id %@", [PFUser currentUser].username);
            if(completionBlock)
                completionBlock(YES, error);
        }else
        {
             //NSLog(@"ERROR Register %@", error);
            if(completionBlock)
                completionBlock(NO, error);
        }
        
        
    }];
}

//TODO: implement this
+(void) connectCurrentUserWithFBWithBlock: (void (^)(BOOL result, NSError *error))completionBlock
{
    
}

+(DubUser*) CurrentDubUser
{
    if (!CurrentUser) {
        if ( [PFUser currentUser] ) {
            CurrentUser = [[DubUser alloc] init];
            [CurrentUser setConnectedParseObject: [PFUser currentUser]];
        }
    }
    return CurrentUser;
}

-(void) listenToEvents
{
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(<#selector#>) name:<#(NSString *)#> object:<#(id)#>]
}



-(BOOL) isCurrentDubUser
{
    return self == [DubUser CurrentDubUser];
}

-(void) setConnectedParseObject: (PFUser*) userObject
{    
    if(userObject == nil)
    {
        return;
    }
    connectedParseObject = userObject;
    
    [connectedParseObject fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if(!error)
        {
            //  dubsSoundPlayCount = [[userObject objectForKey: kSDUserNumSoundPlayCountKey] intValue];
            //  dubsVideoPlayCount = [[userObject objectForKey: kSDUserNumVideoPlayCountKey] intValue];
            //  dubsLikeCount = [[userObject objectForKey: kSDUserNumLikeKey] intValue];
            //  numFollow = [[userObject objectForKey: kSDUserNumFollowKey] intValue];
            
            profileName = [connectedParseObject objectForKey: kSDUserProfileNameKey];
            profileImagePFFile = [connectedParseObject objectForKey: kSDUserProfileImageKey];
            
            if(!profileImagePFFile)
            {
                profileImagePFFile = [connectedParseObject objectForKey: kSDUserProfileImageBackupKey];
            }
            
            if(!profileImagePFFile)
            {
                profileImagePFFile = [connectedParseObject objectForKey: kSDUserProfileImageBackupKey2];
            }
        }else
        {
            //NSLog(@"ERROR: DUbUser connected to ParseObject failed");
        }
        
    }];
}

-(void) loadSoundCollectionManagerContentsFromParseWithBlock:(void (^)(NSArray* result, NSError *error))completionBlock
{
    [dubSoundCollectionManager loadOwnerCreatedSoundsFromParseInBackground: completionBlock];
}

-(void) loadSoundCollectionManagerUserLikedSoundsFromParseWithBlock:(void (^)(NSArray* result, NSError *error))completionBlock
{
 //   [dubSoundCollectionManager loadOwnerLikedSoundsFromParseInBackground: completionBlock];
}

-(void) loadVideoCollectionManagerContentsFromParseWithBlock:(void (^)(NSArray* result, NSError *error))completionBlock
{
    [dubVideoCollectionManager loadUsreCreatedDubVideosFromParseInBackgroundWithBlock:completionBlock];
}

-(void) loadVideoCollectionManagerUserLikedVideosFromParseWithBlock:(void (^)(NSArray* result, NSError *error))completionBlock
{
    [dubVideoCollectionManager loadUserLikedDubVideosFromParseInBackgroundWithBlock:completionBlock];
}

-(void) follow
{
    if([self isCurrentDubUser])
    {
        return;
    }
    
    [DubUserActivityParseHelper FollowUserEventually: connectedParseObject];
    
    [[DubUser CurrentDubUser].followingUsersIdList setValue:[NSNumber numberWithBool:YES] forKey:self.connectedParseObject.objectId];
}

-(void) unfollow
{
    [DubUserActivityParseHelper UnfollowUserEventually: connectedParseObject];
    [[DubUser CurrentDubUser].followingUsersIdList  removeObjectForKey: self.connectedParseObject.objectId];
}

//TODO: implement this
-(void) loadSoundboardCollectionManagerContentsFromParseWithBlock:(void (^)(BOOL result, NSError *error))completionBlock
{
    [dubSoundboardCollectionManager loadOwnerFollowingSoundBoardsFromParseInBackground:kPFCachePolicyCacheThenNetwork block: ^(NSArray * results, NSError *error) {
        if (error) {
            if(completionBlock)
            {
                completionBlock(NO, error);
            }
        }else
        {
            if(completionBlock)
            {
                completionBlock(YES, nil);
            }
        }
    }];
}

-(BOOL) isTheSameUser: (DubUser*) another
{
    return [GeneralUtility IsTheSameParseObject:connectedParseObject :another.connectedParseObject];
}

-(BOOL) isFollowedByCurrentUser
{
    return [[DubUser CurrentDubUser].followingUsersIdList valueForKey: self.connectedParseObject.objectId] != nil;
}
@end
