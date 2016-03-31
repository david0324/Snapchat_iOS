//
//  SDFilesNeededToBeUploaded.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-04.
//
//

#import <UIKit/UIKit.h>

@class DubSound, DubVideo, DubSoundBoard;

@interface SDFilesNeededToBeUploaded : NSObject
{
    NSMutableArray* soundList;
    NSMutableArray* videoList;
    NSMutableArray* soundAndSoundboardList;
    NSMutableArray* soundBoardsList;
    
    NSMutableArray* cacheSoundList;
    NSMutableArray* cacheVideoList;
    NSMutableArray* cacheSoundboardList;
    NSMutableArray* cacheSoundAndSoundboardList;
    
    NSMutableArray* fileToBeUpload;
}

@property (nonatomic, strong) NSMutableArray* cacheSoundList;
@property (nonatomic, strong) NSMutableArray* cacheVideoList;
@property (nonatomic, strong) NSMutableArray* cacheSoundboardList;
@property (nonatomic, strong) NSMutableArray* cacheSoundAndSoundboardList;

+(SDFilesNeededToBeUploaded*) ShareInstance;
-(void) addSoundFile: (DubSound*) sound;
-(void) removeSoundFile: (DubSound*) sound;
-(void) addVideoFile: (DubVideo*) video;
-(void) removeVideoFile: (DubVideo*) video;
-(void) addDubSoundboard: (DubSoundBoard*) soundBoard;
-(void) removeDubSoundboard: (DubSoundBoard*) soundBoard;
-(void) addSoundAndSoundboardInfo: (NSString*) soundOfflineName soundboardID:(NSString*) soundBoardOfflineId;
-(void) removeSoundAndSoundboardInfo: (NSString*) soundOfflineName soundboardID:(NSString*) soundBoardOfflineId;
-(void) startAllUploadingToParse;
-(void) loadData;

@end

@interface SdSoundAndSoundBoardInfo : NSObject<NSCoding>
{
    NSString* soundOfflineFileName;
    NSString* soundBoardOfflineId;
}

@property (nonatomic, strong) NSString* soundOfflineFileName;
@property (nonatomic, strong) NSString* soundBoardOfflineId;
-(BOOL) isTheSame: (SdSoundAndSoundBoardInfo*) info;


@end
