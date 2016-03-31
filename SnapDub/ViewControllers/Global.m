//
//  Global.m
//  SaltforSilk
//
//  Created by marco on 31/1/15.
//  Copyright (c) 2015 Xiao. All rights reserved.
//


#import "Global.h"
#import "AppDelegate.h"



UIImage* ResizeImage(UIImage *image, CGFloat width, CGFloat height)
{
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

