//
//  DKImage.h
//  DKNightVersion
//
//  Created by Draveness on 15/12/10.
//  Copyright © 2015年 DeltaX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString DKThemeVersion;

typedef UIImage *(^DKImagePicker)(DKThemeVersion *themeVersion);

/**
 *  A C function takes an array of images return a image picker, the
 *  order of the images is just like the themes order in DKColorTable.txt
 *  file.
 *
 *  @param normalImage Image when current themeVersion is DKThemeVersionNormal
 *  @param ...         Other images, the order is the same as DKColorTable
 *
 *  @return A DKImagePicker
 */
DKImagePicker DKImagePickerWithImages(UIImage *normalImage, ...);

/**
 *  A C function takes an array of names return a image picker, the
 *  order of the images is just like the themes order in DKColorTable.txt
 *  file.
 *
 *  @param normalName Names when current themeVersion is DKThemeVersionNormal
 *  @param ...        Other names, the order is the same as DKColorTable
 *
 *  @return A DKImagePicker
 */
DKImagePicker DKImagePickerWithNames(NSString *normalName, ...);

@interface DKImage : NSObject

/**
 *  A method takes an array of images return a image picker, the
 *  order of the images is just like the themes order in DKColorTable.txt
 *  file.
 *
 *  @param images An array of images
 *
 *  @return A DKImagePicker
 */
+ (DKImagePicker)pickerWithNames:(NSArray<NSString *> *)names;

/**
 *  A method takes an array of images return a image picker, the
 *  order of the images is just like the themes order in DKColorTable.txt
 *  file.
 *
 *  @param images An array of image names
 *
 *  @return A DKImagePicker
 */
+ (DKImagePicker)pickerWithImages:(NSArray<UIImage *> *)images;

/**
 *  Returns a image picker return the same image no matter what the current
 *  theme version is
 *
 *  @param name The name for image
 *
 *  @return A DKImagePicker
 */
+ (DKImagePicker)imageNamed:(NSString *)name;

/**
 *  Returns a image picker return night image when current theme version is
 *  DKThemeVersionNight, return normal image in other cases.
 *
 *  @param normalImage Normal image
 *  @param nightImage  Image returns when theme version is DKThemeVersionNight
 *
 *  @return A DKImagePicker
 */
+ (DKImagePicker)pickerWithNormalImage:(UIImage *)normalImage nightImage:(UIImage *)nightImage;

@end
