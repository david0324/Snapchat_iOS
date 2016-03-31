//
//  DubVideoCollectionManager.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-04.
//
//

#import <UIKit/UIKit.h>

@class DubUser, DubVideo;
@interface DubVideoCollectionManager : NSObject
{
    NSMutableArray* userCreatedDubVideos;
    NSMutableArray* userLikedDubVideos;
    
    DubUser* owner;
}

@property (nonatomic, strong) NSMutableArray* userCreatedDubVideos;
@property (nonatomic, strong) NSMutableArray* userLikedDubVideos;
@property (nonatomic,strong)DubUser* owner;

-(id) initWithPFUser: (DubUser*) m;
-(void) loadUsreCreatedDubVideosFromParseInBackgroundWithBlock: (void(^)(NSArray*, NSError*))completionBlock;
-(void) loadUserLikedDubVideosFromParseInBackgroundWithBlock: (void(^)(NSArray*, NSError*))completionBlock;
-(void) addDubVideoToUserCreatedVideoList: (DubVideo*) video;
-(void) addDubVideoToUserLikedVideoList: (DubVideo*) video;
-(void) removeDubVideoFromUserLikedVideoList:(DubVideo*) video;

-(BOOL) isDubVideoLikedByOwner: (DubVideo*) video;

-(void) loadInfoFromParseInBackground:(BOOL) fromLocalDatastore block: (void(^)(NSArray* userCreatedVideos, NSArray* userLikedVideos, NSError* error)) completionBlock;
@end
