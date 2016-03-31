//
//  LifeStyleEventData.h
//  WineConcierge
//
//  Created by GoldenDragon on 16/10/14.
//  Copyright (c) 2014 GisMobile. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserInfoStruct : NSObject
{
    NSString *strID;
    NSString *strName;
    NSString *strEmail;
    NSString *strPassword;

    NSString *strPhotoUrl;
    NSString *strToken;
    NSString *strFacebookid;
}

- (void)initWithData:(NSDictionary *)arrDict;
- (void)initWithDataEmail:(NSString *)email appuserid:(NSString *)appuserid name:(NSString *)name photourl:(NSString *)photourl;
- (void)initWithFacebookSigninData:(NSString *)email appuserid:(NSString *)appuserid name:(NSString *)name photourl:(NSString *)photourl;
- (NSDictionary *)getUserInfo;

- (NSString *) getid;
- (NSString *)getName;
- (NSString *)getEmail;
- (NSString *)getPasssword;
- (NSString *)getPhotoUrl;
- (NSString *)getToken;
- (NSString *)getFacebookid;


@end