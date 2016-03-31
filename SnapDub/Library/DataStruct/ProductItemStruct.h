//
//  LifeStyleEventData.h
//  WineConcierge
//
//  Created by GoldenDragon on 16/10/14.
//  Copyright (c) 2014 GisMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductItemStruct : NSObject
{
    NSInteger eventid;
    NSInteger createrid;
    NSString *strPostdate;
    
    NSString *strName;
    NSString *streventDate;
    NSString *strCountry;
    NSString *strlocality;
    NSString *strStreet;
    NSString *strDescription;
    NSString *strImageUrl;
    NSString *firstname;
    NSString *lastname;
    NSString *related;
    
    NSString *strattribute;
    NSString *strqrcode;
    NSMutableArray *aryPassions;
    NSMutableArray *aryAdmin;
    NSMutableDictionary *dicLocation;

    NSMutableArray *Invite;
    NSMutableArray *aryAttend;
    NSMutableArray *aryParticipant;
}


- (void)initWithJSONData:(NSDictionary *)arrDict;

- (NSInteger) getEventId;
- (NSInteger) getCreaterId;
- (NSString *) getPostDate;

- (NSString *) getEventName;
- (NSString *) getDescription;
- (NSString *) getEventDate;
- (NSString *) getCountry;
- (NSString *) getLocality;
- (NSString *) getStreet;
- (NSString *) getImageUrl;
- (NSString *) getrelated;
- (NSString *) getFistName;
- (NSString *) getLastname;

- (NSString *) getAttribute;
- (NSString *) getQrcode;
- (NSMutableArray *) getPassions;
- (NSMutableArray *) getAdmin;
- (NSMutableDictionary *) getLocation;

- (NSMutableArray *) getInvite;
- (NSMutableArray *) getAttend;
- (NSMutableArray *) getParticipant;


-(void) putCountry:(NSString *)country locality:(NSString *)locality street:(NSString *)street;
-(void) putLoation:(NSMutableDictionary *)diclocation;
-(void) putInvite:(NSMutableArray *)invitePeople;
-(void) putPassion:(NSMutableArray *)arypassion;
-(void) putAdmin:(NSMutableArray *)aryadmin;

-(NSDictionary *)getEvent;


@end