//
//  LifeStyleEventData.m
//  WineConcierge
//
//  Created by GoldenDragon on 16/10/14.
//  Copyright (c) 2014 GisMobile. All rights reserved.
//

#import "UserInfoStruct.h"
#import "Utils.h"

@implementation UserInfoStruct


-(id) init
{
    strID = @"";
    strName = @"";
    strEmail     = @"";
    strPassword  = @"";
    strPhotoUrl  = @"";
    strToken     = @"";
    strFacebookid= @"";
    return self;
}

- (void)initWithData:(NSDictionary *)arrDict
{
    if (arrDict == nil || [arrDict count] < 3)
        return;
    
    strID  = [Utils getStringValue:[arrDict objectForKey:@"userid"]];
    strName  = [Utils getStringValue:[arrDict objectForKey:@"name"]];
    strEmail = [Utils getStringValue:[arrDict objectForKey:@"email"]];
    strPassword = [Utils getStringValue:[arrDict objectForKey:@"password"]];
    strPhotoUrl = [Utils getStringValue:[NSString stringWithFormat:@"%@", [arrDict objectForKey:@"photo"]]];
    
    strToken = [Utils getStringValue:[arrDict objectForKey:@"token"]];
    strFacebookid = [Utils getStringValue:[arrDict objectForKey:@"facebookid"]];
}

- (void)initWithDataEmail:(NSString *)email appuserid:(NSString *)appuserid name:(NSString *)name photourl:(NSString *)photourl{
    strID = appuserid;
    strEmail = email;
    strPhotoUrl = photourl;
    strName = name;
    
}


- (void)initWithFacebookSigninData:(NSString *)email appuserid:(NSString *)appuserid name:(NSString *)name photourl:(NSString *)photourl
{
    strID = @"";
    strName = name;
    strEmail = email;
    strPassword = @"";
    strPhotoUrl = photourl;
    strToken = @"";
    strFacebookid = appuserid;
}

- (NSDictionary *)getUserInfo
{
    NSDictionary *arrdic = [[NSDictionary alloc] initWithObjectsAndKeys:strID, @"userid", strEmail, @"email", strPassword, @"password", strName, @"name", strPhotoUrl, "photo", strToken, @"token", strFacebookid, "facebookid", nil];
    return arrdic;

}

- (NSString *) getid
{
    return strID;
}

- (NSString *)getName
{
    return strName;
}

- (NSString *)getEmail
{
    return strEmail;
}

- (NSString *)getPasssword
{
    return strPassword;
}

- (NSString *)getPhotoUrl
{
    return strPhotoUrl;
}

- (NSString *)getFacebookid
{
    return strFacebookid;
}


- (NSString *)getToken
{
    return strToken;
}


@end