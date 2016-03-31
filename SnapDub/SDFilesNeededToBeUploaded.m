//
//  SDFilesNeededToBeUploaded.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-04.
//
//

#import "SDFilesNeededToBeUploaded.h"
#import "DubSound.h"
#import "DubVideo.h"
#import "SDConstants.h"
#import "DubSoundBoard.h"
#import "DubUser.h"

@implementation SdSoundAndSoundBoardInfo
@synthesize soundOfflineFileName, soundBoardOfflineId;

-(BOOL) isTheSame: (SdSoundAndSoundBoardInfo*) info
{
    return [soundBoardOfflineId isEqualToString: info.soundBoardOfflineId] && [soundOfflineFileName isEqualToString: info.soundOfflineFileName];
}

//TODO finish it
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        soundOfflineFileName = [decoder decodeObjectForKey:@"soundOfflineFileName"];
        soundBoardOfflineId = [decoder decodeObjectForKey:@"soundBoardOfflineId"];
        
    }
    return self;
}

//TODO finish it
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:soundOfflineFileName forKey:@"soundOfflineFileName"];
    [encoder encodeObject:soundBoardOfflineId forKey:@"soundBoardOfflineId"];
}
@end


@implementation SDFilesNeededToBeUploaded
@synthesize  cacheSoundList, cacheVideoList, cacheSoundboardList, cacheSoundAndSoundboardList;
static SDFilesNeededToBeUploaded* shareInstance;

+(SDFilesNeededToBeUploaded*) ShareInstance
{
    if (shareInstance == nil) {
        shareInstance = [[SDFilesNeededToBeUploaded alloc] init];
    }
    
    return shareInstance;
}

-(void) initHelper
{
    if (!soundList) {
        soundList = [NSMutableArray array];
    }
    
    if(!videoList)
        videoList = [NSMutableArray array];
    
    if(!fileToBeUpload)
        fileToBeUpload = [NSMutableArray array];
    
    if(!soundAndSoundboardList)
        soundAndSoundboardList = [NSMutableArray array];
    
    if(!soundBoardsList)
        soundBoardsList = [NSMutableArray array];
    
    cacheSoundList = [NSMutableArray array];
    cacheVideoList= [NSMutableArray array];
    cacheSoundboardList= [NSMutableArray array];
    cacheSoundAndSoundboardList= [NSMutableArray array];
    
//    if(!soundAndSoundboardToBeUploaded)
//    soundAndSoundboardToBeUploaded = [NSMutableDictionary dictionary];
}

-(id) init
{
    if(self == [super init])
    {
        [self initHelper];
    }
    
    return self;
}

//TODO multip thread
- (void) saveSoundList
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject: soundList] forKey: kUserDefault_SDFilesNeedeToBeUploaded_SaveSoundList];
    [defaults synchronize];
    //NSLog(@"save savesoundlist, done! soundlist is %@",  soundList);
}

//TODO multip thread
- (void) saveVideoList
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject: videoList] forKey: kUserDefault_SDFilesNeedeToBeUploaded_SaveVideoList];
    [defaults synchronize];
    //NSLog(@"save videoList, done! videoList is %@",  videoList);
}

- (void) saveSoundboardsList
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject: soundBoardsList] forKey: kUserDefault_SDFilesNeedeToBeUploaded_SaveSoundboardsList];
    [defaults synchronize];
    //NSLog(@"save soundBoardsList, done! soundBoardsList is %@",  soundBoardsList);
}

//TODO multip thread
- (void) saveSoundAndSoundboardList
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject: soundAndSoundboardList] forKey: kUserDefault_SDFilesNeedeToBeUploaded_SaveSoundAndSoundboard];
    [defaults synchronize];
    //NSLog(@"save soundAndSoundboardList, done! soundAndSoundboardList is %@", soundAndSoundboardList);
}

-(void) loadData
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey: kUserDefault_SDFilesNeedeToBeUploaded_SaveSoundList ];
    soundList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    [cacheSoundList addObjectsFromArray: soundList];
    
    NSData *dataVideo = [[NSUserDefaults standardUserDefaults] objectForKey: kUserDefault_SDFilesNeedeToBeUploaded_SaveVideoList ];
    videoList = [NSKeyedUnarchiver unarchiveObjectWithData:dataVideo];
    [cacheVideoList addObjectsFromArray: videoList];
    
    NSData *dataSoundboard = [[NSUserDefaults standardUserDefaults] objectForKey: kUserDefault_SDFilesNeedeToBeUploaded_SaveSoundboardsList ];
    soundBoardsList = [NSKeyedUnarchiver unarchiveObjectWithData:dataSoundboard];
    [cacheSoundboardList addObjectsFromArray: soundBoardsList];
    
    NSData *dataSoundAndSoundboard = [[NSUserDefaults standardUserDefaults] objectForKey: kUserDefault_SDFilesNeedeToBeUploaded_SaveSoundAndSoundboard ];
    soundAndSoundboardList = [NSKeyedUnarchiver unarchiveObjectWithData:dataSoundboard];
    [cacheSoundAndSoundboardList addObjectsFromArray: soundAndSoundboardList];
    
    [self initHelper];
    
    //NSLog(@"loadData done! soundlist is %@",  soundList);
    //NSLog(@"loadData done! videolist is %@",  videoList);
    //NSLog(@"loadData done! soundBoardsList is %@",  soundBoardsList);
}

-(void) addSoundFile: (DubSound*) sound
{
    //NSLog(@"addSoundFile soundlist is %@",  soundList);
    if(![ soundList containsObject: sound])
    {
        //NSLog(@"Save a sound to Sound list cache");
        [ soundList addObject: sound];
    
        [self saveSoundList];
    }
}

-(void) removeSoundFile: (DubSound*) sound
{
    if([soundList containsObject: sound])
    {
        [soundList removeObject: sound];
        [self saveSoundList];
    }
}

-(void) addVideoFile: (DubVideo*) video
{
    if(![videoList containsObject: video])
    {
        [videoList addObject: video];
    
        [self saveVideoList];
    }
}

-(void) removeVideoFile: (DubVideo*) video
{
    if([videoList containsObject: video])
    {
        [videoList removeObject: video];
        [self saveVideoList];
    }
}

-(void) addDubSoundboard: (DubSoundBoard*) soundBoard
{
    if(![soundBoardsList containsObject: soundBoard])
    {
        [soundBoardsList addObject: soundBoard];
        
        [self saveSoundboardsList];
    }
}

-(void) removeDubSoundboard: (DubSoundBoard*) soundBoard
{
    if([soundBoardsList containsObject: soundBoard])
    {
        [soundBoardsList removeObject: soundBoard];
        [self saveSoundboardsList];
    }
}

-(void) addSoundAndSoundboardInfo: (NSString*) soundOfflineName soundboardID:(NSString*) soundBoardOfflineId
{
    SdSoundAndSoundBoardInfo* tempInfo = [SdSoundAndSoundBoardInfo init];
    tempInfo.soundOfflineFileName = soundOfflineName;
    tempInfo.soundBoardOfflineId = soundBoardOfflineId;
    
    for(SdSoundAndSoundBoardInfo* info in soundAndSoundboardList)
    {
        if ([info isTheSame: tempInfo]) {
            return;
        }
    }
    
    [soundAndSoundboardList addObject: tempInfo];
    [self saveSoundAndSoundboardList];
}

-(void) removeSoundAndSoundboardInfo: (NSString*) soundOfflineName soundboardID:(NSString*) soundBoardOfflineId
{
    SdSoundAndSoundBoardInfo* tempInfo = [SdSoundAndSoundBoardInfo init];
    tempInfo.soundOfflineFileName = soundOfflineName;
    tempInfo.soundBoardOfflineId = soundBoardOfflineId;
    
    for(SdSoundAndSoundBoardInfo* info in soundAndSoundboardList)
    {
        if ([info isTheSame: tempInfo]) {
            [soundAndSoundboardList removeObject: info];
            [self saveSoundAndSoundboardList];
            return;
        }
    }
}

-(void) removeSoundAndSoundboardInfo: (NSString*) soundOfflineName :(NSString*) soundBoardOfflineId
{
    SdSoundAndSoundBoardInfo* tempInfo = [SdSoundAndSoundBoardInfo init];
    tempInfo.soundOfflineFileName = soundOfflineName;
    tempInfo.soundBoardOfflineId = soundBoardOfflineId;
    
    for(SdSoundAndSoundBoardInfo* info in soundAndSoundboardList)
    {
        if ([info isTheSame: tempInfo]) {
            [soundAndSoundboardList removeObject: info];
            [self saveSoundAndSoundboardList];
            return;
        }
    }
}

/*
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        soundList = [decoder decodeObjectForKey:@"soundList"];
        videoList = [decoder decodeObjectForKey:@"videoList"];
        soundAndSoundboardList = [decoder decodeObjectForKey:@"soundAndSoundboardList"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:soundList forKey:@"soundList"];
    [encoder encodeObject:videoList forKey:@"videoList"];
    [encoder encodeObject:soundAndSoundboardList forKey:@"soundAndSoundboardList"];
}
*/

-(void) resumeUploadingToParse
{
    //NSLog(@"start resumeUploadingToParse" );
    if([fileToBeUpload count]>0)
    {
        //NSLog(@"[fileToBeUpload count] %d", (int)[fileToBeUpload count] );
        NSObject* temp = [fileToBeUpload objectAtIndex: 0];
        
        if( [temp isKindOfClass: [DubSoundBoard class]])
        {
            //NSLog(@"trying to upload DubSoundBoard from Cache");
            
            DubSoundBoard* soundboard = (DubSoundBoard*)[fileToBeUpload objectAtIndex: 0];
            
            [soundboard saveDubSoundBoardToParseInBackgroundWithBlock: ^( BOOL result, NSError* error){
                if (result && !error) {
                    [self removeDubSoundboard: soundboard];
                    
                    //NSLog(@"Succeed resumeUploadingToParse DubVideo* video" );
                }else
                {
                    //NSLog(@"Error: resumeUploadingToParse DubVideo* video  %@", error?error:@"");
                    
                }
                
                [fileToBeUpload removeObject: soundboard];
                [self resumeUploadingToParse];
                
            }];
            
        }
        else if( [temp isKindOfClass: [DubSound class]])
        {
            //NSLog(@"trying to upload DubSound from Cache");
            
            DubSound* sound = (DubSound*)[fileToBeUpload objectAtIndex: 0];
            
            [sound saveSoundToParseInBackgrountWithBlock: ^(BOOL result, NSError* error){
                if (result && !error) {
                    [self removeSoundFile: sound];
                    //NSLog(@"Succeed resumeUploadingToParse DubSound* sound" );
                }else
                {
                    //NSLog(@"Error: resumeUploadingToParse DubSound* sound %@", error?error:@"");
                    
                }
                
                [fileToBeUpload removeObject: sound];
                [self resumeUploadingToParse];
                
            }];
        }
        
        else if( [temp isKindOfClass: [DubVideo class]])
        {
            //NSLog(@"trying to upload DubVideo from Cache");
            
            DubVideo* video = (DubVideo*)[fileToBeUpload objectAtIndex: 0];
            
            [video saveVideoToParseEventuallyWithBlcok: ^( BOOL result, NSError* error){
                if (result && !error) {
                    [self removeVideoFile: video];
                   
                    //NSLog(@"Succeed resumeUploadingToParse DubVideo* video" );
                }else
                {
                    //NSLog(@"Error: resumeUploadingToParse DubVideo* video  %@", error?error:@"");
                    
                }
                
                [fileToBeUpload removeObject: video];
                [self resumeUploadingToParse];
              
            }];
        }
        
        //TODO: Is this required at all?
        else if( [temp isKindOfClass: [SdSoundAndSoundBoardInfo class]])
        {
            //NSLog(@"trying to upload SdSoundAndSoundBoardInfo from Cache");
            
            SdSoundAndSoundBoardInfo* tempInfo = (SdSoundAndSoundBoardInfo*) [fileToBeUpload objectAtIndex: 0];
            
            NSString* soundOfflineName = tempInfo.soundOfflineFileName;
            NSString* soundBoardOfflineId = tempInfo.soundBoardOfflineId;
            
            
            PFQuery* soundQuery = [PFQuery queryWithClassName: kSDDubSoundClassName ];
            [soundQuery whereKey: kSDDubSoundCreatorKey equalTo: [PFUser currentUser]];
            [soundQuery whereKey: kSDOfflineId equalTo: soundOfflineName];
            
            [soundQuery findObjectsInBackgroundWithBlock:^(NSArray *sounds, NSError *error) {
                if (!error && [sounds count]>0) {
                    
                    PFQuery* soundBoardQuery = [PFQuery queryWithClassName: kSDDubSoundboardClassName ];
                    [soundBoardQuery whereKey: kSDDubSoundboardCreatorKey equalTo: [PFUser currentUser]];
                    [soundBoardQuery whereKey: kSDOfflineId equalTo: soundBoardOfflineId];
                    
                    [soundBoardQuery findObjectsInBackgroundWithBlock:^(NSArray *boards, NSError *error2) {
                        
                        if (!error2 && [boards count]>0) {
                            //Succeed!
                            PFObject* mapObject = [PFObject objectWithClassName: kSDDubSoundToDubSoundBoardMapClassName];
                            
                            [mapObject setObject: [sounds objectAtIndex: 0] forKey: kSDDubSoundToDubSoundBoardMapDubSoundRefKey];
                            [mapObject setObject: [boards objectAtIndex: 0] forKey: kSDDubSoundToDubSoundBoardMapDubSoundRefKey];
                            
                            [mapObject saveEventually];
                            
                            //NSLog(@"Saving soundAndSoundboardToBeUploaded OK!");
                            
                            [self removeSoundAndSoundboardInfo: soundOfflineName :soundBoardOfflineId];
                        }else
                        {
                            //NSLog(@"FAILURE: soundAndSoundboardToBeUploaded soundBoardQuery %@", error?error:@"");
                        }
                        
                        [fileToBeUpload removeObject: tempInfo];
                        [self resumeUploadingToParse];
                        return;
                    }];
                }else
                {
                    //NSLog(@"FAILURE: soundAndSoundboardToBeUploaded soundQuery %@", error?error:@"");
                    
                    [fileToBeUpload removeObject: tempInfo];
                    [self resumeUploadingToParse];
                    return;
                }
            }];
        }

    }
    
   
}

-(void) startAllUploadingToParse
{
    [fileToBeUpload removeAllObjects];
    
    [fileToBeUpload addObjectsFromArray: soundBoardsList];
    [fileToBeUpload addObjectsFromArray: soundList];
    [fileToBeUpload addObjectsFromArray: videoList];
    [fileToBeUpload addObjectsFromArray: soundAndSoundboardList];
    
    [self resumeUploadingToParse];
}

@end
