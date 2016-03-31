//
//  DubVideoCollectionManager.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-04.
//
//

#import "DubVideoCollectionManager.h"
#import "DubVideoParseHelper.h"
#import "SDConstants.h"
#import "DubVideo.h"
#import "DubUser.h"
#import "DubVideoParseHelper.h"
#import "SDFilesNeededToBeUploaded.h"

@implementation DubVideoCollectionManager
@synthesize userCreatedDubVideos, userLikedDubVideos, owner;

static DubVideoCollectionManager* shareInstance;

-(id) init
{
    if(self == [super init])
    {
        userCreatedDubVideos = [NSMutableArray array];
        userLikedDubVideos = [NSMutableArray array];
    }
    
    return self;
}

-(id) initWithPFUser: (DubUser*) m
{
    self = [self init];
    owner = m;
    
    return self;
}


//Todo: save to parse
-(void) addDubVideoToUserCreatedVideoList: (DubVideo*) video
{

}

//TODO: save to Parse
-(void) addDubVideoToUserLikedVideoList: (DubVideo*) video
{

}

-(void) removeDubVideoFromUserLikedVideoList:(DubVideo*) video
{

}

-(void) loadUsreCreatedDubVideosFromParseInBackgroundWithBlock: (void(^)(NSArray*, NSError*))completionBlock
{

}

-(void) loadUsreCreatedDubVideosFromParseInBackgroundWithBlock:(BOOL) fromLocalDatastore block: (void(^)(NSArray*, NSError*))completionBlock
{

}

-(void) loadUserLikedDubVideosFromParseInBackgroundWithBlock: (void(^)(NSArray*, NSError*))completionBlock
{

}

-(void) loadUserLikedDubVideosFromParseInBackgroundWithBlock:(BOOL) fromLocalDatastore block: (void(^)(NSArray*, NSError*))completionBlock
{

}

-(void) loadInfoFromParseInBackground:(BOOL) fromLocalDatastore block: (void(^)(NSArray* userCreatedVideos, NSArray* userLikedVideos, NSError* error)) completionBlock
{

}

-(BOOL) isDubVideoLikedByOwner: (DubVideo*) video
{

    return NO;
}


@end
