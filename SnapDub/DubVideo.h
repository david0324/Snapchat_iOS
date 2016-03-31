//
//  DubVideo.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-01.
//
//

#import <Foundation/Foundation.h>


@class DubUser, DubSound, DubCategory;
typedef enum {
    
    NOINITIALIZED,
    LIKED,
    UNLIKED
    
} LikeStatus;

@interface DubVideo : NSObject<NSCoding>
{
    NSString* videoName;
    DubUser* creator;
    
    int playCount;
    int likeCount;
    int shareCount;
    float duration;
    int problemReportedCount;
    
    NSDate* createdDate;
    PFObject* linkedSoundPFObject;
    PFFile* videoFile;
    NSString* offlineFileName;
    
    NSString* linkedSoundOfflineName;
  //  NSData* videoData;
    
    PFObject* connectedParseObject;
    NSString* description;
    
    LikeStatus likeStatus;
    DubSound* connectedDubSound;
    
    //adding preview image by jiawei
    PFFile *previewImage;
    DubCategory* dubCategory;
}



@property (nonatomic, assign)int playCount;
@property (nonatomic, assign)int likeCount;
@property (nonatomic, assign)int commentCount;
@property (nonatomic, assign)int shareCount;
@property (nonatomic, assign)float duration;
@property (nonatomic, assign)int problemReportedCount;

@property (nonatomic, strong)NSString* videoName;
@property (nonatomic, strong)DubUser* creator;
@property (nonatomic, strong)NSDate* createdDate;
@property (nonatomic, strong)PFObject* linkedSoundPFObject;
@property (nonatomic, strong)DubSound* connectedDubSound;
@property (nonatomic, strong)PFFile* videoFile;

@property (nonatomic, strong)NSString* offlineFileName;
@property (nonatomic, strong)NSString* linkedSoundOfflineName;
@property (nonatomic, strong)NSString* description;

@property (nonatomic, strong)NSData* videoData;

@property (nonatomic, strong)PFObject* connectedParseObject;
@property (nonatomic, strong)PFFile *previewImage;

@property (nonatomic, strong) DubCategory* dubCategory;

-(void) loadVideoFileDataFromParse: (void (^)(NSData* , NSError*))completionBlock;
-(void) setConnectedParseObject:(PFObject *)theconnectedParseObject;
-(void) saveVideoToParseEventuallyWithBlcok:(void (^)(BOOL , NSError*))completionBlock;
-(void) loadVideoDataInBackgournd: (void (^)(NSData* data, NSError *error))completionBlock;
-(void) saveFileToTempFolderInBackground: (void(^)(BOOL result, NSString* filePath)) completionBlock;
-(void) like;
-(void) unlike;
-(BOOL) isTheSameVideo: (DubVideo*) another;
-(BOOL) isLikedByCurrentUser;
-(BOOL) isLikeStatusInitialed;
@end
