//
//  DKNightVersionManager.m
//  DKNightVersionManager
//
//  Created by Draveness on 4/14/15.
//  Copyright (c) 2015 Draveness. All rights reserved.
//

#import "DKNightVersionManager.h"

NSString * const DKThemeVersionNormal = @"NORMAL";
NSString * const DKThemeVersionNight = @"NIGHT";

NSString * const DKNightVersionThemeChangingNotificaiton = @"DKNightVersionThemeChangingNotificaiton";

CGFloat const DKNightVersionAnimationDuration = 0.3;

NSString * const DKNightVersionCurrentThemeVersionKey = @"com.dknightversion.manager.themeversion";

@interface DKNightVersionManager ()

@end

@implementation DKNightVersionManager

+ (DKNightVersionManager *)sharedManager {
    static dispatch_once_t once;
    static DKNightVersionManager *instance;
    dispatch_once(&once, ^{
        instance = [self new];
        instance.changeStatusBar = YES;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        DKThemeVersion *themeVersion = [userDefaults valueForKey:DKNightVersionCurrentThemeVersionKey];
        themeVersion = themeVersion ?: DKThemeVersionNormal;
        instance.themeVersion = themeVersion;
        instance.supportsKeyboard = YES;
    });
    return instance;
}

+ (DKNightVersionManager *)sharedNightVersionManager {
    return [self sharedManager];
}

- (void)nightFalling {
    self.themeVersion = DKThemeVersionNight;
}

- (void)dawnComing {
    self.themeVersion = DKThemeVersionNormal;
}

- (void)setThemeVersion:(DKThemeVersion *)themeVersion {
    if ([_themeVersion isEqualToString:themeVersion]) {
        // if type does not change, don't execute code below to enhance performance.
        return;
    }
    _themeVersion = themeVersion;

    // Save current theme version to user default
    [[NSUserDefaults standardUserDefaults] setValue:themeVersion forKey:DKNightVersionCurrentThemeVersionKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:DKNightVersionThemeChangingNotificaiton
                                                        object:nil];

    if (self.shouldChangeStatusBar) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if ([themeVersion isEqualToString:DKThemeVersionNight]) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
#pragma clang diagnostic pop
    }
}

@end
