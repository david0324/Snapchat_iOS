//
//  GeneralUtility.h
//  TurntableMusicPlayer
//
//  Created by Xun_Cai on 2015-03-23.
//
//

#import <Foundation/Foundation.h>

@interface GeneralUtility : NSObject

+(void) animateAButton: (UIButton*) button delay: (float) delay repeatTime: (int) times;
+(void) greyOutButton: (UIButton*) myButton;
+(NSString*) TrimString: (NSString*) string;
+(NSString*) TrimAndLowerCaseString: (NSString*) string;
+(BOOL) isParseReachable;
+(BOOL) IsTheSameParseObject: (PFObject*) object1 :(PFObject*) object2;
+ (NSString *)uuid;
+(NSError*) generateError: (NSString*) reason;
+(NSString*) getFilePathOfAFileNameInDocumentFolder: (NSString*) fileName folder:(NSString*) folderName;
+(NSString*) NSdateToNSString: (NSDate*) date;
+(void) processUserImage:(UIImageView *)imageview;
+(void) pushViewController:(UIViewController*) controller animated: (BOOL) animation;
+(void) popupMessage: (NSString*) title message:(NSString*) msg;

+(void) scheduleTimeOut: (id) b;
+(void) cancelTimeOut: (id) b;
+(void) showTimeOutMessage;
+(NSString*) getDateDiffString: (NSDate*) date;
+ (int)randomValueBetween:(int)min and:(int)max;
+(UIColor*) GetColorRGB: (float) r :(float)g :(float) b;
+(UIColor*) getColorByIndex: (int) index;
@end
