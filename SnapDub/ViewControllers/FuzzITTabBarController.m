//
//  FuzzITTabBarController.m
//  FuzzITVerticalTabBarControllerDemo
//
//  Created by Tretter Matthias on 24.04.12.
//  Copyright (c) 2012 NOUS Wissensmanagement GmbH. All rights reserved.
//

#import "FuzzITTabBarController.h"

@interface FuzzITTabBarController ()

- (void)setupForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end

@implementation FuzzITTabBarController

- (id)initWithDelegate:(id<NGTabBarControllerDelegate>)delegate {
    self = [super initWithDelegate:delegate];
    if (self) {
        self.tabBar.tintColor = [UIColor colorWithRed:0.f/255.f green:191.f/255.f blue:142.f/255.f alpha:1.f];
        [self setupForInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
    }
    return self;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self setupForInterfaceOrientation:toInterfaceOrientation];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Private
////////////////////////////////////////////////////////////////////////

- (void)setupForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation; {
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        self.tabBarPosition = NGTabBarPositionBottom;
        self.tabBar.drawItemHighlight = YES;
        self.tabBar.layoutStrategy = NGTabBarLayoutStrategyCentered;
        self.tabBar.drawGloss = NO;
    } else {
        self.tabBarPosition = NGTabBarPositionLeft;
        self.tabBar.drawItemHighlight = NO;
        self.tabBar.drawGloss = NO;
        self.tabBar.layoutStrategy = NGTabBarLayoutStrategyStrungTogether;
    }
}

@end
