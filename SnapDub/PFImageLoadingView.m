//
//  PFImageLoadingView.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-06-02.
//  Copyright (c) 2015 wjs. All rights reserved.
//

#import "PFImageLoadingView.h"

@implementation PFImageLoadingView

- (void)loadInBackground:(void (^)(UIImage *image, NSError *error))completion
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.center = self.center;
    [indicator setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
    [indicator startAnimating];
    [ self addSubview: indicator];
    
    [super loadInBackground:^(UIImage *image2, NSError *error2){
        if(completion)
        {
            completion(image2, error2);
        }
        
        [indicator removeFromSuperview];
    }];
}

@end
