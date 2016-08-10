//
//  UITextField+Keyboard.m
//  DKNightVersion
//
//  Created by Draveness on 16/4/11.
//  Copyright © 2016年 Draveness. All rights reserved.
//

#import "UITextField+Keyboard.h"
#import "NSObject+Night.h"
#import <objc/runtime.h>

@interface NSObject ()

- (void)night_updateColor;

@end


@implementation UITextField (Keyboard)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(init);
        SEL swizzledSelector = @selector(dk_init);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });

}

- (instancetype)dk_init {
    UITextField *obj = [self dk_init];
    if (self.dk_manager.supportsKeyboard && [self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
#ifdef __IPHONE_7_0
        obj.keyboardAppearance = UIKeyboardAppearanceDark;
#else
        obj.keyboardAppearance = UIKeyboardAppearanceAlert;
#endif
    } else {
        obj.keyboardAppearance = UIKeyboardAppearanceDefault;
    }
    return obj;
}

- (void)night_updateColor {
    [super night_updateColor];
    if (self.dk_manager.supportsKeyboard && [self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
#ifdef __IPHONE_7_0
        self.keyboardAppearance = UIKeyboardAppearanceDark;
#else
        self.keyboardAppearance = UIKeyboardAppearanceAlert;
#endif
    } else {
        self.keyboardAppearance = UIKeyboardAppearanceDefault;
    }
}


@end
