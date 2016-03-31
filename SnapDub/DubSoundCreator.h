//
//  DubSoundCreator.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-18.
//
//

#import <Foundation/Foundation.h>

@class DubCategory;
@interface DubSoundCreator : NSObject

+(void) setSoundName: (NSString*) name;
+(void) setSoundData: (NSData*) data;
+(void) setLanguage: (NSString*) theLanguage;
+(void) setTags: (NSArray*) array;
+(void) setLocalDataFilePath: (NSString*) file;
+(void) setCategory: (DubCategory*) m;
+(void) setDuration: (float) m;
+(void) setOfflineFileName: (NSString*) m;

+(void) CreateADubSoundByCurrentUserInBackground:(void(^)(BOOL result, NSError* error)) completeBlock;
@end
