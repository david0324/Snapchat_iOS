//
//  DubComment.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-06-30.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DubUser;
@interface DubComment : NSObject

@property (strong, nonatomic) NSString* comment;
@property (strong, nonatomic) DubUser* creator;
@property (strong, nonatomic) NSDate* date;

-(id) initWithPFObject: (PFObject*) object;
@end
