//
//  Common.h
//  SoundCapture
//
//  Created by choe on 4/27/15.
//  Copyright (c) 2015 bong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

+(NSArray*)applicationDocuments;

+(NSString*)applicationDocumentsDirectory;

+(NSURL*)withFilePathURL : (NSString *)filename extension:(NSString *)extension;

@end
