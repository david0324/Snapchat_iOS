//
//  CategoryManager.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-27.
//
//

#import <Foundation/Foundation.h>

@interface DubCategoryManager : NSObject
{

}

+(void) loadAllCategoriesFromParseInBackground: (void (^)(NSArray* , NSError *))completionBlock;
+(NSArray*) GetAllCategories;
@end
