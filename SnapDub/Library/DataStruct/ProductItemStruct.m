//
//  LifeStyleEventData.m
//  WineConcierge
//
//  Created by GoldenDragon on 16/10/14.
//  Copyright (c) 2014 GisMobile. All rights reserved.
//

#import "ProductItemStruct.h"
#import "Utils.h"


@implementation ProductItemStruct

-(id) init{
    eventid   = 0;
    createrid = 0;
    strPostdate = @"";
    
    strName = @"";
    streventDate = @"";
    strCountry = @"";
    strlocality = @"";
    strStreet = @"";
    strDescription = @"";
    strImageUrl = @"";
    firstname = @"";
    lastname = @"";
    related = @"";
    
    strattribute = @"";
    strqrcode = @"";
    aryPassions = [[NSMutableArray alloc] init];
    aryAdmin = [[NSMutableArray alloc] init];
    dicLocation = [[NSMutableDictionary alloc] init];

    Invite = [[NSMutableArray alloc] init];
    aryAttend = [[NSMutableArray alloc] init];
    aryParticipant = [[NSMutableArray alloc] init];
    return self;
}



- (NSInteger) getEventId
{
    return eventid;
}
- (NSInteger) getCreaterId
{
    return createrid;
}
- (NSString *) getPostDate{
    return strPostdate;
}

- (NSString *) getEventName{
    return strName;
}

- (NSString *) getDescription{
    return  strDescription;
}
- (NSString *) getEventDate{
    return streventDate;
}
- (NSString *) getCountry
{
    return strCountry;
}
- (NSString *) getLocality{
    return strlocality;
}
- (NSString *) getStreet{
    return strStreet;
}
- (NSString *) getImageUrl{
    return strImageUrl;
}

- (NSString *) getFistName
{
    return firstname;
}
- (NSString *) getLastname
{
    return lastname;
}
- (NSString *) getrelated
{
    return related;
}

- (NSString *) getAttribute
{
    return strattribute;
}
- (NSString *) getQrcode{
    return strqrcode;
}
- (NSMutableArray *) getPassions{
    return aryPassions;
}
- (NSMutableArray *) getAdmin{
    return aryAdmin;
}
- (NSMutableDictionary *) getLocation{
    return dicLocation;
}


- (NSMutableArray *) getInvite{
    return Invite;
}

- (NSMutableArray *) getAttend{
    return aryAttend;
}
- (NSMutableArray *) getParticipant{
    return  aryParticipant;
}



-(void) putCountry:(NSString *)country locality:(NSString *)locality street:(NSString *)street{
    strCountry = country;
    strlocality = locality;
    strStreet = street;
}

-(void) putInvite:(NSMutableArray *)invitePeople{
    Invite = [[NSMutableArray alloc] initWithArray:invitePeople];
}

-(void) putLoation:(NSMutableDictionary *)diclocation{
    dicLocation = [[NSMutableDictionary alloc] initWithDictionary:diclocation];
    
}
-(void) putPassion:(NSMutableArray *)arypassion{
    aryPassions = [[NSMutableArray alloc] initWithArray:arypassion];
}
-(void) putAdmin:(NSMutableArray *)aryadmin{
    aryAdmin = [[NSMutableArray alloc] initWithArray:aryadmin];
}

- (void)initWithJSONData:(NSDictionary *)arrDict
{
    if (arrDict == nil || [arrDict count] < 3)
        return;
    
    eventid = [[arrDict objectForKey:@"eventid"] integerValue];
    createrid = [[arrDict objectForKey:@"userid"] integerValue];
    
    strName = [Utils getStringValue:[arrDict objectForKey:@"name"]];
    streventDate = [Utils getStringValue:[arrDict objectForKey:@"eventdate"]];
    strCountry = [Utils getStringValue:[arrDict objectForKey:@"country"]];
    strlocality = [Utils getStringValue:[arrDict objectForKey:@"locality"]];
    strStreet = [Utils getStringValue:[arrDict objectForKey:@"street"]];
    strDescription = [Utils getStringValue:[arrDict objectForKey:@"desciption"]];
    strImageUrl = [Utils getStringValue:[NSString stringWithFormat:@"%@/%@", EVENT_PHOTO_SUFFIX_URL, [arrDict objectForKey:@"imageurl"]]];
    firstname = [Utils getStringValue:[arrDict objectForKey:@"firstname"]];
    lastname = [Utils getStringValue:[arrDict objectForKey:@"lastname"]];
    switch ([[arrDict objectForKey:@"joincount"] integerValue])
    {
        case 0:
            related = @"inivited";
            break;
        case 1:
            related = @"created";
            break;
        case 2:
            related = @"";
            break;
        default:
            break;
    }
    strattribute = [Utils getStringValue:[arrDict objectForKey:@"attribute"]];
    strqrcode = [Utils getStringValue:[arrDict objectForKey:@"qrcode"]];
    aryPassions = [[NSMutableArray alloc] initWithArray:[arrDict objectForKey:@"passion"]];
    aryAdmin = [[NSMutableArray alloc] initWithArray:[arrDict objectForKey:@"admin"]];
    dicLocation = [[NSMutableDictionary alloc] initWithDictionary:[arrDict objectForKey:@"location"]];
    
    Invite = [[NSMutableArray alloc] initWithArray:[arrDict objectForKey:@"invite_people"]];
    aryAttend = [[NSMutableArray alloc] initWithArray:[arrDict objectForKey:@"attend_people"]];
    aryParticipant = [[NSMutableArray alloc] initWithArray:[arrDict objectForKey:@"part_people"]];
    
}

-(NSDictionary *)getEvent{
    NSDictionary *arrdic = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%i", (int)eventid], @"evntid",
                            [NSString stringWithFormat:@"%i", (int)createrid], @"userid",
                            strPostdate, @"postdate",
                            
                            strName, @"name",
                            streventDate, @"eventdate",
                            strCountry, "country",
                            strlocality, @"locality",
                            strStreet, @"street",
                            strDescription, @"description",
                            strImageUrl,@"imageurl",
                            firstname,@"firstname",
                            lastname,@"lastname",
                            related,@"related",
                            
                            strattribute,@"attribute",
                            strqrcode,@"grcode",
                            aryPassions,@"passion",
                            aryAdmin,@"admin",
                            dicLocation,@"location",
                            
                            Invite, @"invite",
                            aryAttend, @"attend_people",
                            aryParticipant, @"part_people",
                            nil];
    return arrdic;
}





@end