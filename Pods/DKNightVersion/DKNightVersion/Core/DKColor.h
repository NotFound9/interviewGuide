//
//  DKColor.h
//  DKNightVersion
//
//  Created by Draveness on 15/12/9.
//  Copyright © 2015年 DeltaX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString DKThemeVersion;

typedef UIColor *(^DKColorPicker)(DKThemeVersion *themeVersion);

DKColorPicker DKColorPickerWithRGB(NSUInteger normal, ...);
DKColorPicker DKColorPickerWithColors(UIColor *normalColor, ...);

@interface DKColor : NSObject

+ (DKColorPicker)colorPickerWithUIColor:(UIColor *)color;

+ (DKColorPicker)colorPickerWithWhite:(CGFloat)white alpha:(CGFloat)alpha;
+ (DKColorPicker)colorPickerWithHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha;
+ (DKColorPicker)colorPickerWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
+ (DKColorPicker)colorPickerWithCGColor:(CGColorRef)cgColor;
+ (DKColorPicker)colorPickerWithPatternImage:(UIImage *)image;
#if __has_include(<CoreImage/CoreImage.h>)
+ (DKColorPicker)colorPickerWithCIColor:(CIColor *)ciColor NS_AVAILABLE_IOS(5_0);
#endif

+ (DKColorPicker)blackColor;
+ (DKColorPicker)darkGrayColor;
+ (DKColorPicker)lightGrayColor;
+ (DKColorPicker)whiteColor;
+ (DKColorPicker)grayColor;
+ (DKColorPicker)redColor;
+ (DKColorPicker)greenColor;
+ (DKColorPicker)blueColor;
+ (DKColorPicker)cyanColor;
+ (DKColorPicker)yellowColor;
+ (DKColorPicker)magentaColor;
+ (DKColorPicker)orangeColor;
+ (DKColorPicker)purpleColor;
+ (DKColorPicker)brownColor;
+ (DKColorPicker)clearColor;

@end
