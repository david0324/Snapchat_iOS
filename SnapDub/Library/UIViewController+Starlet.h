//
//  UIViewController+Starlet.h
//  Starlet
//
//  Created by Lion User on 10/15/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Starlet)

- (void)showHUD;
- (void)hideHUD;

- (void)showHUDWithTitle:(NSString*)title;
- (void)showHUDWithComplete:(void(^)(void))handler;

@end
