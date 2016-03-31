//
//  GeneralUtility.m
//  TurntableMusicPlayer
//
//  Created by Xun_Cai on 2015-03-23.
//
//

#import "GeneralUtility.h"
#import "AppDelegate.h"

#define TIMEOUT_TIME 6.0
static GeneralUtility* utility;
@implementation GeneralUtility

+(UIColor*) getColorByIndex: (int) index
{
    UIColor* a = [[self class] GetColorRGB:255 :80 :80];
    UIColor* b = [[self class] GetColorRGB:202 :92 :230];
    UIColor* c = [[self class] GetColorRGB:51 :153 :255];
    UIColor* d = [[self class] GetColorRGB:163 :204 :41];
    
    NSArray* array = @[a, b, c, d];
    
    return [array objectAtIndex: index%4];
}

+(UIColor*) GetColorRGB: (float) r :(float)g :(float) b
{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

+ (int)randomValueBetween:(int)min and:(int)max {
    return (int)(min + arc4random_uniform(max - min + 1));
}

+(void) animateAButton: (UIButton*) button delay: (float) delay repeatTime: (int) times
{
    NSTimeInterval beginTime = CACurrentMediaTime();
    CAKeyframeAnimation* transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    transformAnimation.removedOnCompletion = NO;
    transformAnimation.repeatCount = times;
    transformAnimation.duration = 1.4f;
    transformAnimation.beginTime = beginTime - delay;
    transformAnimation.keyTimes = @[@(0.0f), @(0.5f), @(1.0f)];
    
    transformAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                           [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                           [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    transformAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 0.0f)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2f, 1.1f, 0.0f)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 0.0f)]];
}

+(GeneralUtility*) ShareUtility
{
    if(!utility)
    {
        utility = [[GeneralUtility alloc] init];
    }
    
    return utility;
}

+(NSString*) getDateDiffString: (NSDate*) date
{
    if(!date)
        return @"";
    
    NSDate* currentDate = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitMinute |  NSCalendarUnitHour | NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                               fromDate:date
                                                 toDate:currentDate
                                                options:0];
  //  //NSLog(@"Date now is %@", currentDate);
 ///   //NSLog(@"Date then is %@", date);
   // //NSLog(@"Difference in date components: %li/%li/%li", (long)components.day, (long)components.month, (long)components.year);
    
    
    if (components.month<1) {
        
        if(components.day<1)
        {
            if(components.hour<1)
            {
                if(components.minute<2)
                {
                    return @"Now";
                }else
                {
                    return [NSString stringWithFormat: @"%li minutes ago", components.minute];
                }
                
            }else
            {
                return [NSString stringWithFormat: @"%li hours ago", components.hour];
            }
        }else
        {
            return [NSString stringWithFormat: @"%li days ago", components.day];
        }
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd"];
    
    return [formatter stringFromDate: date];
}

+(void) showTimeOutMessage
{
    [[self class] popupMessage:@"ERROR" message:@"Could not connect to the server. Please make sure you have an internet connection and try again."];
}

+(void) cancelTimeOut: (id) b
{
    [NSObject cancelPreviousPerformRequestsWithTarget: b
                                             selector:@selector(timeOut)
                                               object:nil];
}

+(void) scheduleTimeOut: (id) b
{
    
    [b performSelector:@selector(timeOut) withObject:nil afterDelay: TIMEOUT_TIME];
}

+(void) popupMessage: (NSString*) title message:(NSString*) msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

+(void) greyOutButton: (UIButton*) myButton
{
    myButton.alpha = 0.5;
    myButton.enabled = NO;
}

+(void) pushViewController:(UIViewController*) controller animated: (BOOL) animation
{
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    UITabBarController *nav= (UITabBarController *)delegate.navi;
    
    [(UINavigationController*)nav.selectedViewController pushViewController:controller animated: animation];
}

+(NSString*) NSdateToNSString: (NSDate*) date
{
    return @"09 May 16";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy MM dd"];
    
    //Optionally for time zone conversions
   // [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    return [formatter stringFromDate:date];
}

+(NSString*) TrimString: (NSString*) string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+(NSString*) TrimAndLowerCaseString: (NSString*) string
{
    return [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
}

+(BOOL) isParseReachable
{
    return [[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)];
}

+(BOOL) IsTheSameParseObject: (PFObject*) object1 :(PFObject*) object2
{
    
    //Since we enable local datastore, the same object only have one instance.
    
    
    if(object1 == nil || object2 == nil)
    {
        return object1 == object2;
    }
    
    return [object1.objectId isEqualToString: object2.objectId] && [object1.parseClassName isEqualToString: object2.parseClassName];
     
}

+ (NSString *)uuid
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge_transfer NSString *)uuidStringRef;
}

+(NSError*) generateError: (NSString*) reason
{
    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
    [errorDetail setValue:reason forKey:NSLocalizedDescriptionKey];
    NSError* error = [NSError errorWithDomain:@"myDomain" code:100 userInfo:errorDetail];
    return error;
}

+(NSString*) getFilePathOfAFileNameInDocumentFolder: (NSString*) fileName folder:(NSString*) folderName
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    if(folderName && [folderName length]>0)
        basePath = [basePath stringByAppendingPathComponent: folderName ];
    
    return [basePath stringByAppendingPathComponent: fileName ];
}

+(void) processUserImage:(UIImageView *)imageview
{
    imageview.layer.cornerRadius = imageview.frame.size.height / 2;
    imageview.layer.masksToBounds = YES;
    imageview.layer.borderWidth = 0;
    [imageview.layer setBorderColor:[[UIColor colorWithRed:255.0 / 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:1.0] CGColor]];
    float fBorderWidth = imageview.frame.size.height / 50;
    [imageview.layer setBorderWidth:fBorderWidth];
}

@end
