//
//  PFImageLoadingView.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-06-02.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseUI/PFImageView.h>


@interface PFImageLoadingView : PFImageView

- (void)loadInBackground:(void (^)(UIImage *image, NSError *error))completion;

@end
