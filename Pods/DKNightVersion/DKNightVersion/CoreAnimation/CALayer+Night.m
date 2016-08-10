//
//  CALayer+Night.m
//  DKNightVersion
//
//  Created by Draveness on 16/1/29.
//  Copyright © 2016年 DeltaX. All rights reserved.
//

#import "CALayer+Night.h"
#import <objc/runtime.h>

@interface CALayer ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, DKColorPicker> *pickers;

@end

@implementation CALayer (Night)

- (DKColorPicker)dk_shadowColorPicker {
    return objc_getAssociatedObject(self, @selector(dk_shadowColorPicker));
}

- (void)setDk_shadowColorPicker:(DKColorPicker)picker {
    objc_setAssociatedObject(self, @selector(dk_shadowColorPicker), picker, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.shadowColor = picker(self.dk_manager.themeVersion).CGColor;
    [self.pickers setValue:[picker copy] forKey:NSStringFromSelector(@selector(setShadowColor:))];
}

- (DKColorPicker)dk_borderColorPicker {
    return objc_getAssociatedObject(self, @selector(dk_borderColorPicker));
}

- (void)setDk_borderColorPicker:(DKColorPicker)picker {
    objc_setAssociatedObject(self, @selector(dk_borderColorPicker), picker, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.borderColor = picker(self.dk_manager.themeVersion).CGColor;
    [self.pickers setValue:[picker copy] forKey:NSStringFromSelector(@selector(setBorderColor:))];
}

- (DKColorPicker)dk_backgroundColorPicker {
    return objc_getAssociatedObject(self, @selector(dk_backgroundColorPicker));
}

- (void)setDk_backgroundColorPicker:(DKColorPicker)picker {
    objc_setAssociatedObject(self, @selector(dk_backgroundColorPicker), picker, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.backgroundColor = picker(self.dk_manager.themeVersion).CGColor;
    [self.pickers setValue:[picker copy] forKey:NSStringFromSelector(@selector(setBorderColor:))];
}

- (void)night_updateColor {
    [self.pickers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selector, DKColorPicker  _Nonnull picker, BOOL * _Nonnull stop) {
        CGColorRef result = picker(self.dk_manager.themeVersion).CGColor;
        [UIView animateWithDuration:DKNightVersionAnimationDuration
                         animations:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                             if ([selector isEqualToString:NSStringFromSelector(@selector(setShadowColor:))]) {
                                 [self setShadowColor:result];
                             } else if ([selector isEqualToString:NSStringFromSelector(@selector(setBorderColor:))]) {
                                 [self setBorderColor:result];
                             } else if ([selector isEqualToString:NSStringFromSelector(@selector(setBackgroundColor:)) ]) {
                                 [self setBackgroundColor:result];
                             }
#pragma clang diagnostic pop
                         }];
    }];
}

@end
