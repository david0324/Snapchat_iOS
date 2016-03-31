//
//  DubSound.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-01.
//
//

#import <Foundation/Foundation.h>

@class DubUser, DubCategory;
@interface DubSound : NSObject<NSCoding>
{
    NSString* soundName;
    float duration;
    DubUser* creator;
    
    int playCount;
    int likeCount;
    int problemReportedCount;
    
    NSDate* createdDate;
    PFFile* soundPFFile;
    NSArray* tags;
    NSString* soundLanguage;
    
    PFObject* connectedParseObject;
    NSString* offlineFileName;
    
    int score;
}

@property (nonatomic, assign) float duration;
@property (nonatomic, assign) int playCount;
@property (nonatomic, assign) int likeCount;
@property (nonatomic, assign) int problemReportedCount;
@property (nonatomic, assign) int score;

@property (nonatomic, strong) NSString* soundName;
@property (nonatomic, strong) DubUser* creator;

@property (nonatomic, strong)NSDate* createdDate;
@property (nonatomic, strong)PFFile* soundPFFile;
@property (nonatomic, strong)NSArray* tags;
@property (nonatomic, strong)NSString* soundLanguage;
@property (nonatomic, strong)NSString* offlineFileName;

@property (nonatomic, strong)PFObject* connectedParseObject;
@property (nonatomic, strong)DubCategory* category;

-(void) setSoundData: (NSData*) data;
-(void) setSoundDataFromLocalFilePath: (NSString*) path;
-(void) setConnectedParseObject:(PFObject *)theconnectedPFObject;
-(void) loadSoundDataInBackgournd: (void (^)(NSData* data, NSError *error))completionBlock;
-(void) saveSoundToParseInBackgrountWithBlock: (void (^)(BOOL , NSError*))completionBlock;

+(void) createADubSoundWithLocalURL: (NSString*) fileName block:(void (^)(DubSound*, BOOL , NSError*))completionBlock;
-(void) like;
-(void) unlike;
-(BOOL) isLikedByCurrentUser;
-(BOOL) isTheSameSound: (DubSound*) another;
-(void) saveFileToTempFolderInBackground: (void(^)(BOOL result, NSString* filePath)) completionBlock;
+(NSMutableArray*) sortDubSoundArray: (NSArray*) array;
@end
