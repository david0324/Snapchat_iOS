//
//  AdsSettingsModel.h
//  ParseStarterProject
//
//  Created by Jeet on 11/07/15.
//
//

#import <Foundation/Foundation.h>

@interface AdsSettingsModel : NSObject{
    NSInteger adIndex;
    NSString *adType;
    NSInteger showFrequency;
    BOOL isEnabled;
}
- (id)initWithIndex:(NSInteger)adIndexParam
         withAdType:(NSString*)adTypeParam
      showFrequency:(NSInteger)showFrequencyParam
          isEnabled:(BOOL)isEnabledParam;

@property NSInteger adIndex;
@property (nonatomic, retain) NSString *adType;
@property NSInteger showFrequency;
@property BOOL isEnabled;

// properties spec to CP ads
@property (nonatomic, retain) NSString *adID;
@property (nonatomic, retain) NSDictionary *alertAdSettingsDict;
@property (nonatomic, retain) NSDictionary *fullPageAdSettingsDict;
@property (nonatomic, retain) NSURL *link;
@property BOOL showOverAds;
@property NSInteger successfulClicks;
@property NSInteger cancelClicks;


@end
