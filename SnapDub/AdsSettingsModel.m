//
//  AdsSettingsModel.m
//  ParseStarterProject
//
//  Created by Jeet on 11/07/15.
//
//

#import "AdsSettingsModel.h"

@implementation AdsSettingsModel
@synthesize adIndex, adType, showFrequency, isEnabled;
@synthesize adID,alertAdSettingsDict,fullPageAdSettingsDict,link,showOverAds,successfulClicks,cancelClicks;




- (id)initWithIndex:(NSInteger)adIndexParam
         withAdType:(NSString*)adTypeParam
      showFrequency:(NSInteger)showFrequencyParam
          isEnabled:(BOOL)isEnabledParam

{
    self = [super init];
    if (self)
    {
        adIndex =adIndexParam;
        adType = adTypeParam;
        showFrequency = showFrequencyParam;
        isEnabled = isEnabledParam;
        if (showFrequency==0) {
            isEnabled = NO;
        }
    }
    
    return self;
}

@end
