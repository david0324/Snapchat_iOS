//
//  FeaturedContentsManager.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-26.
//
//

#import "FeaturedContentsManager.h"
#import "SDConstants.h"
#import "DubFeaturedContentsParseHelper.h"
#import "DubSound.h"
#import "DubSoundBoard.h"
#import "DubCategory.h"

@implementation FeaturedContentsManager
static NSArray* categoriesList;

+(void) GetAllCategories: (void (^)(NSArray* , NSError *))completionBlock
{
    if([categoriesList count])
    {
        if(completionBlock)
        {
            completionBlock(categoriesList, nil);
        }
        return;
    }
    
   [DubFeaturedContentsParseHelper GetAllCategories:kPFCachePolicyCacheThenNetwork block:^(NSArray * categories, NSError *error) {
      
       if(!error)
       {
           NSMutableArray* temp = [NSMutableArray array];
           for(PFObject* object in categories)
           {
               DubCategory* c = [[DubCategory alloc] init];
               [c setConnectedPFObject: object];
               [temp addObject: c];
           }
           
           categoriesList = [NSArray arrayWithArray: temp];
       }
       
       
       
       if(completionBlock)
       {
           completionBlock(categoriesList, error);
       }
   }];
    
}

+(void) GetFeaturedSoundsForFrontPageInBackground: (void (^)(NSArray* , NSError *))completionBlock
{
    
    [DubFeaturedContentsParseHelper GetFeaturedSoundsForFrontPageInBackground:kPFCachePolicyCacheThenNetwork block:^(NSArray * sounds, NSError *error) {
        
        NSMutableArray* temp = [NSMutableArray array];
        if(!error)
        {
            for(PFObject* object in sounds)
            {
                //NSLog(@"GetFeaturedSoundsForFrontPageInBackground PFObject %@", [object objectForKey:kSDFeaturedSoundDubSoundRefKey]);
                
                if([object objectForKey:kSDFeaturedSoundDubSoundRefKey] )
                {
                    DubSound* s = [[DubSound alloc] init];
                    [s setConnectedParseObject: [object objectForKey:kSDFeaturedSoundDubSoundRefKey] ];
                    [temp addObject: s];
                }
            }
        }
        
        if(completionBlock)
        {
            completionBlock(temp, error);
        }
    }];
}

+(void) GetFeatureSoundBoardsForFrontPageInBackground: (void (^)(NSArray* , NSError *))completionBlock
{
    [DubFeaturedContentsParseHelper GetFeatureSoundBoardsForFrontPageInBackground:kPFCachePolicyCacheThenNetwork block:^(NSArray * boards, NSError *error) {
        NSMutableArray* temp = [NSMutableArray array];
        if(!error)
        {
            for(PFObject* object in boards)
            {
                if([object objectForKey: kSDFeaturedSoundboardDubSoundboardRefKey] )
                {
                    DubSoundBoard* s = [[DubSoundBoard alloc] init];
                    [s setConnectedParseObject: [object objectForKey: kSDFeaturedSoundboardDubSoundboardRefKey] ];
                    [temp addObject: s];
                }
            }
        }
        
        if(completionBlock)
        {
            completionBlock(temp, error);
        }
    }];
}

+(void) GetFeaturedSoundsOfACategory:(PFObject*) categoryObject cachePolicy:(PFCachePolicy) policy block:(void (^)(NSArray* , NSError *))completionBlock
{
    [DubFeaturedContentsParseHelper GetFeaturedSoundsOfACategoryInBackground:categoryObject cachePolicy:policy block:^(NSArray * sounds, NSError * error) {
        
        NSMutableArray* temp = [NSMutableArray array];
        if(!error)
        {
            for(PFObject* object in sounds)
            {
                if([object objectForKey:kSDFeaturedSoundDubSoundRefKey])
                {
                    DubSound* s = [[DubSound alloc] init];
                    [s setConnectedParseObject: [object objectForKey:kSDFeaturedSoundDubSoundRefKey] ];
                    [temp addObject: s];
                }
            }
        }
        
        if(completionBlock)
        {
            completionBlock(temp, error);
        }
        
    }];
}

@end
