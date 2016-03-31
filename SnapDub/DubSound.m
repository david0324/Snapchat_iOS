//
//  DubSound.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-01.
//
//

#import "DubSound.h"
#import "SDConstants.h"
#import "DubUser.h"
#import "DubSoundParseHelper.h"
#import "GeneralUtility.h"
#import "SDFilesNeededToBeUploaded.h"
#import "DubSoundCollectionManager.h"
#import "DubCategory.h"

@implementation DubSound
@synthesize soundName,duration, creator, playCount, likeCount, problemReportedCount, createdDate, soundPFFile,tags, soundLanguage, offlineFileName,connectedParseObject, category, score;

-(id) init
{
    if(self == [super init])
    {
        tags = [NSMutableArray array];
    }
    return self;
}

-(void) setSoundDataFromLocalFilePath: (NSString*) path
{
    //NSLog(@"FilePath is %@", path);
    NSData* data = [NSData dataWithContentsOfFile: path];
    [self setSoundData: data];
}

-(void) setSoundData: (NSData*) data
{
    if(!data)
    {
        //NSLog(@"ERROR: Data is Empty!");
        return;
    }
    soundPFFile = [PFFile fileWithData: data];
}

-(PFObject*) connectedParseObject
{
    if(connectedParseObject!=nil)
    {
        return connectedParseObject;
    }
    
    PFObject* soundObject = [PFObject objectWithClassName: kSDDubSoundClassName];
    [soundObject pin];
    
    if(soundName)
        [soundObject setValue:soundName forKey:kSDDubSoundSoundNameKey];
    [soundObject setValue:[NSNumber numberWithBool: YES] forKey:kSDDubSoundIsEditing];
    [soundObject setValue:kSDDubSoundSoundLanguageEnglishValue forKey:kSDDubSoundSoundLanguageKey];
    [soundObject setValue:[NSNumber numberWithFloat:duration] forKey:kSDDubSoundDurationKey];
    if(tags)
        [soundObject setValue:tags forKey:kSDDubSoundTagsKey];
    
    if([PFUser currentUser])
        [soundObject setValue:[PFUser currentUser] forKey:kSDDubSoundCreatorKey];
    
    if(category)
        [soundObject setValue:category.connectedPFObject forKey:kSDDubSoundCategoryRefKey];
    
    if(soundPFFile)
    {
        [soundObject setValue: soundPFFile forKey:kSDDubSoundSoundFileKey];
    }else
    {
        NSString* filePath = [GeneralUtility getFilePathOfAFileNameInDocumentFolder: offlineFileName folder:nil];
        
        NSData* data = [NSData dataWithContentsOfFile: filePath];
        self.soundPFFile = [PFFile fileWithData: data ];
        [soundObject setValue: self.soundPFFile forKey:kSDDubSoundSoundFileKey];
    }
    
    soundObject[kSDOfflineFileName] = offlineFileName;
    
    PFACL *acl = [PFACL ACLWithUser:[PFUser currentUser]];
    [acl setPublicReadAccess:YES];
    soundObject.ACL = acl;
    
    connectedParseObject = soundObject;
    return connectedParseObject;
}

-(void) setConnectedParseObject:(PFObject *)theconnectedPFObject
{
    connectedParseObject = theconnectedPFObject;
    //  [connectedParseObject pinInBackground];
    
    if(!connectedParseObject.isDataAvailable)
    {
        //NSLog(@"Sound Data Not Available %@", connectedParseObject.objectId);
    }
    
    [connectedParseObject fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        //NSLog(@"Finished fetchIfNeededInBackgroundWithBlock Sound ID %@", connectedParseObject.objectId);
        if(!error)
        {
            soundName = [connectedParseObject objectForKey: kSDDubSoundSoundNameKey];
            duration = [[connectedParseObject objectForKey: kSDDubSoundDurationKey] floatValue];
            
            if([connectedParseObject objectForKey: kSDDubSoundCreatorKey])
            {
                creator = [[DubUser alloc] init];
                [creator setConnectedParseObject: [connectedParseObject objectForKey: kSDDubSoundCreatorKey]];
            }else
            {
                //NSLog(@"DubSound Creator is NILL");
                creator = [DubUser getARandomUser];
            }
            
            playCount = [[connectedParseObject objectForKey: kSDDubSoundPlayCountKey] intValue];
            likeCount = [[connectedParseObject objectForKey: kSDDubSoundLikeCountKey] intValue];
            problemReportedCount = [[connectedParseObject objectForKey: kSDDubSoundProblemReportedCountKey] intValue];
            
            createdDate = [connectedParseObject createdAt];
            
            score = [[connectedParseObject objectForKey: kSDDubSoundScoreKey] intValue];
            
            if (connectedParseObject.objectId) {
                soundPFFile = [connectedParseObject objectForKey: kSDDubSoundSoundFileKey];
            }else
            {
                //NSLog(@"generate new PFFIle");
                NSString* filePath = [GeneralUtility getFilePathOfAFileNameInDocumentFolder: offlineFileName folder:nil];
                
                NSData* data = [NSData dataWithContentsOfFile: filePath];
                soundPFFile = [PFFile fileWithData: data ];
                [connectedParseObject setValue: soundPFFile forKey:kSDDubSoundSoundFileKey];
            }
            
            soundLanguage = [connectedParseObject objectForKey: kSDDubSoundSoundLanguageKey];
            
            offlineFileName = [connectedParseObject objectForKey: kSDOfflineFileName];
        }else
        {
            //NSLog(@"Sound ERROR ID %@", connectedParseObject.objectId);
        }
    }];
}

-(void) saveSoundToParseInBackgrountWithBlock: (void (^)(BOOL , NSError*))completionBlock
{
    
    
}

-(void) loadSoundDataInBackgournd: (void (^)(NSData* data, NSError *error))completionBlock
{
    [soundPFFile getDataInBackgroundWithBlock:^(NSData* thedata, NSError* theError){
        
        if (!theError ) {
            if(completionBlock)
                completionBlock(thedata, theError);
        }else
        {
            if(completionBlock)
            {
                completionBlock(nil, theError);
            }
        }
    }];
}

-(void) like
{
    [DubSoundParseHelper LikeADubSound: self.connectedParseObject];
    [[DubUser CurrentDubUser].dubSoundCollectionManager addDubSoundToUserLikedSounds: self];
    [[NSNotificationCenter defaultCenter] postNotificationName: EVENT_SOUND_FAV_CHANGED object: nil];
}

-(void) unlike
{
    [DubSoundParseHelper UnlikeADubSound: self.connectedParseObject];
    [[DubUser CurrentDubUser].dubSoundCollectionManager removeDubSoundToUserLikedSounds: self];
    [[NSNotificationCenter defaultCenter] postNotificationName: EVENT_SOUND_FAV_CHANGED object: nil];
}

-(BOOL) isLikedByCurrentUser
{
    return [[DubUser CurrentDubUser].dubSoundCollectionManager isDubSoundLikedByUser: self ];
}

//For Testing to create a sound
+(void) createADubSoundWithLocalURL: (NSString*) fileName block:(void (^)(DubSound*, BOOL , NSError*))completionBlock
{
    NSString* imageName = [[NSBundle mainBundle] pathForResource:@"justin1" ofType:@"png"];
    //  NSImage* imageToSave = [[NSImage alloc] initWithContentsOfFile:imageName];
    
    UIImage* imageToSave = [UIImage imageWithContentsOfFile: imageName];
    NSData* data = [NSData dataWithContentsOfFile:imageName];
    //NSLog(@"data size %d and image heigh is %f and imageName is %@", (int)data.length, imageToSave.size.height, imageName);
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSData * binaryImageData = UIImagePNGRepresentation(imageToSave);
    
    NSString* filePath = [basePath stringByAppendingPathComponent: fileName ];
    BOOL writingResult = [binaryImageData writeToFile:filePath atomically:YES];
    //NSLog(@"WritingResult is %d", writingResult);
    
    NSData* data2 = [NSData dataWithContentsOfFile:filePath];
    //NSLog(@"data2 size %d ", (int)data2.length);
    
    DubSound* sound = [[DubSound alloc] init];
    sound.offlineFileName = fileName;
    
    //NSLog(@"sound local uRL %@", sound.offlineFileName);
    
    [sound saveSoundToParseInBackgrountWithBlock:^(BOOL result, NSError * error) {
        //NSLog(@"Saving Sound result is %d", result);
        
        if(completionBlock)
            completionBlock(sound, result, error);
    }];
}

-(BOOL) isTheSameSound: (DubSound*) another
{
    return [GeneralUtility IsTheSameParseObject: self.connectedParseObject :another.connectedParseObject];
}

-(void) saveFileToTempFolderInBackground: (void(^)(BOOL result, NSString* filePath)) completionBlock
{
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSString *tmpFile2 = [tmpDirectory stringByAppendingPathComponent:@"kids.mp4"];
    NSString *tmpFile = [tmpDirectory stringByAppendingPathComponent:@"tempSound.mp4"];
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"kids"
                                                         ofType:@"mp4"];
    // NSData* data = [NSData dataWithContentsOfFile: filePath];
    //[data writeToFile: tmpFile atomically:YES];
    NSError *error;
    if([[NSFileManager defaultManager] copyItemAtPath:filePath toPath:tmpFile2 error: &error]){
        //NSLog(@"File successfully copied");
        
    } else {
        
        //  [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"error", nil) message: NSLocalizedString(@"failedcopydb", nil)  delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil)  otherButtonTitles:nil] show];
        //NSLog(@"Error description-%@ \n", [error localizedDescription]);
        //NSLog(@"Error reason-%@", [error localizedFailureReason]);
        
        
    }
    
    [[NSFileManager defaultManager] moveItemAtPath:tmpFile2 toPath:tmpFile error: &error];
    
    //NSLog(@"Error description-%@ \n", [error localizedDescription]);
    //NSLog(@"Error reason-%@", [error localizedFailureReason]);
    if (completionBlock) {
        completionBlock(YES, tmpFile);
    }
    
    
    
    
    /*
     [self loadSoundDataInBackgournd:^(NSData *data, NSError *error) {
     if(!error && data)
     {
     NSString *tmpDirectory = NSTemporaryDirectory();
     NSString *tmpFile = [tmpDirectory stringByAppendingPathComponent:@"tempSound.mp4"];
     
     [data writeToFile: tmpFile atomically:YES];
     
     if (completionBlock) {
     completionBlock(YES, tmpFile);
     }
     
     }else
     {
     if (completionBlock) {
     completionBlock(NO, nil);
     }
     }
     }];
     */
}

+(NSMutableArray*) sortDubSoundArray: (NSArray*) array
{
    //  NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: YES];
    // return [myArray sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]];
    NSMutableArray* results = [NSMutableArray arrayWithArray: array];
    [results sortUsingComparator:(NSComparator)^(DubSound *a1, DubSound *a2) {
        return a1.score < a2.score;
    }];
    
    return results;
}

//TODO finish it
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        soundName = [decoder decodeObjectForKey:@"soundName"];
        duration = [decoder decodeFloatForKey:@"duration"];
        creator = [DubUser CurrentDubUser];
        tags = [decoder decodeObjectForKey:@"tags"];
        soundLanguage = [decoder decodeObjectForKey:@"soundLanguage"];
        offlineFileName = [decoder decodeObjectForKey:@"offlineFileName"];
        
        [self connectedParseObject];
        //  self.author = [decoder decodeObjectForKey:@"name"];
    }
    return self;
}

//TODO finish it
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:soundName forKey:@"soundName"];
    [encoder encodeFloat:duration forKey:@"duration"];
    [encoder encodeObject:tags forKey:@"tags"];
    [encoder encodeObject:soundLanguage forKey:@"soundLanguage"];
    [encoder encodeObject:offlineFileName forKey:@"offlineFileName"];
}
@end
