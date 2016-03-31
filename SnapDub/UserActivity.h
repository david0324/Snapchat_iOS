//
//  UserActivity.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-07-02.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DubUser, DubVideo, DubSound;
@interface UserActivity : NSObject

@property (nonatomic, strong) NSString* activityType;
@property (nonatomic, strong) DubUser* fromUserRef;
@property (nonatomic, strong) DubUser* toUserRef;
@property (nonatomic, strong) DubSound* soundRef;
@property (nonatomic, strong) DubVideo* videoRef;
@property (nonatomic, strong) NSDate* createdAt;

@property (strong, nonatomic) PFObject* connectedPFObject;
@end
