//
//  DubSearchHelper.h
//  SnapDub
//
//  Created by Infinidy_jiawei on 2015-07-02.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DubSearchHelper : NSObject

+(void) GetAllDubSoundsInBackground: (NSString*) searchString cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* results, NSError *error))completionBlock;

+(void) GetAllDubVideoInBackground: (NSString*) searchString cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* results, NSError *error))completionBlock;


+(void) GetAllDubUserInBackground: (NSString*) searchString cachePolicy: (PFCachePolicy) policy block: (void (^)(NSArray* results, NSError *error))completionBlock;

+(NSArray *) translateSearhString: (NSString *)searchString;

+(void) GetAllSoundDataInBackground:(NSString *)searchString cachePolicy:(PFCachePolicy)policy block:(void (^)(NSArray *, NSError *))completionBlock;

@end
