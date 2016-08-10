//
//  UINavigationBar+Animation.m
//  DKNightVersion
//
//  Created by Draveness on 15/5/4.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

#import "UINavigationBar+Animation.h"

CGFloat const stepDuration = 0.01;

@implementation UINavigationBar (Animation)

- (void)animateNavigationBarToColor:(UIColor *)toColor duration:(NSTimeInterval)duration {
    if (!self.barTintColor || !toColor) {
        return;
    }
    UIColor *barDefaultColor = [UIColor colorWithRed:0.973 green:0.973 blue:0.973 alpha:1.0];

    UIColor *barTintColor = self.barTintColor ? : barDefaultColor;
    toColor = toColor ? : barDefaultColor;
    NSUInteger steps = duration / stepDuration;

    CGFloat fromRed, fromGreen, fromBlue, fromAlpha;
    CGFloat toRed, toGreen, toBlue, toAlpha;

    [barTintColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];

    CGFloat diffRed = toRed - fromRed;
    CGFloat diffGreen = toGreen - fromGreen;
    CGFloat diffBlue = toBlue - fromBlue;
    CGFloat diffAlpha = toAlpha - fromAlpha;

    NSMutableArray *colorArray = [NSMutableArray array];

    [colorArray addObject:barTintColor];

    for (NSUInteger i = 0; i < steps - 1; ++i) {
        CGFloat red = fromRed + diffRed / steps * (i + 1);
        CGFloat green = fromGreen + diffGreen / steps * (i + 1);
        CGFloat blue = fromBlue + diffBlue / steps * (i + 1);
        CGFloat alpha = fromAlpha + diffAlpha / steps * (i + 1);

        UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        [colorArray addObject:color];
    }

    [colorArray addObject:toColor];
    [self animateWithArray:colorArray];
}

- (void)animateWithArray:(NSMutableArray *)array {
    NSUInteger counter = 0;

    for (UIColor *color in array) {
        double delayInSeconds = stepDuration * counter++;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [UIView animateWithDuration:stepDuration animations:^{
                self.barTintColor = color;
            }];
        });
    }
}


@end
