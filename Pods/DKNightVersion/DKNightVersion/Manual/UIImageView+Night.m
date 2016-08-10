//
//  UIImageView+Night.m
//  DKNightVersion
//
//  Created by Draveness on 15/12/10.
//  Copyright © 2015年 DeltaX. All rights reserved.
//

#import "UIImageView+Night.h"
#import "NSObject+Night.h"
#import <objc/runtime.h>

@interface NSObject ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, DKColorPicker> *pickers;

@end

@implementation UIImageView (Night)

- (instancetype)dk_initWithImagePicker:(DKImagePicker)picker {
    UIImageView *imageView = [self initWithImage:picker(self.dk_manager.themeVersion)];
    imageView.dk_imagePicker = [picker copy];
    return imageView;
}

- (DKImagePicker)dk_imagePicker {
    return objc_getAssociatedObject(self, @selector(dk_imagePicker));
}

- (void)dk_setImagePicker:(DKImagePicker)picker {
    objc_setAssociatedObject(self, @selector(dk_imagePicker), picker, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.image = picker(self.dk_manager.themeVersion);
    [self.pickers setValue:[picker copy] forKey:@"setImage:"];

}

@end
