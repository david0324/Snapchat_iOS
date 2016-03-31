//
//  DubCategory.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-05-27.
//
//

#import <Foundation/Foundation.h>

@interface DubCategory : NSObject
{
    NSString* categoryName;
    PFFile* iconImageFile;
    float orderValue;
    
    PFObject* connectedPFObject;
}

@property (nonatomic, strong) NSString* categoryName;
@property (nonatomic, strong) PFFile* iconImageFile;
@property (nonatomic, assign) float orderValue;
@property (nonatomic, strong) PFObject* connectedPFObject;

@end
