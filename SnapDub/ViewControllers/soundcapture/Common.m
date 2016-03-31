//
//  Common.m
//  SoundCapture
//
//  Created by choe on 4/27/15.
//  Copyright (c) 2015 bong. All rights reserved.
//

#import "Common.h"

@implementation Common


#pragma mark - Utility
+(NSArray*)applicationDocuments {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
}

+(NSString*)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+(NSURL*)withFilePathURL: (NSString *)filename extension:(NSString *)extension {
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.%@",
                                   [self applicationDocumentsDirectory],
                                   filename,
                                   extension]];
}

@end
