//
//  DubCategory.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-27.
//
//

#import "DubCategory.h"
#import "SDConstants.h"

@implementation DubCategory
@synthesize categoryName, iconImageFile, orderValue, connectedPFObject;

-(void) setConnectedPFObject:(PFObject *)theconnectedPFObject
{
    connectedPFObject = theconnectedPFObject;
    
    [connectedPFObject fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if(!error)
        {
            categoryName = [theconnectedPFObject objectForKey: kSDCategoryNameKey];
            orderValue = [[theconnectedPFObject objectForKey: kSDOrderValue] floatValue];
            iconImageFile = [theconnectedPFObject objectForKey: kSDCategoryIconImageFileKey];
        }else
        {
            //NSLog(@"ERROR DubCategory fetching data failed");
        }
    }];
    
}

@end
