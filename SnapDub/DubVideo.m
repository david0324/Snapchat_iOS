//
//  DubVideo.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-01.
//
//

#import "DubVideo.h"
#import "DubUser.h"
#import "SDConstants.h"
#import "DubVideoParseHelper.h"
#import "GeneralUtility.h"
#import "DubSound.h"
#import "SDFilesNeededToBeUploaded.h"
#import "DubVideoCollectionManager.h"
#import "DubCategory.h"

#import <AVFoundation/AVFoundation.h>

@implementation DubVideo
@synthesize playCount, likeCount, shareCount, duration, problemReportedCount, videoName, creator, createdDate, linkedSoundPFObject, videoFile, offlineFileName, linkedSoundOfflineName, videoData, connectedParseObject, description, connectedDubSound, previewImage, dubCategory, commentCount;

-(PFObject*) connectedParseObject
{
    if(connectedParseObject)
    {
        return connectedParseObject;
    }
    
    PFObject* videoObject = [PFObject objectWithClassName: kSDDubVideoClassName];
    [videoObject pin];
    if(videoName)
        videoObject[kSDDubVideoVideoNameKey] = videoName;
    videoObject[kSDDubVideoCreatorKey] = [PFUser currentUser];
    videoObject[kSDDubVideoDurationKey] = [NSNumber numberWithFloat: duration];
    videoObject[kSDDubVideoDescriptionKey] = self.description;
    
    if (linkedSoundPFObject)
        videoObject[kSDDubVideoLinkedSoundRefKey] = linkedSoundPFObject;
    
    if(dubCategory)
        videoObject[kSDDubVideoCategoryRefKey] = dubCategory.connectedPFObject;
    
    if (videoFile) {
        videoObject[kSDDubVideoVideoFileKey] = videoFile;
    }else
    {
        NSString* filePath = [GeneralUtility getFilePathOfAFileNameInDocumentFolder: offlineFileName folder:nil];
        
        NSData* data = [NSData dataWithContentsOfFile: filePath];
        videoFile = [PFFile fileWithData: data ];
        [videoObject setValue: videoFile forKey:kSDDubVideoVideoFileKey];
    }
    
    // code for get first frame of video(thumbnail)
//    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:] options:nil];
//    AVAssetImageGenerator* imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
//    NSError *eror = nil;
//    UIImage* image = [UIImage imageWithCGImage:[imageGenerator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:&eror]];
//    NSData *imageData = UIImagePNGRepresentation(image);
//    previewImage = [PFFile fileWithData:imageData];
    //
    
    
    videoObject[kSDOfflineFileName] = offlineFileName;
    
    PFACL *acl = [PFACL ACLWithUser:[PFUser currentUser]];
    [acl setPublicReadAccess:YES];
     videoObject.ACL = acl;
    
    connectedParseObject = videoObject;
    return connectedParseObject;
}

-(BOOL) isTheSameVideo: (DubVideo*) another
{
    return self.connectedParseObject == another.connectedParseObject;
}

-(void) setLinkedDubSound:(DubSound*) sound
{
    linkedSoundPFObject = [sound connectedParseObject];
    linkedSoundOfflineName = sound.offlineFileName;
    connectedDubSound = sound;
}

-(void) setConnectedParseObject:(PFObject *)theconnectedParseObject
{
    connectedParseObject = theconnectedParseObject;
    
    [connectedParseObject fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if(!error)
        {
            videoName = [connectedParseObject objectForKey: kSDDubVideoVideoNameKey];
            
            if([connectedParseObject objectForKey: kSDDubVideoCreatorKey])
            {
                creator = [[DubUser alloc] init];
                [creator setConnectedParseObject: [connectedParseObject objectForKey: kSDDubVideoCreatorKey] ];
            }else
            {
                //NSLog(@"DubVideo Creator is NILL");
                creator = [DubUser getARandomUser];
                //NSLog(@"DubVideo Creator new is %@", creator.connectedParseObject.objectId);
            }
            
            playCount = [[connectedParseObject objectForKey: kSDDubVideoPlayCountKey] intValue];
            likeCount = [[connectedParseObject objectForKey: kSDDubVideoLikeCountKey] intValue];
            commentCount = [[connectedParseObject objectForKey: kSDDubVideoCommentCountKey] intValue];
            
            shareCount  = [[connectedParseObject objectForKey: kSDDubVideoShareCountKey] intValue];
            duration = [[connectedParseObject objectForKey: kSDDubVideoDurationKey] floatValue];
            problemReportedCount = [[connectedParseObject objectForKey: kSDDubVideoProblemReportedCountKey] intValue];
            description = [connectedParseObject objectForKey: kSDDubVideoDescriptionKey];
            
            createdDate = [connectedParseObject createdAt];
            linkedSoundPFObject = [connectedParseObject objectForKey: kSDDubVideoLinkedSoundRefKey];
            
            if(linkedSoundPFObject)
            {
                connectedDubSound = [[DubSound alloc] init];
                [connectedDubSound setConnectedParseObject: linkedSoundPFObject];
            }
            
            videoFile = [connectedParseObject objectForKey: kSDDubVideoVideoFileKey];
            
            offlineFileName = [connectedParseObject objectForKey: kSDOfflineFileName];
        }else
        {
            //NSLog(@"ERROR: DubVideo setConnectedParseObject can't fetch data");
        }
    }];
    
}

-(void) loadVideoFileDataFromParse: (void (^)(NSData* , NSError*))completionBlock
{
    [videoFile getDataInBackgroundWithBlock:^(NSData* thedata, NSError* theError){
        if(!theError)
        {
            if(completionBlock)
            {
                completionBlock(thedata, theError);
            }
        }else{
            if (completionBlock) {
                completionBlock(nil, theError);
            }
        }
    }];
}

//Finish this
-(void) saveVideoToParseEventuallyWithBlcok:(void (^)(BOOL , NSError*))completionBlock
{
    if(videoFile == nil)
    {
        NSString* filePath = [GeneralUtility getFilePathOfAFileNameInDocumentFolder: offlineFileName folder:nil];
        
        videoFile = [PFFile fileWithData: [NSData dataWithContentsOfFile: filePath] ];
    
    }
    
    if(videoFile.getData !=nil)
    {
        [[SDFilesNeededToBeUploaded ShareInstance] addVideoFile: self];
        [DubVideoParseHelper SaveADubVideoCreatedByCurrentUserEventuallyWithBlock:self block:^(BOOL result, NSError *error) {
            
            if(!error && result)
            {
               [[SDFilesNeededToBeUploaded ShareInstance] removeVideoFile: self];
            }
            
            [[DubUser CurrentDubUser].dubVideoCollectionManager  addDubVideoToUserCreatedVideoList: self];
            
            if (completionBlock) {
                completionBlock(result, error);
            }
        }];
       
    }else
    {
        //NSLog(@"ERROR video file pffiel data is nil");
        if (completionBlock) {
            completionBlock(NO, [GeneralUtility generateError: @"saveVideoToParseEventuallyWithBlcok:video file pffiel data is nil" ]);
        }
    }

}

-(void) like
{
    [DubVideoParseHelper LikeADubVideoInBackground: self.connectedParseObject];
  //  [[DubUser CurrentDubUser].dubVideoCollectionManager addDubVideoToUserLikedVideoList: self];
}

-(void) unlike
{
    [DubVideoParseHelper UnlikeADubVideoInBackground: self.connectedParseObject];
 //   [[DubUser CurrentDubUser].dubVideoCollectionManager removeDubVideoFromUserLikedVideoList: self];
}


//For Testing
+(void) createADubVideoWithLocalURL: (NSString*) url sound:(DubSound*) sound block:(void (^)(DubVideo*, BOOL , NSError*))completionBlock
{
    UIImage* imageToSave = [UIImage imageWithContentsOfFile:@"justin1.png"];
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSData * binaryImageData = UIImagePNGRepresentation(imageToSave);
    
    NSString* filePath = [basePath stringByAppendingPathComponent: url];
    [binaryImageData writeToFile:filePath atomically:YES];
    
    
    DubVideo* video = [DubVideo init];
    video.offlineFileName = filePath;
    video.videoName = @"haha";
    [video setLinkedDubSound: sound];
    [video saveVideoToParseEventuallyWithBlcok:^(BOOL result, NSError *error) {
        //NSLog(@"Saving video result is %d", result);
        
        if(completionBlock)
            completionBlock(video, result, error);
    }];
    
}

-(void) loadVideoDataInBackgournd: (void (^)(NSData* data, NSError *error))completionBlock
{
    [videoFile getDataInBackgroundWithBlock:^(NSData* thedata, NSError* theError){
        
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




-(void) saveFileToTempFolderInBackground: (void(^)(BOOL result, NSString* filePath)) completionBlock
{
    [self loadVideoDataInBackgournd:^(NSData *data, NSError *error) {
        if(!error && data)
        {
            NSString *tmpDirectory = NSTemporaryDirectory();
            NSString *tmpFile = [tmpDirectory stringByAppendingPathComponent:@"tempVideo.mp4"];
            
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
}




-(BOOL) isCreatedByCurrentUser
{
    return [creator isTheSameUser: [DubUser CurrentDubUser]];
}

-(BOOL) isLikedByCurrentUser
{
    return likeStatus == LIKED;
}

-(BOOL) isLikeStatusInitialed
{
    return likeStatus != NOINITIALIZED;
}

//TODO finish it
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        videoName = [decoder decodeObjectForKey:@"videoName"];
        offlineFileName = [decoder decodeObjectForKey:@"offlineFileName"];
        linkedSoundOfflineName =[decoder decodeObjectForKey:@"linkedSoundOfflineName"];
        
        duration = [decoder decodeFloatForKey:@"duration"];
        creator = [DubUser CurrentDubUser];
        connectedParseObject = [self connectedParseObject];
    }
    return self;
}

//TODO finish it
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:videoName forKey:@"videoName"];
    [encoder encodeObject:offlineFileName forKey:@"offlineFileName"];
    [encoder encodeObject: linkedSoundOfflineName forKey: @"linkedSoundOfflineName"];
    
    [encoder encodeFloat: duration forKey: @"duration"];
}

@end
