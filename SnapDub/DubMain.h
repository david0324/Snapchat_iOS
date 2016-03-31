//
//  DubMain.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-06-07.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <Parse/Parse.h>

@interface DubMain : PFQuery

+(void) LoadInitialDataWithBlock: (void (^)(BOOL result, NSError *error))completionBlock;
@end
