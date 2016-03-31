//
//  DubVideoCreator.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-18.
//
//

#import <Foundation/Foundation.h>
@class DubSound, DubCategory;

@interface DubVideoCreator : NSObject

+(void) resetData;
+(void) setVideoName: (NSString*) name;
+(void) setDescription: (NSString*) des;
+(void) setVideoData: (NSData*) data;
+(void) setDubSoundRef: (DubSound*) ref;
+(BOOL) createADubVideoByCurrentUser;
+(void) setDuration: (float) m;
+(void) setDubCategory: (DubCategory*) m;
//new
+(void) setPreviewImageFile:(PFFile *)image;
@end
