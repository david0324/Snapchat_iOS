//
//  DubSoundBoardCollectionManager.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-14.
//
//

#import "DubSoundBoardCollectionManager.h"
#import "DubSoundBoardParseHelper.h"
#import "DubUser.h"
#import "DubSoundBoard.h"
#import "SDFilesNeededToBeUploaded.h"
#import "DubSoundBoardParseHelper.h"

@implementation DubSoundBoardCollectionManager
@synthesize userCreatedDubSoundboards, userFollowingDubSoundboards, owner;

-(id) init
{
    if(self == [super init])
    {
        userCreatedDubSoundboards = [NSMutableArray array];
        userFollowingDubSoundboards = [NSMutableArray array];
    }
    
    return self;
}

-(id) initWithPFUser: (DubUser*) m
{
    self = [self init];
    owner = m;
    
    return self;
}

+(void) addSoundToSoundboardAndSaveToParse: (DubSound*) sound soundBoard: (DubSoundBoard*) soundboard
{

}

-(void) createSoundBoardAndSaveToParse:(NSString*) soundBoardName presetIconName:(NSString*) iconName block:(void (^)(BOOL , NSError *))completionBlock
{

}

-(void) createSoundBoardAndSaveToParse:(NSString*) soundBoardName icon:(UIImage*) icon block:(void (^)(BOOL , NSError *))completionBlock
{

}


-(void) loadOwnerCreatedSoundBoardsFromParseInBackground:(PFCachePolicy) policy  block: (void (^)(NSArray* , NSError *))completionBlock
{

}

-(void) loadOwnerFollowingSoundBoardsFromParseInBackground:(PFCachePolicy) policy block: (void (^)(NSArray* , NSError *))completionBlock
{

}

-(void) loadInfoFromParseInBackground:(PFCachePolicy) policy block: (void (^)(NSArray* createdSoundboards, NSArray* followingSoundboards, NSError *error)) completionBlock
{

}

-(void) addSoundboardToUserFollowingDubSoundboards: (DubSoundBoard*) soundBoard
{

}

-(void) removeSoundboardToUserFollowingDubSoundboards: (DubSoundBoard*) soundBoard
{

}

-(void) addSoundboardToUserCreatedDubSoundboards: (DubSoundBoard*) soundBoard
{


    
}

-(void) removeSoundboardToUserCreatedDubSoundboards: (DubSoundBoard*) soundBoard
{
 
}


@end
