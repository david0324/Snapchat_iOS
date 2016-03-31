//
//  DubSoundBoard.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-01.
//
//

#import <Foundation/Foundation.h>

@class DubUser;
@interface DubSoundBoard : NSObject
{
    NSString* soundBoardName;
    DubUser* creator;
    PFFile* coverImageFile;
    NSString* chosenPresetImageName;
    
    int numFollowing;
    int numPlay;
    int numSounds;
    
    NSMutableArray* soundLists;
    NSDate* createdDate;
    NSString* offlineId;
    
    PFObject* connectedParseObject;
}

@property (nonatomic, assign)int numFollowing;
@property (nonatomic, assign)int numPlay;
@property (nonatomic, assign)int numSounds;

@property (nonatomic, strong) PFFile* coverImageFile;
@property (nonatomic, strong)NSString* soundBoardName;
@property (nonatomic, strong)NSString* chosenPresetImageName;
@property (nonatomic, strong)DubUser* creator;
@property (nonatomic, strong)NSMutableArray* soundLists;
@property (nonatomic, strong)NSDate* createdDate;
@property (nonatomic, strong)NSString* offlineId;
@property (nonatomic, strong)PFObject* connectedParseObject;

-(BOOL) isTheSameSoundBoard: (DubSoundBoard*) another;
-(void) saveDubSoundBoardToParseInBackgroundWithBlock: (void (^)(BOOL result, NSError* error)) completionBlock;

@end
