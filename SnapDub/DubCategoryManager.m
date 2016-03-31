//
//  CategoryManager.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-27.
//
//

#import "DubCategoryManager.h"
#import "DubFeaturedContentsParseHelper.h"
#import "DubCategory.h"
#import "SDConstants.h"

@implementation DubCategoryManager
static NSArray* CategoryList;


+(void) loadAllCategoriesFromParseInBackground: (void (^)(NSArray* , NSError *))completionBlock
{
    if ([CategoryList count]>0) {
        
        if(completionBlock)
        {
            completionBlock(CategoryList, nil);
        }
    }
    
    [DubFeaturedContentsParseHelper GetAllCategories:kPFCachePolicyCacheThenNetwork block:^(NSArray * results, NSError * error) {
        if(!error)
        {
            
            NSMutableArray* tempArray = [NSMutableArray array];
            [PFObject pinAllInBackground: results];
            for(PFObject* object in results)
            {
                DubCategory* cat = [[DubCategory alloc] init];
                cat.categoryName = [object objectForKey: kSDCategoryNameKey];
                cat.iconImageFile = [object objectForKey: kSDCategoryIconImageFileKey];
                cat.orderValue = [[object objectForKey: kSDOrderValue] floatValue];
                [tempArray addObject: cat];
            }
            
            CategoryList = [NSArray arrayWithArray: tempArray];
        }
        
        if(completionBlock)
        {
            completionBlock(CategoryList, error);
        }
    }];
}

+(NSArray*) GetAllCategories
{
    return CategoryList;
}
@end
