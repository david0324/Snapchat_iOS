//
//  DubSoundCollectionManager.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-01.
//
//

#import <Foundation/Foundation.h>

@class DubUser, DubSound;
@interface DubSoundCollectionManager : NSObject
{
    NSMutableArray* userCreatedDubSounds;
    NSMutableArray* userLikedDubSounds;
    
    DubUser* owner;
}

@property (nonatomic,strong)NSMutableArray* userCreatedDubVideos;
@property (nonatomic,strong)NSMutableArray* userLikedDubVideos;
@property (nonatomic,strong)DubUser* owner;

-(void) addDubSoundToUserLikedSounds:(DubSound*) sound;
-(void) removeDubSoundToUserLikedSounds:(DubSound*) sound;
//TODO: add Parse codes
-(void) addDubSoundToUserCreatedDubSounds:(DubSound*) sound;
-(void) loadOwnerCreatedSoundsFromParseInBackground:(void (^)(NSArray* , NSError *))completionBlock;

-(void) loadOwnerLikedSoundsFromParseInBackground:(PFCachePolicy) policy block: (void (^)(NSArray* , NSError *))completionBlock;


-(void) loadAllInfoFromParseInBackground:(PFCachePolicy) policy block:(void (^)(NSArray* userCreatedSounds, NSArray* userLikedSounds, NSError *error))completionBlock;

+(void) createADubSoundWithFileName: (NSString*) fileName block:(void (^)(DubSound* result , NSError* error))completionBlock;
-(BOOL) isDubSoundLikedByUser: (DubSound*) sound;
@end
