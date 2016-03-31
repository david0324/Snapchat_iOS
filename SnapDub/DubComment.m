//
//  DubComment.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-06-30.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "DubComment.h"
#import "DubUser.h"
#import "SDConstants.h"


@implementation DubComment
@synthesize comment, creator, date;

-(id) initWithPFObject: (PFObject*) object
{
    if(self == [super init])
    {
        comment = [object objectForKey: kSDCommentCommentKey];
        creator = [[DubUser alloc] init];
        [creator setConnectedParseObject: [object objectForKey: kSDCommentFromUserRefKey ]];
        date = [object createdAt];
    }
    
    return self;
}

@end
