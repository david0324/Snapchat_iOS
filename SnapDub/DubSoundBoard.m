//
//  DubSoundBoard.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-01.
//
//

#import "DubSoundBoard.h"
#import "SDConstants.h"
#import "DubUser.h"
#import "DubSound.h"
#import "DubSoundBoardParseHelper.h"
#import "GeneralUtility.h"
#import "DubSoundBoardCollectionManager.h"
#import "SDFilesNeededToBeUploaded.h"

@implementation DubSoundBoard
@synthesize numFollowing, numPlay, numSounds, soundBoardName, creator, soundLists, createdDate, connectedParseObject,chosenPresetImageName, offlineId, coverImageFile;

-(void) initHelper
{
    if (!soundLists) {
        soundLists = [NSMutableArray array];
    }
}

-(id) init
{
    if(self == [super init])
    {
        [self generateOfflineId];
        [self initHelper];
    }
    
    return self;
}

-(BOOL) isTheSameSoundBoard: (DubSoundBoard*) another
{
    return self.connectedParseObject == another.connectedParseObject;
    /*
    if (connectedParseObject.objectId!=nil)
    {
        return [connectedParseObject.objectId isEqualToString: another.connectedParseObject.objectId];
        
    }else
    {
        return [self.offlineId isEqualToString: another.offlineId];
    }
     */
}

-(PFObject*) connectedParseObject
{
    return  nil;
}

-(void) setConnectedParseObject:(PFObject *)connectedParseObjec2
{

}

-(void) loadAllDubSoundsInBackground: (void (^)(NSArray* results, NSError *error))completionBlock
{
    /*
    [DubSoundBoardParseHelper GetAllDubSoundsInADubSoundBoardInBackground:connectedParseObject useLocalDatastore:NO block:^(NSArray *results, NSError *error) {
       
        if (!error ) {
            [soundLists removeAllObjects];
            for (PFObject* soundObject in results ) {
                DubSound* sound = [[DubSound alloc] init];
                [sound setConnectedParseObject:soundObject ];
                [soundLists addObject: soundObject];
            }

            if(completionBlock)
            {
                completionBlock(soundLists, error);
            }
        }else
        {
            if(completionBlock)
            {
                completionBlock(nil, error);
            }
        }
    }];
     */
}

-(void) saveDubSoundBoardToParseInBackgroundWithBlock: (void (^)(BOOL result, NSError* error)) completionBlock
{

}

-(void) addADubSound: (DubSound*) theSound block: (void (^)(BOOL result, NSError* error)) completionBlock
{

}

-(void) generateOfflineId
{
    offlineId = [GeneralUtility uuid];
}

-(void) follow
{
  
}

-(void) unFollow
{
   }

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        soundBoardName = [decoder decodeObjectForKey:@"soundBoardName"];
        creator = [DubUser CurrentDubUser];
        chosenPresetImageName = [decoder decodeObjectForKey:@"chosenPresetImageName"];

        offlineId = [decoder decodeObjectForKey:@"offlineId"];
        
        [self initHelper];
        
        [self connectedParseObject];
    }
    return self;
}

//TODO finish it
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:soundBoardName forKey:@"soundBoardName"];
    [encoder encodeObject:chosenPresetImageName forKey:@"chosenPresetImageName"];
    [encoder encodeObject:offlineId forKey:@"offlineId"];
}

@end
