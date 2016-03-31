//
//  DubSoundBoardCollectionManager.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-14.
//
//

#import <Foundation/Foundation.h>

@class DubUser, DubSoundBoard, DubSound;
@interface DubSoundBoardCollectionManager : NSObject
{
    NSMutableArray* userCreatedDubSoundboards;
    NSMutableArray* userFollowingDubSoundboards;
    
    DubUser* owner;
}

@property (nonatomic, strong) NSMutableArray* userCreatedDubSoundboards;
@property (nonatomic, strong) NSMutableArray* userFollowingDubSoundboards;
@property (nonatomic,strong)DubUser* owner;

-(void) createSoundBoardAndSaveToParse:(NSString*) soundBoardName icon:(UIImage*) icon block:(void (^)(BOOL , NSError *))completionBlock;
+(void) addSoundToSoundboardAndSaveToParse: (DubSound*) sound soundBoard: (DubSoundBoard*) soundboard;

-(void) addSoundboardToUserFollowingDubSoundboards: (DubSoundBoard*) soundBoard;
-(void) removeSoundboardToUserFollowingDubSoundboards: (DubSoundBoard*) soundBoard;

-(void) addSoundboardToUserCreatedDubSoundboards: (DubSoundBoard*) soundBoard;
-(void) removeSoundboardToUserCreatedDubSoundboards: (DubSoundBoard*) soundBoard;

-(void) loadOwnerFollowingSoundBoardsFromParseInBackground:(PFCachePolicy) policy block: (void (^)(NSArray* , NSError *))completionBlock;

-(void) loadOwnerCreatedSoundBoardsFromParseInBackground:(PFCachePolicy) policy  block: (void (^)(NSArray* , NSError *))completionBlock;
-(void) loadInfoFromParseInBackground:(PFCachePolicy) policy block: (void (^)(NSArray* createdSoundboards, NSArray* followingSoundboards, NSError *error)) completionBlock;
-(void) createSoundBoardAndSaveToParse:(NSString*) soundBoardName presetIconName:(NSString*) iconName block:(void (^)(BOOL , NSError *))completionBlock;
@end
