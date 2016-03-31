//
//  UIViewController+Starlet.m
//  Starlet
//
//  Created by Lion User on 10/15/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+Starlet.h"
#import <objc/runtime.h>
#import "MBProgressHUD.h"

#define MBProgressHUDKey    @"MBProgressHUD"

@interface UIViewController()
@property (strong, nonatomic) MBProgressHUD * HUD;

@end

@implementation UIViewController (Starlet)

- (MBProgressHUD*)HUD {
    return objc_getAssociatedObject(self, MBProgressHUDKey);
}

- (void)setHUD:(MBProgressHUD *)aHUD {
    objc_setAssociatedObject(self, MBProgressHUDKey, aHUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHUD {
    UIViewController* controller = self;
    if (self.tabBarController)
        controller = self.tabBarController;
    else if (self.navigationController)
        controller = self.navigationController;
    
    if (self.HUD == nil) {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        
        self.HUD.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];

        [self.view addSubview:self.HUD];
        [self.view bringSubviewToFront:self.HUD];
    }
    [self.HUD show:YES];
}

- (void)showHUDWithTitle:(NSString*)title {
    [self showHUD];
    self.HUD.labelText = title;
}

- (void)hideHUD {
    if (self.HUD) {
        [self.HUD hide:YES];
    }
}

- (void)showHUDWithComplete:(void(^)(void))handler {
    [self showHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideHUD];

        handler();
    });
}

@end
