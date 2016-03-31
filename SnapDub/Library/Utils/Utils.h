//
//  Utils.h
//  FuzzIT
//
//  Created by GISLeader on 6/21/14.
//  Copyright (c) 2014 Fuzzit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define USER_SUFFIX_URL                      @"http://52.10.17.225/eventpost/index.php/mobile/user"
#define USER_PHOTO_SUFFIX_URL                @"http://52.10.17.225/eventpost/upload/profile"
#define EVENT_PHOTO_SUFFIX_URL               @"http://52.10.17.225/eventpost/upload/event"
#define EVENT_SUFFIX_URL                     @"http://52.10.17.225/eventpost/index.php/mobile/event"
//signin


#define KEY_TWITTER_CONSUMER            @"gqQpzmFtkKb5POxOSyyJieUce"
#define KEY_TWITTER_CONSUMER_SECRET     @"1g9Agql3FqZmYET10jlAXYMrVPBlokEyiW2uWdvKZhEUdl4JqL"


enum RequestType
{    
    REQUEST_ADD_CART,
    REQUEST_ADD_FAVORITE,
    REQUEST_SIGNIN,
};

// Notification IDS
#define NOTI_REMOTE_CART_UPDATE             @"UPDATE_CART_REMOTE"
#define NOTI_LOCAL_CART_UPDATE              @"UPDATE_CART_LOCAL"

// Payment
#define CONFIG_PAYPAL_CLIENT_ID             @"3QH6M3YHPT9NJ"


#define SYSTEM_VERSION_EQUAL_TO(version)                  ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(version)              ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version)  ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(version)                 ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version)     ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] != NSOrderedDescending)

#define IS_IPHONE_5 [[UIScreen mainScreen] bounds].size.height > 480 ? TRUE : FALSE

#define IS_IPHONE_4 ([[UIScreen mainScreen] bounds].size.height == 480 || [[UIScreen mainScreen] bounds].size.height == 960) ? TRUE : FALSE

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface Utils : NSObject

+ (BOOL)isEmailAddress:(NSString *)emailAddress;
+ (NSString *) trim:(NSString *)str;
+ (UIImage*) resizedImageWithSize:(UIImage *)orignalImg :(CGSize)size;
+ (UIImage *) convertUIViewToImage: (UIView *) aView;
+ (NSString *) getImagePath:(NSString *)strPath;
+ (NSString *) getFilterNullValue:(NSObject *)str;
+ (NSString *) getImagePathFromUrl:(NSString *)strImageURL fprefix:(NSString *)fprefix;
+ (UIImage*) imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (NSString *) getStringValue:(NSObject *)str;
+(BOOL) isBarcode:(NSString*)inputString;

@end
