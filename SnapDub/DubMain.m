//
//  DubMain.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-06-07.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "DubMain.h"
#import "DubUser.h"

@implementation DubMain

+(void) LoadInitialDataWithBlock: (void (^)(BOOL result, NSError *error))completionBlock
{
    if([PFUser currentUser].objectId == nil)
    {
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(!succeeded || error)
            {
                [DubUser initUserLists:^(BOOL result) {
                    if(completionBlock)
                    {
                        completionBlock(result, error);
                    }
                }];
                
            }else
            {
                [DubUser loadCurrentUserInBackgroundWithBlock:kPFCachePolicyCacheThenNetwork block:^(BOOL result, NSError *error) {
                    
                    //NSLog(@"LoadInitialDataWithBlock loadCurrentUserInBackgroundWithBlock DONE");
                    
                    [DubUser initUserLists:^(BOOL result) {
                        if(completionBlock)
                        {
                            completionBlock(result, error);
                        }
                    }];
                    
                }];
            }
            
        }];
    }else
    {
    
        [DubUser loadCurrentUserInBackgroundWithBlock:kPFCachePolicyCacheThenNetwork block:^(BOOL result, NSError *error) {
            
            //NSLog(@"LoadInitialDataWithBlock loadCurrentUserInBackgroundWithBlock DONE");
            
            completionBlock(YES, nil);
            [DubUser initUserLists:^(BOOL result) {
                if(completionBlock)
                {
                    completionBlock(result, error);
                }
            }];
            
            
            
        }];
    }
    
    
}

@end
