//
//  Utils.m
//  FuzzIT
//
//  Created by GISLeader on 6/21/14.
//  Copyright (c) 2014 Fuzzit. All rights reserved.
//

#import "Utils.h"

UIViewController* g_controllerOld = nil;
NSMutableArray          *g_arrPopularTags = nil;

@implementation Utils

+ (BOOL)isEmailAddress:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:checkString];
}

+ (UIImage*) resizedImageWithSize:(UIImage *)orignalImg :(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [orignalImg drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    // An autoreleased image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *) convertUIViewToImage: (UIView *) aView
{
	UIGraphicsBeginImageContextWithOptions(aView.bounds.size, aView.opaque, 0.0);
	[aView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return img;
}

+ (NSString *) getImagePath:(NSString *)strPath
{
    if ([strPath rangeOfString:@"/winecon"].length > 0)
        return [strPath stringByReplacingOccurrencesOfString:@"/winecon"
                                              withString:@""];;
    
    return strPath;
}

+ (NSString *) getImagePathFromUrl:(NSString *)strImageURL fprefix:(NSString *)fprefix
{
    NSRange prefixRange = [strImageURL rangeOfString:fprefix];
    if ((prefixRange.location + prefixRange.length) >= strImageURL.length)
    {
        NSArray *chunks = [strImageURL componentsSeparatedByString: @"/"];
        if (chunks && [chunks count] > 0)
            return [chunks objectAtIndex:([chunks count] - 1)];
        
        return @"";
    }
    
    return [strImageURL substringFromIndex:prefixRange.location+prefixRange.length];
}

+ (NSString *) getFilterNullValue:(NSObject *)str
{
    if (!str || str == [NSNull null])
        return @"";
    
    return (NSString *)str;
}

+ (NSString *) trim:(NSString *)str
{
    if (!str)
        return @"";
    
    NSRange range;
    int idx;
    for (idx = 0; idx < str.length && [str characterAtIndex:idx] == ' '; idx++);
    
    if (idx != 0 && idx == str.length - 1)
        return @"";
    
    range.location = idx;
    for (idx = (int)str.length - 1; idx >= 0 && [str characterAtIndex:idx] == ' '; idx--);
    range.length = idx - range.location + 1;
    return [str substringWithRange:range];
}

+(BOOL) isBarcode:(NSString*)inputString
{
    BOOL isValid = NO;
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:inputString];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    return isValid;
}

+ (NSString *) getStringValue:(NSObject *)str
{
    if (!str || str == [NSNull null])
        return @"";

    if ([str isEqual:@"<null>"])
        return @"";
    
    return (NSString *)str;
}

+ (UIImage*) imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
